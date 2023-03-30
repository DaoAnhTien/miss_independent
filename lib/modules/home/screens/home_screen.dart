import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/modules/home/bloc/home_posts_cubit.dart';
import 'package:miss_independent/modules/home/bloc/home_posts_state.dart';
import 'package:miss_independent/modules/home/widgets/home_tabs.dart';
import 'package:miss_independent/modules/home/widgets/post_item.dart';

import '../../../common/constants/routes.dart';
import '../../../common/event/event_bus_event.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../di/injection.dart';
import '../../../models/post.dart';
import '../../../widgets/list_content.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../common/screens/exception_error_screen.dart';
import '../widgets/bottomsheet_add_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with EventBusMixin {
  HomePostType _selectedType = HomePostType.popular;
  late StreamSubscription _streamSubscription;
  late StreamSubscription _exceptionSubscription;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AuthCubit>().getMyProfile();
      _streamSubscription =
          listenEvent<LogoutEvent>((LogoutEvent event) => _logout());
      _exceptionSubscription = listenEvent<ApiExceptionEvent>(
          (ApiExceptionEvent event) => _showExceptionError(event));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) =>
            getIt<HomePostsCubit>()..changeType(_selectedType.rawValue),
        child: BlocConsumer<HomePostsCubit, HomePostsState>(
          listenWhen: (previous, current) =>
              previous.delPostStatus != current.delPostStatus,
          listener: (context, state) {
            if (state.delPostStatus == RequestStatus.failed &&
                state.message?.isNotEmpty == true) {
              showErrorMessage(context, state.message!);
            }
          },
          builder: (BuildContext context, HomePostsState state) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: HomeTabs(
                      selected: _selectedType,
                      onChanged: (HomePostType type) =>
                          _onChangedTab(context, type)),
                ),
                Expanded(
                  child: ListContent<Post>(
                    list: state.posts,
                    status: state.status,
                    errMsg: state.message,
                    onRefresh: () => _onRefresh(context),
                    onLoadMore: () => _onLoadMore(context),
                    itemBuilder: (Post item) {
                      return PostItem(
                        post: item,
                        onDelPost: () => _onDelPost(context, item.id ?? 0),
                        onLikePost: () => _onLikePost(context, item.id ?? 0),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return const BottomSheetAddPost();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onChangedTab(BuildContext context, HomePostType type) {
    setState(() {
      _selectedType = type;
    });
    context.read<HomePostsCubit>().changeType(type.rawValue);
  }

  void _logout() {
    context.read<AuthCubit>().logout();
    Navigator.of(context).pushReplacementNamed(kLoginRoute);
  }

  void _showExceptionError(ApiExceptionEvent event) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExceptionErrorScreen(event: event),
    ));
  }

  void _onRefresh(BuildContext context) {
    context.read<HomePostsCubit>().refreshItems();
  }

  void _onDelPost(BuildContext context, int postId) {
    context.read<HomePostsCubit>().delPost(postId);
  }

  void _onLikePost(BuildContext context, int postId) {
    context.read<HomePostsCubit>().likePost(postId);
  }

  void _onLoadMore(BuildContext context) {
    context.read<HomePostsCubit>().loadMoreItems();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _exceptionSubscription.cancel();
    super.dispose();
  }
}

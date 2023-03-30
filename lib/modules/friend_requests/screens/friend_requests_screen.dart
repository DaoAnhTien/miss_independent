import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/modules/friend_requests/bloc/friend_request_cubit.dart';
import 'package:miss_independent/modules/friend_requests/bloc/friend_request_state.dart';
import 'package:miss_independent/modules/friend_requests/widgets/friend_request_item.dart';
import 'package:miss_independent/widgets/list_content.dart';
import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../generated/l10n.dart';
import '../../../models/friend_request.dart';
import '../../../models/pagination.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).friendRequest,
          ),
        ),
        body: BlocProvider(
          create: (BuildContext context) =>
              getIt<FriendRequestCubit>()..fetchItems(isInit: true),
          child: BlocConsumer<FriendRequestCubit, FriendRequestState>(
            builder: (context, state) {
              return ListContent<FriendRequest>(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  list: state.friendRequests,
                  status: state.status,
                  onRefresh: () => _onRefresh(context),
                  itemBuilder: (FriendRequest item) {
                    return FriendRequestItem(
                      data: item,
                    );
                  });
            },
            listenWhen: (FriendRequestState prev, FriendRequestState current) =>
                prev.status != current.status ||
                prev.actionStatus != current.actionStatus,
            listener: (context, FriendRequestState state) {
              if ((state.status == DataSourceStatus.failed ||
                      state.actionStatus == RequestStatus.failed) &&
                  (state.message?.isNotEmpty ?? false)) {
                showErrorMessage(context, state.message!);
              }
            },
          ),
        ));
  }

  void _onRefresh(BuildContext context) {
    context.read<FriendRequestCubit>().fetchItems();
  }
}

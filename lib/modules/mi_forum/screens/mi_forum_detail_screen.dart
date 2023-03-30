import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:miss_independent/common/utils/extensions/build_context_extension.dart";
import "package:miss_independent/di/injection.dart";
import "package:miss_independent/generated/l10n.dart";
import "package:miss_independent/models/forum.dart";
import "package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_cubit.dart";
import "package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_members_cubit.dart";
import "package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_popular_posts_cubit.dart";
import "package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_state.dart";
import "package:miss_independent/modules/mi_forum/widgets/mi_forum_detail_tabs.dart";
import "package:miss_independent/widgets/button.dart";
import "package:miss_independent/widgets/cached_image.dart";

import "../../../common/constants/routes.dart";
import "../bloc/mi_forum_detail_all_posts_cubit.dart";
import "../widgets/mi_forum_detail_forum_tab.dart";
import "../widgets/mi_forum_detail_home_tab.dart";
import "../widgets/mi_forum_detail_members_tab.dart";

class MIForumDetailScreen extends StatefulWidget {
  const MIForumDetailScreen({super.key});

  @override
  State<MIForumDetailScreen> createState() => _MIForumDetailScreenState();
}

class _MIForumDetailScreenState extends State<MIForumDetailScreen> {
  MiForumDetailTab _selectedType = MiForumDetailTab.home;
  @override
  Widget build(BuildContext context) {
    final Forum? forum = context.getRouteArguments<Forum>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<MiForumDetailCubit>()
            ..initForum(forum)
            ..getForumDetail(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<MiForumDetailMembersCubit>()..fetchItems(forum?.id ?? 0),
        ),
        BlocProvider(
          create: (_) => getIt<MIForumDetailPopularPostsCubit>()
            ..fetchItems(forum?.id ?? 0),
        ),
        BlocProvider(
          create: (_) =>
              getIt<MIForumDetailAllPostsCubit>()..fetchItems(forum?.id ?? 0),
        ),
      ],
      child: BlocConsumer<MiForumDetailCubit, MiForumDetailState>(
        builder: (context, MiForumDetailState state) => Scaffold(
          appBar: AppBar(
            title: Text(state.forum?.name ?? ""),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(state.forum?.liked == true
                    ? CupertinoIcons.hand_thumbsup_fill
                    : CupertinoIcons.hand_thumbsup),
                onPressed: () {
                  context.read<MiForumDetailCubit>().likeForum();
                },
              )
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      CachedImage(
                        url: state.forum?.image,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: MiForumDetailTabs(
                                selected: _selectedType,
                                onChanged: (MiForumDetailTab type) =>
                                    _onChangedTab(context, type),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                                constraints: const BoxConstraints(minWidth: 80),
                                child: _renderButton(
                                    context, state.forum?.joined)),
                          ],
                        ),
                      ),
                      _selectedType == MiForumDetailTab.forum
                          ? const ForumTab()
                          : _selectedType == MiForumDetailTab.home
                              ? const HomeTab()
                              : MembersTab(forum: forum),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(kAddPostRouter, arguments: false);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        listener: (context, MiForumDetailState state) {},
      ),
    );
  }

  Widget _renderButton(BuildContext context, bool? isJoined) {
    return isJoined == true
        ? BasicButton(
            label: S.of(context).leave,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 56,
            onPressed: () => context.read<MiForumDetailCubit>().leaveForum(),
          )
        : BasicButton(
            label: S.of(context).join,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 56,
            onPressed: () => context.read<MiForumDetailCubit>().joinForum(),
          );
  }

  void _onChangedTab(BuildContext context, MiForumDetailTab type) {
    setState(() {
      _selectedType = type;
    });
  }
}

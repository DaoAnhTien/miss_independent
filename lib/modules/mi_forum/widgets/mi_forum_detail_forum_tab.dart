import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/routes.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/comments_list/comments_list.dart';
import '../../../widgets/text_field.dart';
import '../../home/widgets/post_item.dart';
import '../bloc/mi_forum_detail_popular_posts_cubit.dart';
import '../bloc/mi_forum_detail_popular_posts_state.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({
    super.key,
  });

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  String? _currentSortBy;
  @override
  Widget build(BuildContext context) {
    List<String> sortByList = [
      S.of(context).latest,
      S.of(context).oldest,
      S.of(context).popular,
    ];
    return BlocBuilder<MIForumDetailPopularPostsCubit,
            MIForumDetailPopularPostsState>(
        builder: (context, MIForumDetailPopularPostsState state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectTextField(
                  onChanged: (String? value) {
                    setState(() {
                      _currentSortBy = value;
                    });
                  },
                  value: _currentSortBy,
                  items: sortByList
                      .map((e) => SelectTextFieldArg(label: e, value: e))
                      .toList(),
                ),
                const SizedBox(height: 12),
                state.posts?.isNotEmpty == true
                    ? Column(
                        children: state.posts!.map((e) {
                          return PostItem(
                            padding: EdgeInsets.zero,
                            post: e,
                            onLikePost: () => context
                                .read<MIForumDetailPopularPostsCubit>()
                                .likePost(e.forumId ?? 0, e.id ?? 0),
                            onCommentsTap: () => Navigator.of(context)
                                .pushNamed(kPostCommentsRoute,
                                    arguments:
                                        CommentsListArgs.initForumPostComments(
                                            e.id ?? 0, e.forumId ?? 0)),
                          );
                        }).toList(),
                      )
                    : const SizedBox()
              ],
            ));
  }
}

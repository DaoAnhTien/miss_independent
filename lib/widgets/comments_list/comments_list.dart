import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/generated/l10n.dart';

import '../../common/constants/routes.dart';
import '../../common/enums/status.dart';
import '../../common/utils/toast.dart';
import '../../di/injection.dart';
import '../../models/pagination.dart';
import '../../models/post_comment.dart';
import '../../modules/auth/helpers/validator.dart';
import '../../modules/post_comments/widgets/post_comment_item.dart';
import '../list_content.dart';
import '../text_field.dart';
import 'bloc/post_comments_cubit.dart';
import 'bloc/post_comments_state.dart';

enum CommentsListType { post, forum, postForum }

class CommentsListArgs {
  const CommentsListArgs({this.postId, this.forumId, required this.type});
  final int? postId;
  final int? forumId;
  final CommentsListType type;

  factory CommentsListArgs.initPostComments(int postId) =>
      CommentsListArgs(postId: postId, type: CommentsListType.post);

  factory CommentsListArgs.initForumPostComments(int postId, int forumId) =>
      CommentsListArgs(
          postId: postId, forumId: forumId, type: CommentsListType.postForum);
  factory CommentsListArgs.initForumComments(int forumId) =>
      CommentsListArgs(forumId: forumId, type: CommentsListType.forum);
}

class CommentsList extends StatefulWidget {
  const CommentsList({
    super.key,
    this.scrollEnabled = true,
    required this.args,
    this.enableViewAll = false,
  });
  final bool scrollEnabled;
  final bool enableViewAll;
  final CommentsListArgs args;

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCommentsCubit>(
        create: (_) => getIt<PostCommentsCubit>()
          ..init(widget.args)
          ..fetchComments(isInit: true),
        child: BlocConsumer<PostCommentsCubit, PostCommentsState>(
            listenWhen: (PostCommentsState prev, PostCommentsState current) =>
                prev.status != current.status ||
                prev.sendStatus != current.sendStatus,
            listener: (context, PostCommentsState state) {
              if ((state.status == DataSourceStatus.failed ||
                      state.sendStatus == RequestStatus.failed) &&
                  (state.message?.isNotEmpty ?? false)) {
                showErrorMessage(context, state.message!);
              }
            },
            builder: (context, state) {
              if (widget.scrollEnabled) {
                return Column(
                  children: [
                    Expanded(
                      child: ListContent<PostComment>(
                        controller: controller,
                        list: state.postComments,
                        status: state.status,
                        onRefresh: () {
                          context.read<PostCommentsCubit>().fetchComments();
                        },
                        itemBuilder: (PostComment postComment) {
                          return PostCommentItem(
                            key: Key('${postComment.id}'),
                            postComment: postComment,
                            args: widget.args,
                          );
                        },
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: BasicTextField(
                        controller: _commentController,
                        hintText: S.of(context).writeAComment,
                        suffixIcon: IconButton(
                          icon: state.sendStatus == RequestStatus.requesting
                              ? const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  size: 28,
                                ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context
                                  .read<PostCommentsCubit>()
                                  .commentPost(_commentController.text);
                              _commentController.clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                controller.jumpTo(0);
                              });
                            }
                          },
                        ),
                        validator: CommentPostValidator.commentValidation,
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  children: [
                    ...?state.postComments
                        ?.map((e) => PostCommentItem(
                              postComment: e,
                              args: widget.args,
                            ))
                        .toList(),
                    if (widget.enableViewAll &&
                        (state.postComments?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  kPostCommentsRoute,
                                  arguments: state.args);
                            },
                            child: Text(S.of(context).viewAllComments)),
                      )
                  ],
                );
              }
            }));
  }
}

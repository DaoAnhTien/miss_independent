import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';

import '../../../common/constants/routes.dart';
import '../../../common/enums/status.dart';
import '../../../common/theme/colors.dart';
import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../generated/l10n.dart';
import '../../../models/post_comment.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/comments_list/bloc/comment_reply_cubit.dart';
import '../../../widgets/comments_list/bloc/comment_reply_state.dart';
import '../../../widgets/comments_list/comments_list.dart';
import '../../../widgets/text_field.dart';
import '../../auth/helpers/validator.dart';
import 'bottomsheet_comment_actions.dart';

class ReplyCommentItem extends StatefulWidget {
  const ReplyCommentItem({
    super.key,
    required this.commentReply,
    required this.userId,
    required this.commentId,
    this.args,
  });
  final CommentReply commentReply;
  final int userId;
  final int commentId;
  final CommentsListArgs? args;
  @override
  State<ReplyCommentItem> createState() => _ReplyCommentItemState();
}

class _ReplyCommentItemState extends State<ReplyCommentItem> {
  final TextEditingController _editCommentController = TextEditingController();
  final FocusNode _editFocusNode = FocusNode();
  bool _isEditComment = false;
  final _formEditKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _editFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CommentReplyCubit>()
        ..init(widget.args, widget.commentId, widget.commentReply),
      child: BlocConsumer<CommentReplyCubit, CommentReplyState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.editStatus != current.editStatus,
        listener: (context, state) {
          if ((state.status == RequestStatus.failed) &&
              state.message?.isNotEmpty == true) {
            showErrorMessage(context, state.message!);
          }
          if (state.editStatus == RequestStatus.success) {
            setState(() {
              _isEditComment = false;
            });
          }
        },
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kLightGreyColor))),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, kUserProfileRouter,
                    arguments: state.reply?.user),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImage(
                      url: state.reply?.user?.image,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      radius: 15,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    state.reply?.user?.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  if (state.reply?.createdAt != null)
                                    Text(
                                      state.reply!.createdAt!.toTimeAgo(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                ],
                              ),
                              if (widget.userId == state.reply?.userId)
                                GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext ctx) {
                                        return BottomSheetCommentActions(
                                          isMe: widget.userId ==
                                              state.reply?.userId,
                                          onDelete: () => context
                                              .read<CommentReplyCubit>()
                                              .deleteCommentPostReply(),
                                          editComment: (bool isEdit) {
                                            setState(() {
                                              _editCommentController.text =
                                                  state.reply?.reply ?? "";
                                              _isEditComment = isEdit;
                                            });
                                            _editFocusNode.requestFocus();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                  ),
                                )
                            ],
                          ),
                          _isEditComment
                              ? Form(
                                  key: _formEditKey,
                                  child: Column(
                                    children: [
                                      BasicTextField(
                                        controller: _editCommentController,
                                        multiline: true,
                                        focusNode: _editFocusNode,
                                        validator: CommentPostValidator
                                            .commentValidation,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              S.of(context).cancel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isEditComment = false;
                                              });
                                            },
                                          ),
                                          state.editStatus ==
                                                  RequestStatus.requesting
                                              ? const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : TextButton(
                                                  child: Text(
                                                    S.of(context).save,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                            color:
                                                                kPrimaryColor),
                                                  ),
                                                  onPressed: () async {
                                                    if (_formEditKey
                                                        .currentState!
                                                        .validate()) {
                                                      await context
                                                          .read<
                                                              CommentReplyCubit>()
                                                          .editCommentPostReply(
                                                              widget.userId,
                                                              _editCommentController
                                                                  .text);
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    }
                                                  },
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Text(
                                  state.reply?.reply ?? "",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

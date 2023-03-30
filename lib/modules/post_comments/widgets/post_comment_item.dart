import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
import 'package:miss_independent/widgets/comments_list/bloc/comment_state.dart';

import '../../../common/enums/status.dart';
import '../../../common/utils/toast.dart';
import '../../../generated/l10n.dart';
import '../../../models/post_comment.dart';
import '../../../widgets/comments_list/bloc/comment_cubit.dart';
import '../../../widgets/comments_list/comments_list.dart';
import '../../../widgets/text_field.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/helpers/validator.dart';
import 'bottomsheet_comment_actions.dart';
import 'comment_reply_item.dart';

class PostCommentItem extends StatefulWidget {
  const PostCommentItem({
    super.key,
    required this.postComment,
    this.padding,
    this.onFocus = false,
    this.args,
  });
  final PostComment postComment;
  final bool onFocus;
  final EdgeInsetsGeometry? padding;
  final CommentsListArgs? args;

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  bool _showReplies = false;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _editCommentController = TextEditingController();
  final FocusNode _editFocusNode = FocusNode();
  bool _showReplyTextField = false;
  final _formKey = GlobalKey<FormState>();
  final _formEditKey = GlobalKey<FormState>();
  bool _isEditComment = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? userId = context.read<AuthCubit>().state.user?.id;
    return BlocProvider(
      create: (context) =>
          getIt<CommentCubit>()..init(widget.args, widget.postComment),
      child: BlocConsumer<CommentCubit, CommentState>(
        listenWhen: (previous, current) =>
            previous.delStatus != current.delStatus ||
            previous.sendStatus != current.sendStatus ||
            previous.editStatus != current.editStatus,
        listener: (context, state) {
          if (state.status == RequestStatus.failed &&
              (state.delStatus == RequestStatus.failed ||
                  state.editStatus == RequestStatus.failed ||
                  state.sendStatus == RequestStatus.failed) &&
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
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kLightGreyColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pushNamed(context, kUserProfileRouter,
                    arguments: state.comment?.user),
                child: Row(
                  children: [
                    CachedImage(
                        url: state.comment?.user?.image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        radius: 25),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.comment?.user?.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${state.comment?.createdAt?.toTimeAgo()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 0,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext ctx) {
                                    return BottomSheetCommentActions(
                                      args: state.args,
                                      comment: state.comment,
                                      isMe: userId == state.comment?.userId,
                                      onDelete: () => context
                                          .read<CommentCubit>()
                                          .deleteCommentPost(),
                                      editComment: (bool isEdit) {
                                        setState(() {
                                          _editCommentController.text =
                                              widget.postComment.text ?? "";
                                          _isEditComment = isEdit;
                                        });
                                        _editFocusNode.requestFocus();
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_horiz,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 58),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                          color: kPrimaryColor),
                                                ),
                                                onPressed: () async {
                                                  if (_formEditKey.currentState!
                                                      .validate()) {
                                                    await context
                                                        .read<CommentCubit>()
                                                        .editCommentPost(
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
                                state.comment?.text ?? "",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state.comment?.replies?.isNotEmpty == true
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showReplies = !_showReplies;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "${state.comment?.replies?.length} ${S.of(context).replies}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                        Icon(
                                          _showReplies
                                              ? Icons.arrow_drop_up_sharp
                                              : Icons.arrow_drop_down_sharp,
                                          size: 24,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Flexible(
                                flex: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showReplyTextField =
                                          !_showReplyTextField;
                                    });
                                  },
                                  child: Text(
                                    S.of(context).reply,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (_showReplies)
                          Column(
                            children: state.comment!.replies!
                                .map(
                                  (e) => ReplyCommentItem(
                                    commentReply: e,
                                    commentId: state.comment?.id ?? 0,
                                    args: state.args,
                                    userId: userId ?? 0,
                                  ),
                                )
                                .toList(),
                          ),
                        if (_showReplyTextField)
                          Form(
                            key: _formKey,
                            child: BasicTextField(
                              controller: _commentController,
                              hintText: S.of(context).writeAComment,
                              suffixIcon: state.sendStatus ==
                                      RequestStatus.requesting
                                  ? const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        size: 24,
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await context
                                              .read<CommentCubit>()
                                              .replyCommentPost(userId ?? 0,
                                                  _commentController.text);
                                          _commentController.clear();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        }
                                      },
                                    ),
                              validator: CommentPostValidator.commentValidation,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

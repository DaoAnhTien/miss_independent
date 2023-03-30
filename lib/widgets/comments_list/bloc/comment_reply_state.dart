import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/post_comment.dart';
import '../comments_list.dart';

class CommentReplyState extends Equatable {
  const CommentReplyState(
      {this.args,
      this.commentId,
      this.reply,
      this.message,
      this.status = RequestStatus.initial,
      this.delStatus = RequestStatus.initial,
      this.editStatus = RequestStatus.initial});

  final CommentsListArgs? args;
  final int? commentId;
  final CommentReply? reply;
  final RequestStatus editStatus;
  final RequestStatus status;
  final RequestStatus delStatus;
  final String? message;

  CommentReplyState copyWith({
    CommentsListArgs? args,
    int? commentId,
    CommentReply? reply,
    RequestStatus? editStatus,
    RequestStatus? status,
    RequestStatus? delStatus,
    String? message,
  }) {
    return CommentReplyState(
      args: args ?? this.args,
      commentId: commentId ?? this.commentId,
      reply: reply ?? this.reply,
      delStatus: delStatus ?? this.delStatus,
      message: message ?? this.message,
      status: status ?? this.status,
      editStatus: editStatus ?? this.editStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        args,
        commentId,
        reply,
        delStatus,
        message,
        status,
        editStatus,
      ];
}

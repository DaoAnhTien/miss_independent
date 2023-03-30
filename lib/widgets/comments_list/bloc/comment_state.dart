import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/post_comment.dart';
import '../comments_list.dart';

class CommentState extends Equatable {
  const CommentState(
      {this.args,
      this.comment,
      this.message,
      this.sendStatus = RequestStatus.initial,
      this.status = RequestStatus.initial,
      this.delStatus = RequestStatus.initial,
      this.editStatus = RequestStatus.initial});

  final CommentsListArgs? args;
  final PostComment? comment;
  final RequestStatus editStatus;
  final RequestStatus status;
  final RequestStatus sendStatus;
  final RequestStatus delStatus;
  final String? message;

  CommentState copyWith({
    CommentsListArgs? args,
    PostComment? comment,
    RequestStatus? editStatus,
    RequestStatus? status,
    RequestStatus? delStatus,
    String? message,
    RequestStatus? sendStatus,
  }) {
    return CommentState(
      args: args ?? this.args,
      comment: comment ?? this.comment,
      delStatus: delStatus ?? this.delStatus,
      status: status ?? this.status,
      message: message ?? this.message,
      sendStatus: sendStatus ?? this.sendStatus,
      editStatus: editStatus ?? this.editStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        args,
        comment,
        delStatus,
        message,status,
        sendStatus,
        editStatus
      ];
}

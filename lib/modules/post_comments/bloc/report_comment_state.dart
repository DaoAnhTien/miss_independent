import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/post_comment.dart';
import '../../../widgets/comments_list/comments_list.dart';

class ReportCommentState extends Equatable {
  const ReportCommentState(
      {this.comment,
      this.message,
      this.args,
      this.status = RequestStatus.initial});
  final PostComment? comment;
  final CommentsListArgs? args;
  final RequestStatus status;
  final String? message;

  ReportCommentState copyWith({
    PostComment? comment,
    RequestStatus? status,
    CommentsListArgs? args,
    String? message,
  }) {
    return ReportCommentState(
      comment: comment ?? this.comment,
      message: message ?? this.message,
      args: args ?? this.args,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => <Object?>[comment, message, args, status];
}

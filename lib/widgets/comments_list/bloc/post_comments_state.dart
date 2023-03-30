import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/pagination.dart';

import '../../../models/post_comment.dart';
import '../comments_list.dart';

class PostCommentsState extends Equatable {
  const PostCommentsState({
    this.args,
    this.postComments,
    this.status = DataSourceStatus.initial,
    this.message,
    this.sendStatus = RequestStatus.initial,
  });

  final CommentsListArgs? args;
  final List<PostComment>? postComments;
  final DataSourceStatus status;
  final String? message;
  final RequestStatus sendStatus;

  PostCommentsState copyWith({
    CommentsListArgs? args,
    List<PostComment>? postComments,
    DataSourceStatus? status,
    String? message,
    RequestStatus? sendStatus,
  }) {
    return PostCommentsState(
      args: args ?? this.args,
      postComments: postComments ?? this.postComments,
      status: status ?? this.status,
      message: message ?? this.message,
      sendStatus: sendStatus ?? this.sendStatus,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[args, postComments, status, message, sendStatus];
}

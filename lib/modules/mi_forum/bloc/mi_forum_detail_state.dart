import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import '../../../models/forum.dart';

class MiForumDetailState extends Equatable {
  const MiForumDetailState(
      {this.forum,
      this.status = RequestStatus.initial,
      this.sendStatus = RequestStatus.initial,
      this.replyStatus = RequestStatus.initial,
      this.message});

  final Forum? forum;
  final RequestStatus status;
  final RequestStatus sendStatus;
  final RequestStatus replyStatus;
  final String? message;

  MiForumDetailState copyWith(
      {Forum? forum,
      RequestStatus? status,
      RequestStatus? sendStatus,
      RequestStatus? replyStatus,
      String? message}) {
    return MiForumDetailState(
        forum: forum ?? this.forum,
        status: status ?? this.status,
        sendStatus: sendStatus ?? this.sendStatus,
        replyStatus: replyStatus ?? this.replyStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[forum, status, sendStatus, replyStatus, message];
}

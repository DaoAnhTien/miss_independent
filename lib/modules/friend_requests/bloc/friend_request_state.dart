import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/pagination.dart';
import '../../../models/friend_request.dart';

class FriendRequestState extends Equatable {
  const FriendRequestState(
      {this.friendRequests,
      this.status = DataSourceStatus.initial,
      this.actionStatus = RequestStatus.initial,
      this.message});

  final List<FriendRequest>? friendRequests;
  final DataSourceStatus status;
  final String? message;

  final RequestStatus actionStatus;

  FriendRequestState copyWith(
      {List<FriendRequest>? friendRequests,
      DataSourceStatus? status,
      RequestStatus? actionStatus,
      String? message}) {
    return FriendRequestState(
        friendRequests: friendRequests ?? this.friendRequests,
        status: status ?? this.status,
        actionStatus: actionStatus ?? this.actionStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[friendRequests, status, actionStatus, message];
}

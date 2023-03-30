import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/friend.dart';

import '../../../models/pagination.dart';

class FriendsState extends Equatable {
  const FriendsState(
      {this.type,
      this.friends,
      this.status = DataSourceStatus.initial,
      this.message});

  final String? type;
  final List<Friend>? friends;
  final DataSourceStatus status;
  final String? message;

  FriendsState copyWith(
      {String? type,
      List<Friend>? friends,
      DataSourceStatus? status,
      String? message}) {
    return FriendsState(
        type: type ?? this.type,
        friends: friends ?? this.friends,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[type, friends, status, message];
}

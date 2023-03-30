import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/user_profile.dart';

class UserProfileState extends Equatable {
  const UserProfileState(
      {this.type,
      this.userProfile,
      this.status = RequestStatus.initial,
      this.addFriendStatus = RequestStatus.initial,
      this.followStatus = RequestStatus.initial,
      this.message});

  final String? type;
  final UserProfile? userProfile;
  final RequestStatus status;
  final RequestStatus addFriendStatus;
  final RequestStatus followStatus;
  final String? message;

  UserProfileState copyWith(
      {String? type,
      UserProfile? userProfile,
      RequestStatus? status,
      RequestStatus? addFriendStatus,
      RequestStatus? followStatus,
      String? message}) {
    return UserProfileState(
        type: type ?? this.type,
        userProfile: userProfile ?? this.userProfile,
        status: status ?? this.status,
        addFriendStatus: addFriendStatus ?? this.addFriendStatus,
        followStatus: followStatus ?? this.followStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[
        type,
        userProfile,
        status,
        addFriendStatus,
        followStatus,
        message
      ];
}

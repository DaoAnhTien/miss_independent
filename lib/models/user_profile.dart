import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/user.dart';

class UserProfile extends Equatable {
  const UserProfile(
      {this.isFriend, this.followBit, this.likeBit, this.user, this.request});

  final User? user;
  final bool? followBit;
  final bool? likeBit;
  final bool? isFriend;
  final bool? request;

  factory UserProfile.fromJson(Map<String?, dynamic> json) => UserProfile(
        user: json['UserProfile'] != null
            ? User.fromProfileJson(json['UserProfile'])
            : null,
        followBit: json['follow_bit'] == 1,
        likeBit: json['like_bit'] == 1,
        isFriend: json['isfriend'] == 1,
        request: json['Request'] == 1,
      );

  factory UserProfile.fromLocal(Map<String?, dynamic> json) =>
      UserProfile.fromJson(json);

  UserProfile copyWith(
      {User? user,
      bool? isFriend,
      bool? followBit,
      bool? likeBit,
      bool? request}) {
    return UserProfile(
      user: user ?? this.user,
      followBit: followBit ?? this.followBit,
      isFriend: isFriend ?? this.isFriend,
      likeBit: likeBit ?? this.likeBit,
      request: request ?? this.request,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "follow_bit": followBit == true ? 1 : 0,
      "like_bit": likeBit == true ? 1 : 0,
      "isfriend": isFriend == true ? 1 : 0,
      "Request": request == true ? 1 : 0
    };
  }

  @override
  List<Object?> get props => [user, followBit, likeBit, isFriend, request];
}

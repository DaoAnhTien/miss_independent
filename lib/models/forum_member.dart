import 'package:equatable/equatable.dart';

import 'user.dart';

class ForumMember extends Equatable {
  const ForumMember({this.forumId, this.member});

  final int? forumId;
  final User? member;

  factory ForumMember.fromJson(Map<String?, dynamic> json) => ForumMember(
        forumId: json['fourm_id'],
        member: User.fromForumMemberJson(json),
      );

  factory ForumMember.fromLocal(Map<String?, dynamic> json) =>
      ForumMember.fromJson(json);

  ForumMember copyWith({int? forumId, User? member}) {
    return ForumMember(
      forumId: forumId ?? this.forumId,
      member: member ?? this.member,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fourm_id": forumId,
      "user_id": member?.id,
      "user_name": member?.name,
      "user_role": member?.role?.name,
      "full_image_link": member?.image,
    };
  }

  @override
  List<Object?> get props => [forumId, member];
}

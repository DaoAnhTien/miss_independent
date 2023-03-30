import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/user.dart';

import '../common/utils/utils.dart';
import 'asset.dart';

enum PostType { text, image, video, youtubeLink }

extension PostTypeX on PostType {
  int get rawValue {
    switch (this) {
      case PostType.text:
        return 1;
      case PostType.image:
        return 2;
      case PostType.video:
        return 3;
      case PostType.youtubeLink:
        return 4;
    }
  }

  static PostType? initFrom(int? value) {
    return PostType.values
        .firstWhereOrNull((PostType e) => e.rawValue == value);
  }
}

class Post extends Equatable {
  const Post({
    this.id,
    this.forumId,
    this.text,
    this.title,
    this.type,
    this.totalComments,
    this.totalLikes,
    this.user,
    this.assets,
    this.createdAt,
    this.updatedAt,
    this.likedByLoggedInUser,
  });

  final int? id;
  final int? forumId;
  final String? text;
  final String? title;
  final PostType? type;
  final int? totalComments;
  final int? totalLikes;
  final User? user;
  final List<Asset>? assets;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? likedByLoggedInUser;

  factory Post.fromJson(Map<String?, dynamic> json) => Post(
        id: parseInt(json['id']),
        text: json['text'],
        title: json['title'],
        type: json['post_type'] != null
            ? PostTypeX.initFrom(json['post_type'])
            : null,
        totalComments: parseInt(json['total_comments']),
        totalLikes: parseInt(json['total_liks']),
        user: json['user'] != null && json['user'] is Map
            ? User.fromJson(json['user'])
            : null,
        assets: json['assets'] != null && json['assets'] is List
            ? List.from(json['assets']).map((e) => Asset.fromJson(e)).toList()
            : null,
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        likedByLoggedInUser: json['liked_by_logged_in_user'],
      );
  factory Post.fromForumJson(Map<String?, dynamic> json) => Post.fromJson(json)
      .copyWith(text: json["description"], forumId: parseInt(json['fourm_id']));

  factory Post.fromLocal(Map<String?, dynamic> json) => Post.fromJson(json);

  Post copyWith({
    int? id,
    int? forumId,
    String? text,
    String? title,
    final PostType? type,
    int? totalComments,
    int? totalLikes,
    User? user,
    List<Asset>? assets,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? likedByLoggedInUser,
  }) {
    return Post(
      id: id ?? this.id,
      forumId: forumId ?? this.forumId,
      text: text ?? this.text,
      title: title ?? this.title,
      type: type ?? this.type,
      totalComments: totalComments ?? this.totalComments,
      totalLikes: totalLikes ?? this.totalLikes,
      user: user ?? this.user,
      assets: assets ?? this.assets,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likedByLoggedInUser: likedByLoggedInUser ?? this.likedByLoggedInUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "title": title,
      "post_type": type?.rawValue,
      "total_comments": totalComments,
      "total_liks": totalLikes,
      "user": user,
      "assets": assets,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "liked_by_logged_in_user": likedByLoggedInUser,
    };
  }

  @override
  List<Object?> get props => [
        id,
        forumId,
        text,
        title,
        type,
        totalComments,
        totalLikes,
        user,
        assets,
        createdAt,
        updatedAt,
        likedByLoggedInUser
      ];
}

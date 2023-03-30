import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/post_comment.dart';

import '../common/utils/utils.dart';

class Forum extends Equatable {
  const Forum({
    this.id,
    this.name,
    this.image,
    this.description,
    this.totalMembers,
    this.totalLikes,
    this.liked,
    this.joined,
    this.comments,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final int? totalMembers;
  final int? totalLikes;
  final bool? liked;
  final bool? joined;
  final List<PostComment>? comments;

  factory Forum.fromJson(Map<String?, dynamic> json) => Forum(
        id: parseInt(json['id']),
        name: json['name'],
        description: json['description'],
        totalMembers: parseInt(json['total_members']),
        image: json['full_image_link'],
        totalLikes: json['total_likes'],
        liked: json['liked'],
        joined: json['joined'],
        comments: json['comments'] != null && json['comments'] is List
            ? List.from(json['comments'])
                .map((e) => PostComment.fromJson(e))
                .toList()
            : null,
      );

  factory Forum.fromLocal(Map<String?, dynamic> json) => Forum.fromJson(json);

  Forum copyWith(
      {int? id,
      String? name,
      String? description,
      int? totalMembers,
      int? totalLikes,
      bool? liked,
      bool? joined,
      List<PostComment>? comments,
      String? image}) {
    return Forum(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalMembers: totalMembers ?? this.totalMembers,
      image: image ?? this.image,
      totalLikes: totalLikes ?? this.totalLikes,
      joined: joined ?? this.joined,
      liked: liked ?? this.liked,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "total_members": totalMembers,
      "full_image_link": image,
      "total_likes": totalLikes,
      "liked": liked,
      "joined": joined,
      "comments": comments,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        totalMembers,
        image,
        totalLikes,
        liked,
        joined,
        comments
      ];
}

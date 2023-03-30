import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/user.dart';

import '../common/utils/utils.dart';

class PostComment extends Equatable {
  const PostComment(
      {this.createdAt,
      this.updatedAt,
      this.postId,
      this.text,
      this.userId,
      this.replies,
      this.id,
      this.user});

  final int? id;
  final int? postId;
  final int? userId;
  final String? text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final List<CommentReply>? replies;
  factory PostComment.fromJson(Map<String?, dynamic> json) => PostComment(
        id: parseInt(json['id']),
        postId: json['post_id'],
        userId: json['user_id'],
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        text: json['text'] ?? json['comment'],
        user: json['user'] != null ? User.fromProfileJson(json['user']) : null,
        replies: json['replies'] != null && json['replies'] is List
            ? List.from(json['replies'])
                .map((e) => CommentReply.fromJson(e))
                .toList()
            : null,
      );

  factory PostComment.fromLocal(Map<String?, dynamic> json) =>
      PostComment.fromJson(json);

  PostComment copyWith({
    int? id,
    int? userId,
    int? postId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    List<CommentReply>? replies,
  }) {
    return PostComment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        text: text ?? this.text,
        replies: replies ?? this.replies);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "user_id": userId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "post_id": postId,
      "user": user,
      'replies': replies,
    };
  }

  @override
  List<Object?> get props =>
      [id, postId, userId, createdAt, updatedAt, text, user, replies];
}

class CommentReply extends Equatable {
  const CommentReply(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.forumId,
      this.forumPostId,
      this.forumPostCommentId,
      this.reply,
      this.userId,
      this.user});

  final int? id;
  final int? forumId;
  final int? forumPostId;
  final int? forumPostCommentId;
  final int? userId;
  final String? reply;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  factory CommentReply.fromJson(Map<String?, dynamic> json) => CommentReply(
        id: parseInt(json['id']),
        forumId: parseInt(json['fourm_id']),
        userId: parseInt(json['user_id']),
        forumPostId: parseInt(json['fourm_post_id']),
        forumPostCommentId: parseInt(json['fourm_post_comment_id']) ??
            parseInt(json["fourm_comments_id"]),
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        reply: json['reply'] ?? json['comment_reply'],
        user: json['user'] != null ? User.fromProfileJson(json['user']) : null,
      );

  factory CommentReply.fromLocal(Map<String?, dynamic> json) =>
      CommentReply.fromJson(json);

  CommentReply copyWith({
    int? id,
    int? forumId,
    int? forumPostId,
    int? forumPostCommentId,
    int? userId,
    String? reply,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return CommentReply(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      forumId: forumId ?? this.forumId,
      forumPostId: forumPostId ?? this.forumPostId,
      forumPostCommentId: forumPostCommentId ?? this.forumPostCommentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      reply: reply ?? this.reply,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fourm_id": forumId,
      "user_id": userId,
      "fourm_post_id": forumPostId,
      "fourm_post_comment_id": forumPostCommentId,
      "reply": reply,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "user": user
    };
  }

  @override
  List<Object?> get props => [
        id,
        forumId,
        userId,
        forumPostId,
        forumPostCommentId,
        createdAt,
        updatedAt,
        reply,
        user
      ];
}

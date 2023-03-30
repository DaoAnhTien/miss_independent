import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/user.dart';

import '../common/utils/utils.dart';

class FriendRequest extends Equatable {
  const FriendRequest({
    this.id,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final int? id;
  final int? senderId;
  final int? receiverId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory FriendRequest.fromJson(Map<String?, dynamic> json) => FriendRequest(
        id: parseInt(json['id']),
        senderId: parseInt(json['sender_id']),
        receiverId: parseInt(json['receiver_id']),
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        user:
            json['users'] != null ? User.fromProfileJson(json['users']) : null,
      );

  factory FriendRequest.fromLocal(Map<String?, dynamic> json) =>
      FriendRequest.fromJson(json);

  FriendRequest copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "users": user,
    };
  }

  @override
  List<Object?> get props =>
      [id, senderId, receiverId, createdAt, updatedAt, user];
}

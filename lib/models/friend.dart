import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/user.dart';

import '../common/utils/utils.dart';

class Friend extends Equatable {
  const Friend({this.id, this.createdAt, this.updatedAt, this.user});

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory Friend.fromJson(Map<String?, dynamic> json) => Friend(
        id: parseInt(json['id']),
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );

  factory Friend.fromLocal(Map<String?, dynamic> json) => Friend.fromJson(json);

  Friend copyWith(
      {int? id, DateTime? createdAt, DateTime? updatedAt, User? user}) {
    return Friend(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "user": user,
    };
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt, user];
}

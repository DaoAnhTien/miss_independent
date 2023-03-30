import 'package:equatable/equatable.dart';

import '../common/utils/utils.dart';
import '../configs/build_config.dart';

class Notification extends Equatable {
  const Notification(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.senderName,
      this.senderImage});

  final int? id;
  final String? title;
  final String? body;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? senderName;
  final String? senderImage;
  factory Notification.fromJson(Map<String?, dynamic> json) => Notification(
        id: parseInt(json['id']),
        title: json['title'],
        body: json['body'],
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        senderName: json['sender_name'],
        senderImage: json['sender_image'] != null
            ? "${BuildConfig.kBaseUrl}/${json['sender_image']}"
            : null,
      );

  factory Notification.fromLocal(Map<String?, dynamic> json) =>
      Notification.fromJson(json);

  Notification copyWith(
      {int? id,
      String? title,
      String? body,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? senderName,
      String? senderImage}) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      senderName: senderName ?? this.senderName,
      senderImage: senderName ?? this.senderImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "sender_name": senderName,
      "sender_image": senderImage,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, body, createdAt, updatedAt, senderName, senderImage];
}

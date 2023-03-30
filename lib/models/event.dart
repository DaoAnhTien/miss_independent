import 'package:equatable/equatable.dart';
import '../common/utils/utils.dart';

class Event extends Equatable {
  const Event(
      {this.id,
      this.title,
      this.image,
      this.location,
      this.fromDate,
      this.toDate,
      this.description,
      this.favBit,
      this.userId});

  final int? id;
  final String? title;
  final String? image;
  final String? location;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? description;
  final bool? favBit;
  final int? userId;

  factory Event.fromJson(Map<String?, dynamic> json) => Event(
        id: parseInt(json['id']),
        title: json['title'],
        image: json['image'],
        location: json['location'],
        fromDate: parseDateTime(json['fromdate']),
        description: (json['description']),
        toDate: parseDateTime(json['todate']),
        favBit: (json['fav_bit']),
        userId: parseInt(json['user_id']),
      );

  factory Event.fromLocal(Map<String?, dynamic> json) => Event.fromJson(json);

  Event copyWith(
      {int? id,
      String? title,
      String? image,
      String? location,
      DateTime? fromDate,
      DateTime? toDate,
      String? description,
      bool? favBit,
      int? userId}) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      location: location ?? this.location,
      fromDate: fromDate ?? this.fromDate,
      description: description ?? this.description,
      toDate: toDate ?? this.toDate,
      favBit: favBit ?? this.favBit,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "image": image,
      "location": location,
      "fromdate": fromDate?.toIso8601String(),
      "todate": toDate?.toIso8601String(),
      "fav_bit": favBit,
      "user_id": userId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        location,
        fromDate,
        toDate,
        description,
        favBit,
        userId
      ];
}

import 'package:equatable/equatable.dart';

import '../common/utils/utils.dart';

class Asset extends Equatable {
  const Asset({this.id, this.link, this.thumbnailLink});

  final int? id;
  final String? link;
  final String? thumbnailLink;

  factory Asset.fromJson(Map<String?, dynamic> json) => Asset(
        id: parseInt(json['id']),
        link: json['link'],
        thumbnailLink: json['thumbnail_link'],
      );

  factory Asset.fromLocal(Map<String?, dynamic> json) => Asset.fromJson(json);

  Asset copyWith({int? id, String? link, String? thumbnailLink}) {
    return Asset(
      id: id ?? this.id,
      link: link ?? this.link,
      thumbnailLink: thumbnailLink ?? this.thumbnailLink,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "link": link,
      "thumbnail_link": thumbnailLink,
    };
  }

  @override
  List<Object?> get props => [id, link, thumbnailLink];
}

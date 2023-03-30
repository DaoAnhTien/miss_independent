import 'package:equatable/equatable.dart';

import '../common/utils/utils.dart';
import '../configs/build_config.dart';

class Category extends Equatable {
  const Category({this.id, this.cFor, this.slug, this.name, this.image});

  final int? id;
  final String? cFor;
  final String? slug;
  final String? name;
  final String? image;

  factory Category.fromJson(Map<String?, dynamic> json) => Category(
        id: parseInt(json['id']),
        cFor: json['for'],
        slug: json['slug'],
        name: json['name'],
        image: json['image'].toString().contains('http')
            ? json['image']
            : "${BuildConfig.kBaseUrl}/${json['image']}",
      );

  factory Category.fromLocal(Map<String?, dynamic> json) =>
      Category.fromJson(json);

  Category copyWith(
      {int? id, String? cFor, String? slug, String? name, String? image}) {
    return Category(
      id: id ?? this.id,
      cFor: cFor ?? this.cFor,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "cFor": cFor,
      "slug": slug,
      "name": name,
      "image": image,
    };
  }

  @override
  List<Object?> get props => [id, cFor, slug, name, image];
}

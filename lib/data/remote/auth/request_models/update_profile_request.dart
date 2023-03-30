import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/utils/extensions/interable_extension.dart';

import '../../../../models/category.dart';

class UpdateProfileRequest {
  UpdateProfileRequest({
    this.image,
    this.name,
    this.businessEmail,
    this.businessName,
    this.aboutMe,
    this.categories,
    this.facebook,
    this.instagram,
    this.tiktok,
    this.twitter,
    this.youtube,
    this.website,
  });

  final XFile? image;
  final String? name;
  final String? businessName;
  final String? businessEmail;
  final String? aboutMe;
  final List<Category>? categories;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? youtube;
  final String? tiktok;
  final String? website;

  factory UpdateProfileRequest.empty() => UpdateProfileRequest();

  UpdateProfileRequest copyWith({
    XFile? image,
    String? name,
    String? businessName,
    String? businessEmail,
    String? aboutMe,
    String? membershipType,
    String? serviceProviderType,
    List<Category>? categories,
    String? basedIn,
    List<String>? serviceProvidedTo,
    String? facebook,
    String? twitter,
    String? instagram,
    String? youtube,
    String? tiktok,
    String? website,
    bool? visibleToAdmin,
  }) {
    return UpdateProfileRequest(
      image: image ?? this.image,
      name: name ?? this.name,
      businessName: businessName ?? this.businessName,
      businessEmail: businessEmail ?? this.businessEmail,
      aboutMe: aboutMe ?? this.aboutMe,
      categories: categories ?? this.categories,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      youtube: youtube ?? this.youtube,
      tiktok: tiktok ?? this.tiktok,
      website: website ?? this.website,
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> data = {
      "name": name ?? '',
      "business_name": businessName,
      "business_email": businessEmail,
      "about_me": aboutMe,
      "social_link_facebook": facebook,
      "social_link_twitter": twitter,
      "social_link_instagram": instagram,
      "social_link_youtube": youtube,
      "social_link_tiktok": tiktok,
      "website_link": website,
    }..removeNull();

    for (var e in (categories ?? []).map((e) => e.slug).toList()) {
      data['user_categories[]'] = e;
    }
    if (image != null) {
      data['image'] =
          await MultipartFile.fromFile(image!.path, filename: image!.name);
    }
    return data;
  }
}

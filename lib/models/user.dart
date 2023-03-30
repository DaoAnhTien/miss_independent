import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/utils/utils.dart';
import 'package:miss_independent/models/role.dart';

import '../common/constants/images.dart';
import '../configs/build_config.dart';
import '../generated/l10n.dart';
import 'category.dart';

class User extends Equatable {
  const User(
      {this.id,
      this.email,
      this.dob,
      this.image,
      this.name,
      this.businessName,
      this.businessEmail,
      this.aboutMe,
      this.basedIn,
      this.serviceProvidedTo,
      this.socialLinkFacebook,
      this.socialLinkTwitter,
      this.socialLinkInstagram,
      this.socialLinkYoutube,
      this.socialLinkTiktok,
      this.websiteLink,
      this.isOnline,
      this.jobTitle,
      this.categories,
      this.role});

  final int? id;
  final String? email;
  final String? dob;
  final String? image;
  final String? name;
  final String? businessName;
  final String? businessEmail;
  final String? aboutMe;
  final String? basedIn;
  final String? serviceProvidedTo;
  final String? socialLinkFacebook;
  final String? socialLinkTwitter;
  final String? socialLinkInstagram;
  final String? socialLinkYoutube;
  final String? socialLinkTiktok;
  final String? websiteLink;
  final bool? isOnline;
  final String? jobTitle;
  final List<Category>? categories;
  final Role? role;

  factory User.fromJson(Map<String?, dynamic> json) => User(
        id: parseInt(json['id']),
        email: json['email'],
        dob: json['dob'],
        image: json['image'],
        name: json['name'],
        businessName: json['businessName'],
        businessEmail: json['businessEmail'],
        aboutMe: json['aboutMe'],
        basedIn: json['basedIn'],
        serviceProvidedTo: json['serviceProvidedTo'],
        socialLinkFacebook: json['socialLinkFacebook'],
        socialLinkTwitter: json['socialLinkTwitter'],
        socialLinkInstagram: json['socialLinkInstagram'],
        socialLinkYoutube: json['socialLinkYoutube'],
        socialLinkTiktok: json['socialLinkTiktok'],
        websiteLink: json['websiteLink'],
        isOnline: json['is_online'] == 1,
        jobTitle: json['jobTitle'],
        categories: List.from(json['categories'] ?? [])
            .map((e) => Category.fromJson(e))
            .toList(),
        role: json['role'] != null && json['role'] is Map
            ? Role.fromJson(json['role'])
            : null,
      );

  factory User.fromProfileJson(Map<String?, dynamic> json) => User(
        id: parseInt(json['id']),
        email: json['email'],
        dob: json['dob'],
        image: json['image'],
        name: json['name'],
        businessName: json['business_name'],
        businessEmail: json['business_email'],
        aboutMe: json['about_me'],
        basedIn: json['based_in'],
        serviceProvidedTo: json['service_provided_to'],
        socialLinkFacebook: json['social_link_facebook'],
        socialLinkTwitter: json['social_link_twitter'],
        socialLinkInstagram: json['social_link_instagram'],
        socialLinkYoutube: json['social_link_youtube'],
        socialLinkTiktok: json['social_link_tiktok'],
        websiteLink: json['website_link'],
        isOnline: json['is_online'] == 1,
        jobTitle: json['job_title'],
        role: json['role'] != null && json['role'] is Map
            ? Role.fromJson(json['role'])
            : null,
      );
  factory User.fromForumMemberJson(Map<String?, dynamic> json) => User(
        id: parseInt(json['user_id']),
        image: json['user_image'] != null
            ? "${BuildConfig.kBaseUrl}/${json['user_image']}"
            : null,
        name: json['user_name'],
        role: json['user_role'] != null
            ? const Role().copyWith(name: json['user_role'])
            : null,
      );

  factory User.fromLocal(Map<String?, dynamic> json) => User.fromJson(json);

  User copyWith({
    int? id,
    String? email,
    String? dob,
    String? image,
    String? name,
    String? businessName,
    String? businessEmail,
    String? aboutMe,
    String? basedIn,
    String? serviceProvidedTo,
    String? socialLinkFacebook,
    String? socialLinkTwitter,
    String? socialLinkInstagram,
    String? socialLinkYoutube,
    String? socialLinkTiktok,
    String? websiteLink,
    bool? isOnline,
    String? jobTitle,
    List<Category>? categories,
    Role? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      image: image ?? this.image,
      name: name ?? this.name,
      businessName: businessName ?? this.businessName,
      businessEmail: businessEmail ?? this.businessEmail,
      aboutMe: aboutMe ?? this.aboutMe,
      basedIn: basedIn ?? this.basedIn,
      serviceProvidedTo: serviceProvidedTo ?? this.serviceProvidedTo,
      socialLinkFacebook: socialLinkFacebook ?? this.socialLinkFacebook,
      socialLinkTwitter: socialLinkTwitter ?? this.socialLinkTwitter,
      socialLinkInstagram: socialLinkInstagram ?? this.socialLinkInstagram,
      socialLinkYoutube: socialLinkYoutube ?? this.socialLinkYoutube,
      socialLinkTiktok: socialLinkTiktok ?? this.socialLinkTiktok,
      websiteLink: websiteLink ?? this.websiteLink,
      isOnline: isOnline ?? this.isOnline,
      jobTitle: jobTitle ?? this.jobTitle,
      categories: categories ?? this.categories,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "dob": dob,
      "image": image,
      "name": name,
      "businessName": businessName,
      "businessEmail": businessEmail,
      "aboutMe": aboutMe,
      "basedIn": basedIn,
      "serviceProvidedTo": serviceProvidedTo,
      "socialLinkFacebook": socialLinkFacebook,
      "socialLinkTwitter": socialLinkTwitter,
      "socialLinkInstagram": socialLinkInstagram,
      "socialLinkYoutube": socialLinkYoutube,
      "socialLinkTiktok": socialLinkTiktok,
      "websiteLink": websiteLink,
      "is_online": isOnline == true ? 1 : 0,
      "jobTitle": jobTitle,
      "categories": categories,
      "role": role
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        dob,
        image,
        name,
        businessName,
        businessEmail,
        aboutMe,
        basedIn,
        serviceProvidedTo,
        socialLinkFacebook,
        socialLinkTwitter,
        socialLinkInstagram,
        socialLinkYoutube,
        socialLinkTiktok,
        websiteLink,
        jobTitle,
        categories,
        role,
      ];
}

enum MembershipType { tulip, orchid, dhalia, serviceProvider }

extension MembershipTypeX on MembershipType {
  String get displayName {
    switch (this) {
      case MembershipType.tulip:
        return S.current.tulipDesc;
      case MembershipType.orchid:
        return S.current.orchidDesc;
      case MembershipType.dhalia:
        return S.current.dhaliaDesc;
      case MembershipType.serviceProvider:
        return S.current.serviceProvider;
    }
  }

  String get icon {
    switch (this) {
      case MembershipType.tulip:
        return kTulipIcon;
      case MembershipType.orchid:
        return kOrchidIcon;
      case MembershipType.dhalia:
        return kDhaliaIcon;
      case MembershipType.serviceProvider:
        return kServiceIcon;
    }
  }

  String get rawValue {
    switch (this) {
      case MembershipType.tulip:
        return '2';
      case MembershipType.orchid:
        return '3';
      case MembershipType.dhalia:
        return '4';
      case MembershipType.serviceProvider:
        return '5';
    }
  }

  static MembershipType? initFrom(String? value) {
    return MembershipType.values.firstWhereOrNull((MembershipType e) {
      if (e == MembershipType.serviceProvider) {
        return value == '5' || value == '6';
      } else {
        return e.rawValue.toLowerCase() == value?.toLowerCase();
      }
    });
  }
}

enum ServiceProviderType { coachMentor, consultantTrainer }

extension ServiceProviderTypeX on ServiceProviderType {
  String get displayName {
    switch (this) {
      case ServiceProviderType.coachMentor:
        return S.current.coachMentor;
      case ServiceProviderType.consultantTrainer:
        return S.current.consultantTrainer;
    }
  }

  String get rawValue {
    switch (this) {
      case ServiceProviderType.coachMentor:
        return '5';
      case ServiceProviderType.consultantTrainer:
        return '6';
    }
  }

  static ServiceProviderType? initFrom(String? value) {
    return ServiceProviderType.values.firstWhereOrNull(
        (ServiceProviderType e) =>
            e.rawValue.toLowerCase() == value?.toLowerCase());
  }
}

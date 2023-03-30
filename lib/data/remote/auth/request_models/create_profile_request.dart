import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/utils/extensions/interable_extension.dart';
import 'package:miss_independent/models/user.dart';

import '../../../../common/constants/countries.dart';
import '../../../../models/category.dart';

class CreateProfileRequest {
  CreateProfileRequest(
      {this.image,
      this.serviceProvidedTo,
      this.name,
      this.businessEmail,
      this.businessName,
      this.aboutMe,
      this.membershipType,
      this.serviceProviderType,
      this.selectedGeneralCategories,
      this.selectedSoftCategories,
      this.selectedServiceCategories,
      this.selectedCoachingCategories,
      this.basedIn,
      this.facebook,
      this.instagram,
      this.tiktok,
      this.twitter,
      this.youtube,
      this.website,
      this.visibleToAdmin});

  final XFile? image;
  final String? name;
  final String? businessName;
  final String? businessEmail;
  final String? aboutMe;
  final String? membershipType;
  final String? serviceProviderType;
  final List<Category>? selectedGeneralCategories;
  final List<Category>? selectedSoftCategories;
  final List<Category>? selectedServiceCategories;
  final List<Category>? selectedCoachingCategories;
  final String? basedIn;
  final List<String>? serviceProvidedTo;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? youtube;
  final String? tiktok;
  final String? website;
  final bool? visibleToAdmin;

  factory CreateProfileRequest.empty() => CreateProfileRequest(
      membershipType: MembershipType.tulip.rawValue,
      serviceProviderType: ServiceProviderType.coachMentor.rawValue,
      basedIn: kCountriesList[0]['code']);

  CreateProfileRequest copyWith({
    XFile? image,
    String? name,
    String? businessName,
    String? businessEmail,
    String? aboutMe,
    String? membershipType,
    String? serviceProviderType,
    List<Category>? selectedGeneralCategories,
    List<Category>? selectedSoftCategories,
    List<Category>? selectedServiceCategories,
    List<Category>? selectedCoachingCategories,
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
    return CreateProfileRequest(
      image: image ?? this.image,
      name: name ?? this.name,
      businessName: businessName ?? this.businessName,
      businessEmail: businessEmail ?? this.businessEmail,
      aboutMe: aboutMe ?? this.aboutMe,
      membershipType: membershipType ?? this.membershipType,
      serviceProviderType: serviceProviderType ?? this.serviceProviderType,
      selectedGeneralCategories:
          selectedGeneralCategories ?? this.selectedGeneralCategories,
      selectedSoftCategories:
          selectedSoftCategories ?? this.selectedSoftCategories,
      selectedServiceCategories:
          selectedServiceCategories ?? this.selectedServiceCategories,
      selectedCoachingCategories:
          selectedCoachingCategories ?? this.selectedCoachingCategories,
      basedIn: basedIn ?? this.basedIn,
      serviceProvidedTo: serviceProvidedTo ?? this.serviceProvidedTo,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      youtube: youtube ?? this.youtube,
      tiktok: tiktok ?? this.tiktok,
      website: website ?? this.website,
      visibleToAdmin: visibleToAdmin ?? this.visibleToAdmin,
    );
  }

  Map<String, dynamic> toJson() {
    List<Category> categories = [...?selectedGeneralCategories];
    if (serviceProviderType != null &&
        membershipType == MembershipType.serviceProvider.rawValue) {
      categories = [...categories, ...?selectedSoftCategories];
      if (serviceProviderType == ServiceProviderType.coachMentor.rawValue) {
        categories = [...categories, ...?selectedCoachingCategories];
      } else {
        categories = [...categories, ...?selectedServiceCategories];
      }
    }

    Map<String, dynamic> data = {
      "name": name ?? '',
      "business_name":
          membershipType == MembershipType.tulip.rawValue ? null : businessName,
      "business_email": membershipType == MembershipType.tulip.rawValue
          ? null
          : businessEmail,
      "about_me": aboutMe,
      "role_id": serviceProviderType != null &&
              membershipType == MembershipType.serviceProvider.rawValue
          ? serviceProviderType
          : membershipType,
      "based_in": basedIn,
      "social_link_facebook": facebook,
      "social_link_twitter": twitter,
      "social_link_instagram": instagram,
      "social_link_youtube": youtube,
      "social_link_tiktok": tiktok,
      "visible_to_admin_only": (visibleToAdmin ?? false) ? 1 : 0
    }..removeNull();
    for (var e in (serviceProvidedTo ?? [])) {
      data['service_provided_to[]'] = e;
    }
    for (var e in categories.map((e) => e.slug).toList()) {
      data['user_categories[]'] = e;
    }
    if (data['service_provided_to[]'] == null) {
      data['service_provided_to[]'] = '';
    }
    if (data['user_categories[]'] == null) {
      data['user_categories[]'] = '';
    }

    return data;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/modules/auth/bloc/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/images.dart';
import '../../../common/constants/social_url.dart';
import '../../../common/theme/colors.dart';
import '../../../widgets/cached_image.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myProfile),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(kSettingsRoute);
              },
              icon: const Icon(
                CupertinoIcons.settings,
                color: kWhiteColor,
              ))
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
          builder: (BuildContext context, AuthState state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedImage(
                      url: state.user?.image ?? kDefaultImage,
                      height: 100,
                      width: 100,
                      radius: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: kLightGreyColor))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).aboutMe,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Text(state.user?.aboutMe ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300))
                        ],
                      ),
                    ),
                    MyProfileItem(
                        label: S.of(context).name, value: state.user?.name),
                    if (state.user?.role?.id.toString() !=
                        MembershipType.tulip.rawValue)
                      MyProfileItem(
                        label: S.of(context).businessName,
                        value: state.user?.businessName,
                      ),
                    if (state.user?.role?.id.toString() !=
                        MembershipType.tulip.rawValue)
                      MyProfileItem(
                        label: S.of(context).businessEmail,
                        value: state.user?.businessEmail,
                      ),
                    MyProfileItem(
                      label: S.of(context).membershipType,
                      value: state.user?.role?.name,
                    ),
                    MyProfileItem(
                      label: "Facebook",
                      value: state.user?.socialLinkFacebook,
                      onTap: (String url) {
                        _onTapLink(kFacebookUrl + url);
                      },
                      isSocialLink: true,
                    ),
                    MyProfileItem(
                      label: "Tiktok",
                      value: state.user?.socialLinkTiktok,
                      onTap: (String url) {
                        _onTapLink(kTiktokUrl + url);
                      },
                      isSocialLink: true,
                    ),
                    MyProfileItem(
                      label: "Twitter",
                      value: state.user?.socialLinkTwitter,
                      onTap: (String url) {
                        _onTapLink(kTwitterUrl + url);
                      },
                      isSocialLink: true,
                    ),
                    MyProfileItem(
                      label: "Instagram",
                      value: state.user?.socialLinkInstagram,
                      onTap: (String url) {
                        _onTapLink(kInstagramUrl + url);
                      },
                      isSocialLink: true,
                    ),
                    MyProfileItem(
                      label: "Youtube",
                      value: state.user?.socialLinkYoutube,
                      onTap: (String url) {
                        _onTapLink(kYoutubeUrl + url);
                      },
                      isSocialLink: true,
                    ),
                    MyProfileItem(
                      label: "Website",
                      value: state.user?.websiteLink,
                      onTap: (String url) {
                        _onTapLink(kWebsiteUrl + url);
                      },
                      isSocialLink: true,
                    ),
                  ]),
            ),
          ),
        );
      }),
    );
  }

  void _onTapLink(String? link) async {
    try {
      final Uri url = Uri.parse(link ?? "");
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class MyProfileItem extends StatelessWidget {
  const MyProfileItem({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.isSocialLink = false,
  });
  final String label;
  final String? value;
  final bool isSocialLink;
  final Function(String)? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kLightGreyColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              )),
          const SizedBox(width: 8),
          if (value != null)
            Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    if (isSocialLink) onTap?.call(value!);
                  },
                  child: Text(value!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: isSocialLink ? Colors.blue : null)),
                ))
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/constants/social_url.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/user_profile.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_editorials_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_photos_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_profile_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_profile_state.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_videos_cubit.dart';
import 'package:miss_independent/modules/user_detail/widgets/user_profile_tabs.dart';
import 'package:miss_independent/modules/user_detail/widgets/user_photos.dart';
import 'package:miss_independent/widgets/button.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/routes.dart';
import '../../../common/enums/status.dart';
import '../../../common/theme/colors.dart';
import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../models/user.dart';
import '../widgets/user_editorials.dart';
import '../widgets/user_videos.dart';

class SocialIcon {
  const SocialIcon({required this.icon, required this.urlPath, this.url});
  final String icon;
  final String? url;
  final String urlPath;
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileTab _selectedType = UserProfileTab.about;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double avatarHeight = 220;
    double widthScreen = MediaQuery.of(context).size.width;
    final User? user = context.getRouteArguments<User>();
    bool isCurrentUser = context.read<AuthCubit>().state.user?.id == user?.id;
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<UserProfileCubit>()
            ..initUser(user)
            ..getUserProfile(),
        ),
        BlocProvider(
          create: (_) => getIt<UserPhotosCubit>()
            ..initUser(user)
            ..refreshItems(isInit: true),
        ),
        BlocProvider(
          create: (_) => getIt<UserVideosCubit>()
            ..initUser(user)
            ..refreshItems(isInit: true),
        ),
        BlocProvider(
          create: (_) =>
              getIt<UserEditorialsCubit>()..fetchItems(user?.id ?? 0),
        ),
      ],
      child: BlocConsumer<UserProfileCubit, UserProfileState>(
        listenWhen: (UserProfileState prev, UserProfileState current) =>
            prev.status != current.status ||
            prev.addFriendStatus != current.addFriendStatus ||
            prev.followStatus != current.followStatus,
        listener: (context, UserProfileState state) {
          if ((state.status == RequestStatus.failed ||
                  state.addFriendStatus == RequestStatus.failed ||
                  state.followStatus == RequestStatus.failed) &&
              (state.message?.isNotEmpty ?? false)) {
            showErrorMessage(context, state.message!);
          }
        },
        builder: (context, UserProfileState state) {
          List<SocialIcon> socialIcons = [
            SocialIcon(
                icon: kFacebookIcon,
                urlPath: kFacebookUrl,
                url: state.userProfile?.user?.socialLinkFacebook),
            SocialIcon(
                icon: kInstagramIcon,
                urlPath: kInstagramUrl,
                url: state.userProfile?.user?.socialLinkInstagram),
            SocialIcon(
                icon: kTwitterIcon,
                urlPath: kTwitterUrl,
                url: state.userProfile?.user?.socialLinkTwitter),
            SocialIcon(
                icon: kWebIcon,
                urlPath: kWebsiteUrl,
                url: state.userProfile?.user?.websiteLink),
            SocialIcon(
                icon: kYoutubeIcon,
                urlPath: kYoutubeUrl,
                url: state.userProfile?.user?.socialLinkYoutube),
            SocialIcon(
                urlPath: kTiktokUrl,
                icon: kTiktokIcon,
                url: state.userProfile?.user?.socialLinkTiktok),
          ];
          return CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                title: Text(state.userProfile?.user?.name ?? ""),
                floating: true,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedImage(
                    fit: BoxFit.cover,
                    url: state.userProfile?.user?.image,
                    width: widthScreen,
                    height: avatarHeight,
                  ),
                ),
                actions: [
                  if (isCurrentUser)
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(kSettingsRoute);
                        },
                        icon: const Icon(
                          CupertinoIcons.settings,
                          color: kWhiteColor,
                        )),
                ],
                expandedHeight: avatarHeight,
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: UserProfileTabs(
                          selected: _selectedType,
                          onChanged: (UserProfileTab type) =>
                              _onChangedTab(context, type)),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                sliver: _selectedType == UserProfileTab.about
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade100),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state.userProfile?.user?.aboutMe
                                              ?.isNotEmpty ??
                                          false)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                S.of(context).aboutMe,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                state.userProfile?.user
                                                        ?.aboutMe ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ProfileItem(
                                          label: S.of(context).name,
                                          value: state.userProfile?.user?.name),
                                      if (state.userProfile?.user?.role?.id
                                              .toString() !=
                                          MembershipType.tulip.rawValue)
                                        ProfileItem(
                                          label: S.of(context).businessName,
                                          value: state
                                              .userProfile?.user?.businessName,
                                        ),
                                      if (state.userProfile?.user?.role?.id
                                              .toString() !=
                                          MembershipType.tulip.rawValue)
                                        ProfileItem(
                                          label: S.of(context).businessEmail,
                                          value: state
                                              .userProfile?.user?.businessEmail,
                                        ),
                                      ProfileItem(
                                        label: S.of(context).membershipType,
                                        value:
                                            state.userProfile?.user?.role?.name,
                                        showDivider: !isCurrentUser,
                                      ),
                                      if (!isCurrentUser)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _renderButton(context,
                                                    state.userProfile, state),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _renderFollowButton(
                                                    context,
                                                    state.userProfile,
                                                    state),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: -2,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: socialIcons.map((e) {
                                        return e.url != null
                                            ? GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  _onTapLink(
                                                      e.urlPath + e.url!);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: CachedImage(
                                                    url: e.icon,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                ))
                                            : const SizedBox();
                                      }).toList()),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : _selectedType == UserProfileTab.photos
                        ? const UserPhotos()
                        : _selectedType == UserProfileTab.videos
                            ? const UserVideos()
                            : const UserEditorials(),
              )
            ],
          );
        },
      ),
    ));
  }

  Widget _renderButton(
      BuildContext context, UserProfile? userProfile, UserProfileState state) {
    bool isRequestFriend =
        userProfile?.isFriend == false && userProfile?.request == false;
    if (isRequestFriend) {
      return BasicButton(
        icon: const Icon(
          CupertinoIcons.person_crop_circle_badge_plus,
          color: kWhiteColor,
          size: 20,
        ),
        label: S.of(context).addFriend,
        onPressed: () {
          context.read<UserProfileCubit>().requestFriend();
        },
        isLoading: state.addFriendStatus == RequestStatus.requesting,
      );
    }
    bool isPendingRequest =
        userProfile?.isFriend == false && userProfile?.request == true;
    if (isPendingRequest) {
      return BasicButton(
        label: S.of(context).pendingRequest,
        disabled: true,
      );
    }
    return const SizedBox();
  }

  Widget _renderFollowButton(
      BuildContext context, UserProfile? userProfile, UserProfileState state) {
    if (userProfile?.followBit == false) {
      return BasicButton(
        backgroundColor: const Color(0xffe7e7e7),
        icon: CachedImage(
          url: kFollowIcon,
          height: 20,
          width: 20,
          color: Theme.of(context).primaryColor,
        ),
        label: S.of(context).follow,
        textColor: Theme.of(context).primaryColor,
        spinKitWaveColor: Theme.of(context).primaryColor,
        onPressed: () {
          context.read<UserProfileCubit>().followUser();
        },
        isLoading: state.followStatus == RequestStatus.requesting,
      );
    } else if (userProfile?.followBit == true) {
      return BasicButton(
        label: S.of(context).unFollow,
        backgroundColor: const Color(0xffe7e7e7),
        icon: const CachedImage(
          url: kUnFollowIcon,
          height: 20,
          width: 20,
          color: kDarkGreyColor,
        ),
        textColor: kDarkGreyColor,
        spinKitWaveColor: kDarkGreyColor,
        onPressed: () {
          context.read<UserProfileCubit>().unFollowUser();
        },
        isLoading: state.followStatus == RequestStatus.requesting,
      );
    } else {
      return const SizedBox();
    }
  }

  void _onChangedTab(BuildContext context, UserProfileTab type) {
    setState(() {
      _selectedType = type;
    });
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

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.isSocialLink = false,
    this.showDivider = true,
  });
  final String label;
  final String? value;
  final bool isSocialLink;
  final bool showDivider;

  final Function(String)? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: kLightGreyColor))
              : null),
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
                    ?.copyWith(fontWeight: FontWeight.w600),
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
                          fontWeight: FontWeight.w400,
                          color: isSocialLink ? Colors.blue : null)),
                ))
        ],
      ),
    );
  }
}

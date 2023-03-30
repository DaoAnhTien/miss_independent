import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/common/screens/webview_screen.dart';

import '../common/constants/images.dart';
import '../common/event/event_bus_event.dart';
import '../configs/build_config.dart';
import '../modules/auth/bloc/auth_cubit.dart';
import '../modules/auth/bloc/auth_state.dart';
import 'cached_image.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> with EventBusMixin {
  bool _isShowMIServices = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
      return Drawer(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  CachedImage(
                    url: state.user?.image ?? kDefaultImage,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                    radius: 40,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.user?.name ?? state.user?.email ?? 'No Name',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, kMyProfileRoute,
                                arguments: state.user);
                          },
                          child: Text(
                            S.of(context).viewMyProfile,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              horizontalTitleGap: 0.0,
              title: Text(S.of(context).home,
                  style: Theme.of(context).textTheme.labelMedium),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.settings,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              horizontalTitleGap: 0.0,
              title: Text(S.of(context).miServices,
                  style: Theme.of(context).textTheme.labelMedium),
              onTap: () {
                setState(() {
                  _isShowMIServices = !_isShowMIServices;
                });
              },
              trailing: Icon(
                _isShowMIServices
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
                visible: _isShowMIServices,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 56, right: 8),
                      title: Text(S.of(context).coachesAndMentors,
                          style: Theme.of(context).textTheme.labelMedium),
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, kCoachesMentorsServicesRoute);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 56, right: 8),
                      title: Text(S.of(context).conslutantsAndTrainers,
                          style: Theme.of(context).textTheme.labelMedium),
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, kConsultantsTrainersServicesRoute);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 56, right: 8),
                      title: Text(S.of(context).brandingServices,
                          style: Theme.of(context).textTheme.labelMedium),
                      onTap: () {
                        Navigator.popAndPushNamed(context, kWebViewRoute,
                            arguments: WebViewArg(
                                url: BuildConfig.kBrandingServiceUrl,
                                title: S.of(context).brandingServices));
                      },
                    ),
                  ],
                )),
            ListTile(
              leading: Icon(
                CupertinoIcons.group,
                color: Theme.of(context).primaryColor,
              ),
              horizontalTitleGap: 0.0,
              title: Text(S.of(context).friends),
              onTap: () {
                Navigator.of(context).popAndPushNamed(kFriendsRouter);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.time,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              horizontalTitleGap: 0.0,
              title: Text(S.of(context).orderHistory,
                  style: Theme.of(context).textTheme.labelMedium),
              onTap: () {
                Navigator.popAndPushNamed(context, kOrderHistoryRoute);
              },
            ),
            if (state.user?.role?.id?.toString() ==
                MembershipType.dhalia.rawValue)
              ListTile(
                leading: Icon(
                  CupertinoIcons.collections,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                horizontalTitleGap: 0.0,
                title: Text(S.of(context).shopManagement,
                    style: Theme.of(context).textTheme.labelMedium),
                onTap: () {
                  Navigator.popAndPushNamed(context, kShopManagementRoute);
                },
              ),
            if (state.user?.role?.id?.toString() ==
                MembershipType.dhalia.rawValue)
              ListTile(
                leading: Icon(
                  CupertinoIcons.square_list,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                horizontalTitleGap: 0.0,
                title: Text(S.of(context).orderManagement,
                    style: Theme.of(context).textTheme.labelMedium),
                onTap: () {
                  Navigator.popAndPushNamed(context, kOrderManagementRoute);
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  shareEvent(LogoutEvent());
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).logout,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ))),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/common/screens/webview_screen.dart';
import 'package:miss_independent/widgets/button.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/cached_image.dart';

class MIServiceDetailScreen extends StatelessWidget {
  const MIServiceDetailScreen({Key? key, required this.type}) : super(key: key);
  final ServiceProviderType type;

  @override
  Widget build(BuildContext context) {
    final User? user = context.getRouteArguments<User>();
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ServiceProviderType.coachMentor
              ? S.of(context).coachesAndMentors
              : S.of(context).consultantTrainer)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        height: 81,
                        width: 81,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.deepPurple.shade200, width: 0.5),
                            borderRadius: BorderRadius.circular(40.5)),
                        child: CachedImage(
                            url: user?.image,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            radius: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user?.businessName ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: kGreyColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: kGreyColor,
                                ),
                                Text(
                                  user?.basedIn ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: kGreyColor),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  kUserProfileRouter,
                                  arguments: user),
                              child: Text(
                                S.of(context).viewMyProfile,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                    child: Text(
                  user?.aboutMe ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black45),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                )),
                BasicButton(
                  label: S.of(context).applyForServices,
                  width: double.infinity,
                  backgroundColor: type == ServiceProviderType.coachMentor
                      ? null
                      : Colors.blueGrey.shade900,
                  onPressed: () => Navigator.of(context).pushNamed(
                      kWebViewRoute,
                      arguments: WebViewArg(
                          title: S.of(context).applyForServices,
                          url: type == ServiceProviderType.coachMentor
                              ? "https://form.jotform.com/201324104586043"
                              : "https://form.jotform.com/211664667433460")),
                )
              ]),
        ),
      ),
    );
  }
}

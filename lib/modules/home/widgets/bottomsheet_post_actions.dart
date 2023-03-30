import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';

import '../../../common/constants/routes.dart';
import '../../../models/post.dart';
import '../../../widgets/custom_alert_dialog.dart';

class BottomSheetPostActions extends StatelessWidget {
  const BottomSheetPostActions(
      {Key? key, this.isMe = false, this.onDelPost, required this.post})
      : super(key: key);
  final bool isMe;
  final Post post;
  final Function()? onDelPost;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: kWhiteColor),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isMe
                ? Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_document,
                            size: 28,
                          ),
                          const SizedBox(width: 20),
                          Text(S.of(context).edit,
                              style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                      const Divider(
                        height: 24,
                        thickness: 1,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          Navigator.pop(context);
                          await customAppDialog(
                            context,
                            icon: Icon(
                              Icons.info_outline_rounded,
                              color: Colors.amberAccent.shade200,
                              size: 48,
                            ),
                            title: S.of(context).deleteConfirmation,
                            text: S.of(context).areYouSureToDeleteThisPost,
                            confirmText: S.of(context).ok,
                            textConfirmColor: kErrorRedColor,
                            onConfirm: () {
                              onDelPost?.call();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.delete,
                              color: kErrorRedColor,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              S.of(context).delete,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: kErrorRedColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context)
                          .popAndPushNamed(kReportPostRoute, arguments: post),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.report,
                            size: 28,
                            color: kErrorRedColor,
                          ),
                          const SizedBox(width: 20),
                          Text(S.of(context).report,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: kErrorRedColor))
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

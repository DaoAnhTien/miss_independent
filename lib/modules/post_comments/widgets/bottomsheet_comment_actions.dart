import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/post_comment.dart';

import '../../../widgets/comments_list/comments_list.dart';
import '../../../widgets/custom_alert_dialog.dart';

class BottomSheetCommentActions extends StatelessWidget {
  const BottomSheetCommentActions({
    Key? key,
    this.comment,
    this.isMe = false,
    this.editComment,
    this.onDelete,  this.args,
  }) : super(key: key);
  final PostComment? comment;
  final CommentsListArgs? args;
  final bool isMe;
  final Function(bool)? editComment;
  final Function()? onDelete;

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: isMe
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            editComment?.call(true);
                            Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_note_rounded,
                                size: 28,
                              ),
                              const SizedBox(width: 20),
                              Text(S.of(context).edit,
                                  style:
                                      Theme.of(context).textTheme.labelMedium)
                            ],
                          ),
                        ),
                        const Divider(
                            height: 24, thickness: 1, color: kGreyColor),
                        GestureDetector(
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
                              text: S.of(context).areYouSureToDeleteThisComment,
                              confirmText: S.of(context).ok,
                              textConfirmColor: kErrorRedColor,
                              onConfirm: onDelete,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                size: 28,
                                color: kErrorRedColor,
                              ),
                              const SizedBox(width: 20),
                              Text(S.of(context).delete,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: kErrorRedColor))
                            ],
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).popAndPushNamed(
                          kReportCommentRoute,
                          arguments: {"comment" :comment, "args":args }),
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

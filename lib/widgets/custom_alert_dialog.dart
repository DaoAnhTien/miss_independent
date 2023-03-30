import 'package:flutter/material.dart';
import 'package:miss_independent/generated/l10n.dart';

import '../common/theme/colors.dart';
import 'button.dart';

Future<dynamic> customAppDialog(BuildContext context,
    {Widget? icon,
    required String title,
    required String text,
    String? confirmText,
    Color textConfirmColor = kPrimaryColor,
    Function()? onConfirm}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: <Widget>[
          BasicButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            label: confirmText ?? S.of(context).ok,
            textColor: textConfirmColor,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          BasicButton(
            onPressed: () => Navigator.pop(context),
            label: S.of(context).cancel,
            textColor: kBlackColor,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ],
        titlePadding: const EdgeInsets.all(12),
        title: Center(
            child: Column(
          children: [
            if (icon != null) icon,
            if (icon != null) const SizedBox(height: 10),
            Text(title),
            const SizedBox(height: 4),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        )),
      );
    },
  );
}

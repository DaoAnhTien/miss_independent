import 'package:flutter/material.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import '../../../common/constants/routes.dart';
import '../../../common/theme/colors.dart';

class BottomSheetAddPost extends StatelessWidget {
  const BottomSheetAddPost({Key? key}) : super(key: key);

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
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(kAddPostRouter, arguments: false);
              },
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.film,
                    size: 23,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(S.of(context).post,
                      style: Theme.of(context).textTheme.labelMedium)
                ],
              ),
            ),
            const Divider(
              height: 18,
              thickness: 1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(kAddPostRouter, arguments: true);
              },
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.book,
                    size: 23,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(S.of(context).editorial,
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

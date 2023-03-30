import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/forum.dart';

import '../../../widgets/cached_image.dart';

class MiForumItem extends StatelessWidget {
  const MiForumItem(
      {Key? key,
      required this.forum,
      required this.widthItem,
      required this.heightText})
      : super(key: key);
  final Forum forum;
  final double widthItem;
  final double heightText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(kMIForumDetailRoute, arguments: forum);
      },
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          CachedImage(
            fit: BoxFit.contain,
            url: forum.image,
            width: widthItem,
            height: widthItem,
          ),
          SizedBox(
              height: heightText,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "${(forum.totalMembers ?? 0).toString()} ${S.of(context).members.toLowerCase()}",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: kDarkGreyColor),
                ),
              )),
        ]),
      ]),
    );
  }
}

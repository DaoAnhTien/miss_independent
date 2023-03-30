import 'package:flutter/cupertino.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/modules/user_detail/widgets/user_profile_tabs.dart';
import 'package:miss_independent/widgets/cached_image.dart';

class ThumbnailItem extends StatelessWidget {
  const ThumbnailItem({
    super.key,
    required this.heightItem,
    required this.widthItem,
    this.thumbnailLink,
    required this.userDetailTab,
  });

  final UserProfileTab userDetailTab;
  final double heightItem;
  final double widthItem;
  final String? thumbnailLink;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedImage(
          fit: BoxFit.cover,
          radius: 8,
          height: heightItem,
          width: widthItem,
          url: thumbnailLink ?? kDefaultImage,
        ),
        userDetailTab == UserProfileTab.videos
            ? const Align(
                alignment: Alignment.center,
                child: Icon(
                  CupertinoIcons.play_circle_fill,
                  color: kWhiteColor,
                  size: 28,
                ),
              )
            : const Positioned(
                left: 6,
                top: 6,
                child: Icon(
                  CupertinoIcons.photo_on_rectangle,
                  color: kWhiteColor,
                ))
      ],
    );
  }
}

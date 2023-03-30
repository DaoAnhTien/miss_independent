// import 'package:flutter/material.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
import 'package:miss_independent/models/notification.dart' as model;
import 'package:flutter/material.dart';
import '../../../common/theme/colors.dart';
import '../../../widgets/cached_image.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notification})
      : super(key: key);
  final model.Notification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kLightGreyColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: CachedImage(
                height: 60,
                width: 60,
                url: notification.senderImage,
                fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(notification.body ?? "",
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 5),
                Text(
                  notification.createdAt?.toTimeAgo() ?? "",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

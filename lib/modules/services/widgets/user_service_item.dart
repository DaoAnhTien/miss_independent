import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../models/user.dart';
import '../../../widgets/cached_image.dart';

class UserServiceItem extends StatelessWidget {
  const UserServiceItem({
    super.key,
    required this.item,
  });

  final User item;

  @override
  Widget build(BuildContext context) {
    MembershipType? membershipType =
        MembershipTypeX.initFrom(item.role?.id?.toString());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGreyColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CachedImage(
                  url: item.image,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  radius: 30),
              if (membershipType != null)
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: CachedImage(
                            url: membershipType.icon, width: 18, height: 18),
                      ),
                    ))
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  item.businessName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: kGreyColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.location,
                      size: 16,
                      color: kGreyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.basedIn ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: kGreyColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

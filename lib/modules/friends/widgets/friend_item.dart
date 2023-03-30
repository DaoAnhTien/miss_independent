import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/models/friend.dart';
import 'package:miss_independent/widgets/cached_image.dart';

import '../../../models/user.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({
    super.key,
    required this.friend,
  });

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    MembershipType? membershipType =
        MembershipTypeX.initFrom(friend.user?.role?.id?.toString());
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(kUserProfileRouter, arguments: friend.user);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kGreyColor, width: 1),
          ),
        ),
        child: Row(children: [
          Stack(
            children: [
              CachedImage(
                  url: friend.user?.image,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  radius: 25),
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
                  friend.user?.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  friend.user?.role?.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: kGreyColor),
                ),
              ],
            ),
          ),
          Icon(
            Icons.circle,
            size: 12,
            color: friend.user?.isOnline == true ? Colors.green : kGreyColor,
          )
        ]),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/modules/friend_requests/bloc/friend_request_cubit.dart';

import '../../../common/theme/colors.dart';
import '../../../models/friend_request.dart';
import '../../../models/user.dart';
import '../../../widgets/cached_image.dart';

class FriendRequestItem extends StatelessWidget {
  const FriendRequestItem({Key? key, this.data}) : super(key: key);
  final FriendRequest? data;
  @override
  Widget build(BuildContext context) {
    MembershipType? membershipType =
        MembershipTypeX.initFrom(data?.user?.role?.id?.toString());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kLightGreyColor))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context)
                  .pushNamed(kUserProfileRouter, arguments: data?.user),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CachedImage(
                          url: data?.user?.image,
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
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: CachedImage(
                                    url: membershipType.icon,
                                    width: 18,
                                    height: 18),
                              ),
                            ))
                    ],
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(data?.user?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        if (data?.user?.role?.name != null)
                          Text(
                            data!.user!.role!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: kGreyColor),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context
                    .read<FriendRequestCubit>()
                    .acceptFriendRequest(data?.id ?? 0);
              },
              icon: const Icon(
                CupertinoIcons.check_mark_circled_solid,
                size: 25,
                color: kPrimaryColor,
              )),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context
                    .read<FriendRequestCubit>()
                    .rejectFriendRequest(data?.user?.id ?? 0);
              },
              icon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 25,
                color: kErrorRedColor,
              ))
        ],
      ),
    );
  }
}

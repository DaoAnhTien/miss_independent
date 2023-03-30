import 'package:flutter/material.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/models/forum_member.dart';
import 'package:miss_independent/widgets/cached_image.dart';

class MIForumDetailMemberItem extends StatelessWidget {
  const MIForumDetailMemberItem({
    super.key,
    required this.forumMember,
  });
  final ForumMember forumMember;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedImage(
                  url: forumMember.member?.image,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  radius: 25),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (forumMember.member?.name?.isNotEmpty == true)
                      Text(
                        forumMember.member!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (forumMember.member?.role?.name?.isNotEmpty == true)
                      Text(
                        forumMember.member!.role!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: kGreyColor),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

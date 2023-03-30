import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';
import '../../../models/forum.dart';
import 'mi_forum_detail_members.dart';

class MembersTab extends StatelessWidget {
  const MembersTab({
    super.key,
    this.forum,
  });
  final Forum? forum;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (forum?.description?.isNotEmpty == true)
          Text(
            forum?.description ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: 12),
        Text(
          "${S.of(context).totalMembers}: ${forum?.totalMembers ?? 0}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: kGreyColor),
        ),
        const SizedBox(height: 12),
        Text(S.of(context).members,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const ForumMembersList()
      ],
    );
  }
}

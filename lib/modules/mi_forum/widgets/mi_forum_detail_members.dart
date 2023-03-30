import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_members_cubit.dart';
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_members_state.dart';

import 'mi_forum_detail_item.dart';

class ForumMembersList extends StatefulWidget {
  const ForumMembersList({super.key});

  @override
  State<ForumMembersList> createState() => _ForumMembersListState();
}

class _ForumMembersListState extends State<ForumMembersList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiForumDetailMembersCubit, MiForumDetailMembersState>(
      builder: (context, MiForumDetailMembersState state) {
        if (state.members?.isNotEmpty == true) {
          return Column(
            children: state.members!.map((e) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context)
                    .pushNamed(kUserProfileRouter, arguments: e.member),
                child: MIForumDetailMemberItem(
                  forumMember: e,
                ),
              );
            }).toList(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

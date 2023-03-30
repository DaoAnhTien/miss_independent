import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/modules/home/widgets/post_item.dart';

import '../bloc/mi_forum_detail_all_posts_cubit.dart';
import '../bloc/mi_forum_detail_all_posts_state.dart';

class ForumAllPosts extends StatefulWidget {
  const ForumAllPosts({super.key});

  @override
  State<ForumAllPosts> createState() => _ForumAllPostsState();
}

class _ForumAllPostsState extends State<ForumAllPosts> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MIForumDetailAllPostsCubit, MIForumDetailAllPostsState>(
      builder: (context, MIForumDetailAllPostsState state) {
        if (state.posts?.isNotEmpty == true) {
          return Column(
            children: state.posts!.map((e) {
              return PostItem(
                padding: EdgeInsets.zero,
                post: e,
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

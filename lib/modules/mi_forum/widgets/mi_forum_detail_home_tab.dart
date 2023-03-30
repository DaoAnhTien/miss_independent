import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/widgets/comments_list/comments_list.dart';

import '../bloc/mi_forum_detail_cubit.dart';
import '../bloc/mi_forum_detail_state.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiForumDetailCubit, MiForumDetailState>(
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                if (state.forum?.description?.isNotEmpty == true)
                  Text(
                    state.forum?.description ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 24),
                CommentsList(
                    enableViewAll: true,
                    scrollEnabled: false,
                    args: CommentsListArgs.initForumComments(
                        state.forum?.id ?? 0)),
              ],
            ));
  }
}

import 'package:flutter/material.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';

import '../../../widgets/comments_list/comments_list.dart';

class PostCommentsScreen extends StatefulWidget {
  const PostCommentsScreen({super.key});

  @override
  State<PostCommentsScreen> createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final CommentsListArgs? args =
        context.getRouteArguments<CommentsListArgs>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CommentsList(
                args: args ??
                    CommentsListArgs.initPostComments(args?.postId ?? 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

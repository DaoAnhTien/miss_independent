import 'package:miss_independent/models/post_comment.dart';

class DeleteCommentEvent {
  const DeleteCommentEvent({this.postComment});
  final PostComment? postComment;
}

class DeleteCommentReplyEvent {
  const DeleteCommentReplyEvent({this.reply, this.commentId});
  final CommentReply? reply;
  final int? commentId;
}

import 'package:injectable/injectable.dart';

import '../common/api_client/data_state.dart';
import '../data/remote/post_comments/post_comments_service.dart';
import '../models/post_comment.dart';
import '../widgets/comments_list/comments_list.dart';

abstract class PostCommentsRepository {
  Future<DataState<List<PostComment>>> getPostComments(CommentsListArgs? args);
  Future<DataState<dynamic>> commentPost(
      CommentsListArgs? args, String comment);
  Future<DataState<CommentReply>> replyCommentPost(
      CommentsListArgs? args, int commentId, int userId, String comment);
  Future<DataState<dynamic>> editCommentPost(
      CommentsListArgs? args, int commentId, String comment);
  Future<DataState<dynamic>> deleteCommentPost(
      CommentsListArgs? args, int commentId);
  Future<DataState<dynamic>> editCommentPostReply(CommentsListArgs? args,
      int userId, int commentId, int commentReplyId, String comment);
  Future<DataState<dynamic>> deleteCommentPostReply(
      CommentsListArgs? args, int commentId, int commentReplyId);
  Future<DataState<dynamic>> reportComment(CommentsListArgs? args,
      int commentId, int userId, String text, String email);
}

@LazySingleton(as: PostCommentsRepository)
class PostCommentsRepositoryImpl implements PostCommentsRepository {
  final PostCommentsService _postCommentsService;

  PostCommentsRepositoryImpl({required PostCommentsService postCommentsService})
      : _postCommentsService = postCommentsService;

  @override
  Future<DataState<List<PostComment>>> getPostComments(CommentsListArgs? args) {
    return _postCommentsService.getPostComments(args);
  }

  @override
  Future<DataState<dynamic>> commentPost(
      CommentsListArgs? args, String comment) {
    return _postCommentsService.commentPost(args, comment);
  }

  @override
  Future<DataState> reportComment(CommentsListArgs? args, int commentId,
      int userId, String text, String email) {
    return _postCommentsService.reportComment(
        args, commentId, userId, text, email);
  }

  @override
  Future<DataState<CommentReply>> replyCommentPost(
      CommentsListArgs? args, int commentId, int userId, String comment) {
    return _postCommentsService.replyCommentPost(
        args, commentId, userId, comment);
  }

  @override
  Future<DataState> editCommentPost(
      CommentsListArgs? args, int commentId, String comment) {
    return _postCommentsService.editCommentPost(args, commentId, comment);
  }

  @override
  Future<DataState> deleteCommentPost(CommentsListArgs? args, int commentId) {
    return _postCommentsService.deleteCommentPost(args, commentId);
  }

  @override
  Future<DataState> deleteCommentPostReply(
      CommentsListArgs? args, int commentId, int commentReplyId) {
    return _postCommentsService.deleteCommentPostReply(
        args, commentId, commentReplyId);
  }

  @override
  Future<DataState> editCommentPostReply(CommentsListArgs? args, int userId,
      int commentId, int commentReplyId, String comment) {
    return _postCommentsService.editCommentPostReply(
        args, userId, commentId, commentReplyId, comment);
  }
}

import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/forum/forum_service.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/models/forum.dart';
import 'package:miss_independent/models/post_comment.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/data_state.dart';
import '../../../widgets/comments_list/comments_list.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class PostCommentsService {
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

@LazySingleton(as: PostCommentsService)
class PostCommentsServiceImpl implements PostCommentsService {
  PostCommentsServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<List<PostComment>>> getPostComments(
      CommentsListArgs? args) async {
    final ApiHelper<PostComment> helper = ApiHelper<PostComment>();
    if (args?.type == CommentsListType.post) {
      return helper.getListWithoutMore(
          _apiClient.get(
            path: "${ApiEndpoint.postComments}?post_id=${args?.postId}",
          ),
          PostComment.fromJson);
    } else if (args?.type == CommentsListType.postForum) {
      return helper.getListWithoutMore(
          _apiClient.post(
              path: ApiEndpoint.getForumPostComments,
              data: {"fourm_id": args?.forumId, 'post_id': args?.postId}),
          PostComment.fromJson);
    } else {
      DataState<Forum> res =
          await getIt<ForumService>().getForumDetail(args?.forumId ?? 0);
      return DataSuccess<List<PostComment>>(res.data?.comments);
    }
  }

  @override
  Future<DataState> commentPost(CommentsListArgs? args, String comment) {
    final ApiHelper helper = ApiHelper();
    if (args?.type == CommentsListType.post) {
      return helper
          .requestApi(_apiClient.post(path: ApiEndpoint.postComments, data: {
        "post_id": args?.postId,
        "text": comment,
      }));
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(_apiClient.post(
          path: ApiEndpoint.forumComment,
          data: {"fourm_id": args?.forumId, "comment": comment}));
    } else {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.forumPostComment, data: {
          "fourm_id": args?.forumId,
          'post_id': args?.postId,
          'comment': comment
        }),
      );
    }
  }

  @override
  Future<DataState> reportComment(CommentsListArgs? args, int commentId,
      int userId, String text, String email) {
    final ApiHelper<dynamic> helper = ApiHelper<dynamic>();
    if (args?.type == CommentsListType.post) {
      return helper.requestApi(_apiClient.post(
        path: ApiEndpoint.reportComment,
        data: {
          'comment_id': commentId,
          'user_id': userId,
          'text': text,
          'email': email
        },
      ));
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
          _apiClient.post(path: ApiEndpoint.fourmPostCommentReport, data: {
            "fourm_id": args?.forumId,
            "forum_post_comment_id": commentId,
            "email": email,
            "text": text
          }),
          parseItem: CommentReply.fromJson);
    } else {
      return helper.requestApi(
          _apiClient.post(path: ApiEndpoint.forumPostCommentReply, data: {
            "fourm_id": args?.forumId,
            "post_id": args?.postId,
            'comment_id': commentId,
            'text': text,
            'email': email
          }),
          parseItem: CommentReply.fromJson);
    }
  }

  @override
  Future<DataState<CommentReply>> replyCommentPost(
      CommentsListArgs? args, int commentId, int userId, String comment) {
    final ApiHelper<CommentReply> helper = ApiHelper<CommentReply>();
    if (args?.type == CommentsListType.post) {
      return helper.requestApi(
          _apiClient.post(path: ApiEndpoint.replyCommentPost, data: {
            "post_id": args?.postId,
            "comment_id": commentId,
            "comment": comment
          }),
          parseItem: CommentReply.fromJson);
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
          _apiClient.post(path: ApiEndpoint.forumCommentReply, data: {
            "fourm_id": args?.forumId,
            "user_id": userId,
            "comment_id": commentId,
            "comment": comment
          }),
          parseItem: CommentReply.fromJson);
    } else {
      return helper.requestApi(
          _apiClient.post(path: ApiEndpoint.forumPostCommentReply, data: {
            'comment_id': commentId,
            'post_id': args?.postId,
            'text': comment,
            'fourm_id': args?.forumId
          }),
          parseItem: CommentReply.fromJson);
    }
  }

  @override
  Future<DataState> editCommentPost(
      CommentsListArgs? args, int commentId, String comment) {
    final ApiHelper helper = ApiHelper();
    if (args?.type == CommentsListType.post) {
      return helper.requestApi(
        _apiClient.post(
            path: "${ApiEndpoint.postComments}/$commentId",
            data: {'text': comment}),
      );
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
        _apiClient.post(
            path: "${ApiEndpoint.forumComment}/$commentId",
            data: {'comment': comment, 'fourm_id': args?.forumId}),
      );
    } else {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.forumPostCommentEdit, data: {
          "fourm_id": args?.forumId,
          'post_id': args?.postId,
          'comment_id': commentId,
          'comment': comment
        }),
      );
    }
  }

  @override
  Future<DataState> deleteCommentPost(CommentsListArgs? args, int commentId) {
    final ApiHelper helper = ApiHelper();
    if (args?.type == CommentsListType.post) {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.deleteCommentPost, data: {
          'post_id': args?.postId,
          'comment_id': commentId,
        }),
      );
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
        _apiClient.delete(path: "${ApiEndpoint.forumComment}/$commentId"),
      );
    } else {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.fourmPostCommentDelete, data: {
          'post_id': args?.postId,
          'comment_id': commentId,
        }),
      );
    }
  }

  @override
  Future<DataState> editCommentPostReply(CommentsListArgs? args, int userId,
      int commentId, int commentReplyId, String comment) {
    final ApiHelper helper = ApiHelper();

    if (args?.type == CommentsListType.post) {
      return helper.requestApi(
        _apiClient.post(
            path: "${ApiEndpoint.replyCommentPost}/$commentReplyId",
            data: {'comment': comment}),
      );
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.editfourmCommentReply, data: {
          "fourm_id": args?.forumId,
          'comment_id': commentId,
          'comment_reply_id': commentReplyId,
          'user_id': userId,
          'comment': comment
        }),
      );
    } else {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.fourmPostReplyEdit, data: {
          "fourm_id": args?.forumId,
          'post_id': args?.postId,
          'comment_id': commentId,
          'comment_reply_id': commentReplyId,
          'text': comment
        }),
      );
    }
  }

  @override
  Future<DataState> deleteCommentPostReply(
      CommentsListArgs? args, int commentId, int commentReplyId) {
    final ApiHelper helper = ApiHelper();
    if (args?.type == CommentsListType.post) {
      return helper.requestApi(
        _apiClient.delete(
            path: "${ApiEndpoint.replyCommentPost}/$commentReplyId"),
      );
    } else if (args?.type == CommentsListType.forum) {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.deletefourmCommentReply, data: {
          'fourm_id': args?.forumId,
          'comment_id': commentId,
          'comment_reply_id': commentReplyId,
        }),
      );
    } else {
      return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.fourmPostReplyDelete, data: {
          'fourm_id': args?.forumId,
          'post_id': args?.postId,
          'comment_id': commentId,
          'comment_reply_id': commentReplyId,
        }),
      );
    }
  }
}

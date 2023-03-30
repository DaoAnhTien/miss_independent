import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/forum.dart';
import 'package:miss_independent/models/forum_member.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/models/post_comment.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class ForumService {
  Future<DataState<List<Forum>>> getForums();
  Future<DataState<Forum>> getForumDetail(int forumId);
  Future<DataState<bool>> likeForum(int forumId);
  Future<DataState<dynamic>> likeForumPost(int forumId, int postId);
  Future<DataState<bool>> joinForum(int forumId);
  Future<DataState<bool>> leaveForum(int forumId);
  Future<DataState<List<ForumMember>>> getForumMembers(int forumId);
  Future<DataState<List<Post>>> getForumPopularPosts(int forumId);
  Future<DataState<List<Post>>> getForumAllPosts(int forumId);
  Future<DataState<List<PostComment>>> getForumPostComments(
      int forumId, int postId);
}

@LazySingleton(as: ForumService)
class ForumServiceImpl implements ForumService {
  ForumServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<List<Forum>>> getForums() async {
    try {
      final ApiResponse result =
          await _apiClient.get(path: ApiEndpoint.getForum);
      if (result.message?.isEmpty ?? true) {
        return DataSuccess<List<Forum>>((result.data as List<dynamic>)
            .map<Forum>(
                (dynamic e) => Forum.fromJson(e as Map<String, dynamic>))
            .toList());
      } else {
        return DataFailed<List<Forum>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<Forum>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<Forum>>(e.toString());
    }
  }

  @override
  Future<DataState<Forum>> getForumDetail(int forumId) async {
    try {
      final FormData formData = FormData.fromMap({"fourm_id": forumId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.forumDetail, data: formData);
      if (result.message?.isEmpty ?? true) {
        return DataSuccess<Forum>(
            Forum.fromJson(result.data as Map<String, dynamic>));
      } else {
        return DataFailed<Forum>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Forum>(e.message);
    } on Exception catch (e) {
      return DataFailed<Forum>(e.toString());
    }
  }

  @override
  Future<DataState<List<ForumMember>>> getForumMembers(int forumId) async {
    try {
      final ApiResponse result = await _apiClient
          .post(path: ApiEndpoint.getForumMembers, data: {"fourm_id": forumId});
      if (result.message?.isEmpty ?? true) {
        return DataSuccess<List<ForumMember>>((result.data as List<dynamic>)
            .map<ForumMember>(
                (dynamic e) => ForumMember.fromJson(e as Map<String, dynamic>))
            .toList());
      } else {
        return DataFailed<List<ForumMember>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<ForumMember>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<ForumMember>>(e.toString());
    }
  }

  @override
  Future<DataState<List<Post>>> getForumPopularPosts(int forumId) {
    final ApiHelper<Post> helper = ApiHelper<Post>();
    return helper.getListWithoutMore(
        _apiClient.post(
            path: ApiEndpoint.getForumPopularPosts,
            data: {"fourm_id": forumId}),
        Post.fromForumJson);
  }

  @override
  Future<DataState<List<Post>>> getForumAllPosts(int forumId) {
    final ApiHelper<Post> helper = ApiHelper<Post>();
    return helper.getListWithoutMore(
        _apiClient.post(
            path: ApiEndpoint.getForumAllPosts, data: {"fourm_id": forumId}),
        Post.fromForumJson);
  }

  @override
  Future<DataState<bool>> joinForum(int forumId) async {
    try {
      final FormData formData = FormData.fromMap({"fourm_id": forumId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.joinForum, data: formData);
      if (result.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }

  @override
  Future<DataState<bool>> likeForum(int forumId) async {
    try {
      final FormData formData = FormData.fromMap({"fourm_id": forumId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.likeForum, data: formData);
      if (result.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }

  @override
  Future<DataState<bool>> leaveForum(int forumId) async {
    try {
      final FormData formData = FormData.fromMap({"fourm_id": forumId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.leaveForum, data: formData);
      if (result.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }

  @override
  Future<DataState<List<PostComment>>> getForumPostComments(
      num forumId, int postId) {
    final ApiHelper<PostComment> helper = ApiHelper<PostComment>();
    return helper.getListWithoutMore(
        _apiClient.post(
            path: ApiEndpoint.getForumPostComments,
            data: {"fourm_id": forumId, 'post_id': postId}),
        PostComment.fromJson);
  }

  @override
  Future<DataState> likeForumPost(int forumId, int postId) {
    final ApiHelper helper = ApiHelper();
    return helper.requestApi(
      _apiClient.post(
          path: ApiEndpoint.getForumPostComments,
          data: {"fourm_id": forumId, 'post_id': postId}),
    );
  }
}

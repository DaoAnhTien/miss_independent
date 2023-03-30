import 'package:dio/dio.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../../../models/post.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class PostService {
  Future<DataState<Pagination<Post>>> getHomePosts(int page, String type);
  Future<DataState<bool>> likePost(int postId);
  Future<DataState<bool>> delPost(int postId);
  Future<DataState<dynamic>> repostPost(int postId, int userId, String text);
  Future<DataState<Post>> createPost(String? title, String? text, int postType,
      int category, List<XFile>? files);
}

@LazySingleton(as: PostService)
class PostServiceImpl implements PostService {
  PostServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<Post>>> getHomePosts(
      int page, String type) async {
    final ApiHelper<Post> helper = ApiHelper<Post>();
    return helper.getDataWithMore(
        _apiClient.post(
          path: ApiEndpoint.homePosts,
          data: {'page': page, 'type': type},
        ),
        Post.fromJson);
  }

  @override
  Future<DataState<bool>> likePost(int postId) async {
    try {
      final FormData formData = FormData.fromMap({"post_id": postId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.likePost, data: formData);
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
  Future<DataState<bool>> delPost(int postId) async {
    try {
      final FormData formData = FormData.fromMap({"post_id": postId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.delPost, data: formData);
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
  Future<DataState<Post>> createPost(String? title, String? text, int postType,
      int category, List<XFile>? files) async {
    try {
      Map<String, dynamic> data = {
        "title": title,
        "text": text,
        "post_type": postType,
        "category": category,
      };
      for (var e in (files ?? [])) {
        data['file[]'] = await MultipartFile.fromFile(e.path, filename: e.name);
      }
      final FormData formData = FormData.fromMap(data);

      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.createPost, data: formData);
      if (result.isSuccess() && result.data != null) {
        return DataSuccess<Post>(Post.fromJson(result.data));
      } else {
        return DataFailed<Post>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Post>(e.message);
    } on Exception catch (e) {
      return DataFailed<Post>(e.toString());
    }
  }

  @override
  Future<DataState> repostPost(int postId, int userId, String text) {
    final ApiHelper<dynamic> helper = ApiHelper<dynamic>();
    return helper.requestApi(_apiClient.post(
      path: ApiEndpoint.reportPost,
      data: {'post_id': postId, 'user_id': userId, 'text': text},
    ));
  }
}

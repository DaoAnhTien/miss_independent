import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:injectable/injectable.dart';

import '../common/api_client/data_state.dart';
import '../data/remote/post/post_service.dart';
import '../models/pagination.dart';
import '../models/post.dart';

abstract class PostRepository {
  Future<DataState<Pagination<Post>>> getHomePosts(int page, String type);
  Future<DataState<bool>> likePost(int postId);
  Future<DataState<bool>> delPost(int postId);
  Future<DataState<dynamic>> repostPost(int postId, int userId, String text);
  Future<DataState<Post>> createPost(String? title, String? text, int postType,
      int category, List<XFile>? files);
}

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostService _postService;

  PostRepositoryImpl({required PostService postService})
      : _postService = postService;

  @override
  Future<DataState<Pagination<Post>>> getHomePosts(int page, String type) {
    return _postService.getHomePosts(page, type);
  }

  @override
  Future<DataState<bool>> likePost(int postId) {
    return _postService.likePost(postId);
  }

  @override
  Future<DataState<Post>> createPost(String? title, String? text, int postType,
      int category, List<XFile>? files) {
    return _postService.createPost(title, text, postType, category, files);
  }

  @override
  Future<DataState<bool>> delPost(int postId) {
    return _postService.delPost(postId);
  }

  @override
  Future<DataState> repostPost(int postId, int userId, String text) {
    return _postService.repostPost(postId, userId, text);
  }
}

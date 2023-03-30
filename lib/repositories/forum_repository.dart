import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/api_client/data_state.dart';
import 'package:miss_independent/data/remote/forum/forum_service.dart';
import 'package:miss_independent/models/forum.dart';

import '../models/forum_member.dart';
import '../models/post.dart';
import '../models/post_comment.dart';

abstract class ForumRepository {
  Future<DataState<List<Forum>>> getForums();
  Future<DataState<Forum>> getForumDetail(int forumId);
  Future<DataState<List<ForumMember>>> getForumMembers(int forumId);
  Future<DataState<List<Post>>> getForumPopularPosts(int forumId);
  Future<DataState<List<Post>>> getForumAllPosts(int forumId);
  Future<DataState<dynamic>> likeForumPost(int forumId, int postId);
  Future<DataState<bool>> likeForum(int forumId);
  Future<DataState<bool>> joinForum(int forumId);
  Future<DataState<bool>> leaveForum(int forumId);
  Future<DataState<List<PostComment>>> getForumPostComments(
      int forumId, int postId);
}

@LazySingleton(as: ForumRepository)
class ForumRepositoryImpl implements ForumRepository {
  final ForumService _forumService;

  ForumRepositoryImpl({required ForumService forumService})
      : _forumService = forumService;

  @override
  Future<DataState<List<Forum>>> getForums() {
    return _forumService.getForums();
  }

  @override
  Future<DataState<Forum>> getForumDetail(int forumId) {
    return _forumService.getForumDetail(forumId);
  }

  @override
  Future<DataState<List<ForumMember>>> getForumMembers(int forumId) {
    return _forumService.getForumMembers(forumId);
  }

  @override
  Future<DataState<List<Post>>> getForumPopularPosts(int forumId) {
    return _forumService.getForumPopularPosts(forumId);
  }

  @override
  Future<DataState<List<Post>>> getForumAllPosts(int forumId) {
    return _forumService.getForumAllPosts(forumId);
  }

  @override
  Future<DataState<bool>> joinForum(int forumId) {
    return _forumService.joinForum(forumId);
  }

  @override
  Future<DataState<bool>> leaveForum(int forumId) {
    return _forumService.leaveForum(forumId);
  }

  @override
  Future<DataState<bool>> likeForum(int forumId) {
    return _forumService.likeForum(forumId);
  }

  @override
  Future<DataState<List<PostComment>>> getForumPostComments(
      int forumId, int postId) {
    return _forumService.getForumPostComments(forumId, postId);
  }

  @override
  Future<DataState> likeForumPost(int forumId, int postId) {
    return _forumService.likeForumPost(forumId, postId);
  }
}

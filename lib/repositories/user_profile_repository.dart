import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/user_profile/user_profile_service.dart';

import '../common/api_client/data_state.dart';
import '../models/pagination.dart';
import '../models/post.dart';
import '../models/user_profile.dart';

abstract class UserProfileRepository {
  Future<DataState<UserProfile>> getUserProfile(int userId);
  Future<DataState<Pagination<Post>>> getUserAssets(
    int userId,
    int type,
    int page,
  );
  Future<DataState<List<Post>>> getUserEditorials(int userId);
  Future<DataState<UserProfile>> requestFriend(int userId);
  Future<DataState<UserProfile>> followUser(int userId);
  Future<DataState<UserProfile>> unFollowUser(int userId);
}

@LazySingleton(as: UserProfileRepository)
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileService _userProfileService;

  UserProfileRepositoryImpl({required UserProfileService userProfileService})
      : _userProfileService = userProfileService;

  @override
  Future<DataState<UserProfile>> getUserProfile(int id) {
    return _userProfileService.getUserProfile(id);
  }

  @override
  Future<DataState<Pagination<Post>>> getUserAssets(
      int userId, int type, int page) {
    return _userProfileService.getUserAssets(userId, type, page);
  }

  @override
  Future<DataState<List<Post>>> getUserEditorials(int userId) {
    return _userProfileService.getUserEditorials(userId);
  }

  @override
  Future<DataState<UserProfile>> requestFriend(int id) {
    return _userProfileService.requestFriend(id);
  }
  @override
  Future<DataState<UserProfile>> followUser(int userId) {
    return _userProfileService.followUser(userId);
  }
  
  @override
  Future<DataState<UserProfile>> unFollowUser(int userId) {
   return _userProfileService.unFollowUser(userId);
  }
}

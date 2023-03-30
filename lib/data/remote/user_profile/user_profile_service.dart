import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/models/user_profile.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class UserProfileService {
  Future<DataState<UserProfile>> getUserProfile(int userId);
  Future<DataState<Pagination<Post>>> getUserAssets(
      int userId, int type, int page);
  Future<DataState<List<Post>>> getUserEditorials(int userId);
  Future<DataState<UserProfile>> requestFriend(int userId);
  Future<DataState<UserProfile>> followUser(int userId);
  Future<DataState<UserProfile>> unFollowUser(int userId);
}

@LazySingleton(as: UserProfileService)
class UserProfileServiceImpl implements UserProfileService {
  UserProfileServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<UserProfile>> getUserProfile(int userId) async {
    try {
      final FormData formData = FormData.fromMap({"user_id": userId});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.getUserProfile, data: formData);
      if (result.isSuccess()) {
        return DataSuccess<UserProfile>(
            UserProfile.fromJson(result.data as Map<String, dynamic>));
      } else {
        return DataFailed<UserProfile>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<UserProfile>(e.message);
    } on Exception catch (e) {
      return DataFailed<UserProfile>(e.toString());
    }
  }

  @override
  Future<DataState<Pagination<Post>>> getUserAssets(
      int userId, int type, int page) async {
    final ApiHelper<Post> helper = ApiHelper<Post>();
    return helper.getDataWithMore(
        _apiClient.post(
          path: ApiEndpoint.getUserAssets,
          data: {'page': page, 'type': type, "user_id": userId},
        ),
        Post.fromJson);
  }

  @override
  Future<DataState<List<Post>>> getUserEditorials(int userId) async {
    final ApiHelper<Post> helper = ApiHelper<Post>();
    return helper.getListWithoutMore(
        _apiClient.post(
            path: ApiEndpoint.getUserEditorials, data: {"user_id": userId}),
        Post.fromJson);
  }

  @override
  Future<DataState<UserProfile>> requestFriend(int userId) async {
    try {
      final FormData formData = FormData.fromMap({"frient_id": userId});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.friendRequest, data: formData);
      if (result.isSuccess()) {
        return getUserProfile(userId);
      } else {
        return DataFailed<UserProfile>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<UserProfile>(e.message);
    } on Exception catch (e) {
      return DataFailed<UserProfile>(e.toString());
    }
  }

  @override
  Future<DataState<UserProfile>> followUser(int userId) async {
    try {
     
    final FormData formData = FormData.fromMap({"follow_by": userId});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.followUser, data: formData);
      if (result.isSuccess()) {
        return getUserProfile(userId);
      } else {
        return DataFailed<UserProfile>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<UserProfile>(e.message);
    } on Exception catch (e) {
      return DataFailed<UserProfile>(e.toString());
    }
   
  }
  
  @override
 Future<DataState<UserProfile>> unFollowUser(int userId)async {
  try {
    final FormData formData = FormData.fromMap({"follow_by": userId});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.unFollowUser, data: formData);
      if (result.isSuccess()) {
        return getUserProfile(userId);
      } else {
        return DataFailed<UserProfile>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<UserProfile>(e.message);
    } on Exception catch (e) {
      return DataFailed<UserProfile>(e.toString());
    }
  }
}

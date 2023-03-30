import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/friend_request.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class FriendRequestService {
  Future<DataState<List<FriendRequest>>> getListOfFriendRequests();
  Future<DataState<bool>> acceptFriendRequest(int id);
  Future<DataState<bool>> rejectFriendRequest(int userId);
}

@LazySingleton(as: FriendRequestService)
class FriendRequestServiceImpl implements FriendRequestService {
  FriendRequestServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<List<FriendRequest>>> getListOfFriendRequests() async {
    final ApiHelper<FriendRequest> helper = ApiHelper<FriendRequest>();
    return helper.getListWithoutMore(
        _apiClient.post(
          path: ApiEndpoint.getListofFriendRequests,
        ),
        FriendRequest.fromJson);
  }

  @override
  Future<DataState<bool>> acceptFriendRequest(int id) async {
    try {
      final FormData formData = FormData.fromMap({"id": id});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.acceptFriendRequest, data: formData);
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
  Future<DataState<bool>> rejectFriendRequest(int userId) async {
    try {
      final FormData formData = FormData.fromMap({"id": userId});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.rejectFriendRequest, data: formData);
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
}

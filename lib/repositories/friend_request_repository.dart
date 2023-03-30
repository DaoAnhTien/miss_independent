import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/api_client/data_state.dart';

import '../data/remote/friend_request/friend_request_service.dart';
import '../models/friend_request.dart';

abstract class FriendRequestRepository {
  Future<DataState<List<FriendRequest>>> getListOfFriendRequests();

  Future<DataState<bool>> acceptFriendRequest(int userId);
  Future<DataState<bool>> rejectFriendRequest(int id);
}

@LazySingleton(as: FriendRequestRepository)
class FriendRequestRepositoryImpl implements FriendRequestRepository {
  final FriendRequestService _friendRequestService;

  FriendRequestRepositoryImpl(
      {required FriendRequestService friendRequestService})
      : _friendRequestService = friendRequestService;

  @override
  Future<DataState<List<FriendRequest>>> getListOfFriendRequests() {
    return _friendRequestService.getListOfFriendRequests();
  }

  @override
  Future<DataState<bool>> acceptFriendRequest(int id) {
    return _friendRequestService.acceptFriendRequest(id);
  }

  @override
  Future<DataState<bool>> rejectFriendRequest(int userId) {
    return _friendRequestService.rejectFriendRequest(userId);
  }
}

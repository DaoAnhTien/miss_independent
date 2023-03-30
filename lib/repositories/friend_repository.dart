import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/friend/friend_service.dart';
import 'package:miss_independent/models/friend.dart';

import '../common/api_client/data_state.dart';
import '../models/pagination.dart';

abstract class FriendRepository {
  Future<DataState<Pagination<Friend>>> getFriends(int page);
}

@LazySingleton(as: FriendRepository)
class FriendRepositoryImpl implements FriendRepository {
  final FriendService _friendService;

  FriendRepositoryImpl({required FriendService friendService})
      : _friendService = friendService;

  @override
  Future<DataState<Pagination<Friend>>> getFriends(int page) {
    return _friendService.getFriends(page);
  }
}

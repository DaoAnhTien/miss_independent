import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../models/friend_request.dart';
import '../../../models/pagination.dart';
import '../../../repositories/friend_request_repository.dart';
import 'friend_request_state.dart';

@Injectable()
class FriendRequestCubit extends Cubit<FriendRequestState> {
  late final FriendRequestRepository _friendRequestRepository;

  FriendRequestCubit({required FriendRequestRepository friendRequestRepository})
      : super(const FriendRequestState(friendRequests: [])) {
    _friendRequestRepository = friendRequestRepository;
  }

  Future<void> fetchItems({bool isInit = false}) async {
    emit(state.copyWith(
      status: isInit ? DataSourceStatus.initial : DataSourceStatus.refreshing,
    ));
    try {
      final DataState<List<FriendRequest>> res =
          await _friendRequestRepository.getListOfFriendRequests();
      emit(state.copyWith(
        friendRequests: res.data,
        status: (res.data?.isEmpty ?? true)
            ? DataSourceStatus.empty
            : DataSourceStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> acceptFriendRequest(int id) async {
    try {
      emit(state.copyWith(
        actionStatus: RequestStatus.requesting,
      ));
      final res = await _friendRequestRepository.acceptFriendRequest(id);
      if (res is DataSuccess) {
        emit(state.copyWith(
            friendRequests: state.friendRequests
                ?.where((element) => element.id != id)
                .toList(),
            actionStatus: RequestStatus.success,
            status: state.friendRequests?.length == 1
                ? DataSourceStatus.empty
                : state.status));
      } else {
        emit(state.copyWith(
          message: res.message,
          actionStatus: RequestStatus.failed,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          actionStatus: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> rejectFriendRequest(int userId) async {
    try {
      emit(state.copyWith(
        actionStatus: RequestStatus.requesting,
      ));
      final res = await _friendRequestRepository.rejectFriendRequest(userId);
      if (res is DataSuccess) {
        emit(state.copyWith(
            friendRequests: state.friendRequests
                ?.where((element) => element.user?.id != userId)
                .toList(),
            actionStatus: RequestStatus.success,
            status: state.friendRequests?.length == 1
                ? DataSourceStatus.empty
                : state.status));
      } else {
        emit(state.copyWith(
          message: res.message,
          actionStatus: RequestStatus.failed,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          actionStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

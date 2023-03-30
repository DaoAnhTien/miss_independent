import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/user.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/user_profile_repository.dart';
import '../../auth/helpers/event_bus_event.dart';
import 'user_profile_state.dart';

@Injectable()
class UserProfileCubit extends Cubit<UserProfileState> with EventBusMixin {
  late final UserProfileRepository _userProfileRepository;

  UserProfileCubit({required UserProfileRepository userProfileRepository})
      : super(const UserProfileState()) {
    _userProfileRepository = userProfileRepository;
    listenEvent<ChangeProfileEvent>((event) {
      getUserProfile();
    });
  }

  void initUser(User? user) {
    emit(state.copyWith(
      userProfile: UserProfile(user: user),
      status: RequestStatus.success,
    ));
  }

  Future<void> getUserProfile() async {
    try {
      final DataState<UserProfile> results = await _userProfileRepository
          .getUserProfile(state.userProfile?.user?.id ?? 0);
      if (results is DataSuccess) {
        emit(state.copyWith(
          userProfile: results.data,
          status: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          status: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> requestFriend() async {
    try {
      emit(state.copyWith(
        addFriendStatus: RequestStatus.requesting,
      ));
      final DataState<UserProfile> results = await _userProfileRepository
          .requestFriend(state.userProfile?.user?.id ?? 0);
      if (results is DataSuccess) {
        emit(state.copyWith(
          userProfile: results.data,
          addFriendStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          addFriendStatus: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          addFriendStatus: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> followUser() async {
    try {
      emit(state.copyWith(
        followStatus: RequestStatus.requesting,
      ));
      final DataState<UserProfile> results = await _userProfileRepository
          .followUser(state.userProfile?.user?.id ?? 0);
      if (results is DataSuccess) {
        emit(state.copyWith(
          userProfile: results.data,
          followStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          followStatus: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          followStatus: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> unFollowUser() async {
    try {
      emit(state.copyWith(
        followStatus: RequestStatus.requesting,
      ));
      final DataState<UserProfile> results = await _userProfileRepository
          .unFollowUser(state.userProfile?.user?.id ?? 0);
      if (results is DataSuccess) {
        emit(state.copyWith(
          userProfile: results.data,
          followStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          followStatus: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          followStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

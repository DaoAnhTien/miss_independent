import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../repositories/user_profile_repository.dart';
import 'user_videos_state.dart';

@Injectable()
class UserVideosCubit extends Cubit<UserVideosState> with EventBusMixin {
  late final UserProfileRepository _userProfileRepository;

  UserVideosCubit({required UserProfileRepository userProfileRepository})
      : super(const UserVideosState(
          videos: [],
        )) {
    _userProfileRepository = userProfileRepository;
  }

  final Pagination<Post> _pagination = Pagination<Post>(data: []);

  void initUser(User? user) {
    emit(state.copyWith(user: user));
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.videos?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _fetchItems(state.user?.id ?? 0, _pagination.currentPage);
  }

  Future<void> loadMoreItems() async {
    if (_pagination.allowMore(state.status)) {
      emit(state.copyWith(status: DataSourceStatus.loadMore));
      _fetchItems(state.user?.id ?? 0, _pagination.nextPage);
    }
  }

  Future<void> _fetchItems(int userId, int page) async {
    try {
      final DataState<Pagination<Post>> results =
          await _userProfileRepository.getUserAssets(userId, 3, page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          videos: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          videos: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/friend.dart';
import 'package:miss_independent/repositories/friend_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import 'friends_state.dart';

@Injectable()
class FriendsCubit extends Cubit<FriendsState> with EventBusMixin {
  late final FriendRepository _friendRepository;

  FriendsCubit({required FriendRepository friendRepository})
      : super(const FriendsState(friends: [])) {
    _friendRepository = friendRepository;
  }

  final Pagination<Friend> _pagination = Pagination<Friend>(data: []);

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.friends?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _fetchItems(_pagination.currentPage);
  }

  Future<void> loadMoreItems() async {
    if (_pagination.allowMore(state.status)) {
      emit(state.copyWith(status: DataSourceStatus.loadMore));
      _fetchItems(_pagination.nextPage);
    }
  }

  Future<void> _fetchItems(int page) async {
    try {
      final DataState<Pagination<Friend>> results =
          await _friendRepository.getFriends(page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          friends: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          friends: _pagination.data,
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

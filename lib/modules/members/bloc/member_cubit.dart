import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/member_local_datasource.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/members/widgets/members_tab.dart';
import 'package:miss_independent/repositories/member_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import 'member_state.dart';

@Injectable()
class MemberCubit extends Cubit<MemberState> with EventBusMixin {
  late final MemberRepository _memberRepository;
  late final MembersLocalDataSource _membersLocalDataSource;
  MemberCubit(
      {required MemberRepository memberRepository,
      required MembersLocalDataSource membersLocalDataSource})
      : super(MemberState(
            members: const [],
            membershipType: MembershipType.dhalia.rawValue)) {
    _memberRepository = memberRepository;
    _membersLocalDataSource = membersLocalDataSource;
  }

  final Pagination<User> _pagination = Pagination<User>(data: []);

  void _initData(String type) {
    var items = _membersLocalDataSource.getMembers(type);
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        members: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.members?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _initData(MembersTab.latest.rawValue);
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
      final DataState<Pagination<User>> results =
          await _memberRepository.getMemberLatest(page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          members: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        if (page == 1) {
          _membersLocalDataSource.saveMembers(
              _pagination.data, MembersTab.latest.rawValue);
        }
      } else {
        emit(state.copyWith(
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  // get MemberOnline
  Future<void> refreshItemsOnline(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.members?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _initData(MembersTab.online.rawValue);
    _fetchItemsOnline(_pagination.currentPage);
  }

  Future<void> loadMoreItemsOnline() async {
    if (_pagination.allowMore(state.status)) {
      emit(state.copyWith(status: DataSourceStatus.loadMore));
      _fetchItemsOnline(_pagination.nextPage);
    }
  }

  Future<void> _fetchItemsOnline(int page) async {
    try {
      final DataState<Pagination<User>> results =
          await _memberRepository.getMemberOnline(page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          members: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        if (page == 1) {
          _membersLocalDataSource.saveMembers(
              _pagination.data, MembersTab.online.rawValue);
        }
      } else {
        emit(state.copyWith(
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  // Get membership
  void changeMemberShipType(String? type) {
    emit(state.copyWith(membershipType: type));
    if (type == MembershipType.serviceProvider.rawValue &&
        state.serviceProviderType == null) {
      emit(state.copyWith(
          serviceProviderType: ServiceProviderType.coachMentor.rawValue));
    }
    refreshItemsMembership(isInit: true);
  }

  void changeServiceProviderType(String? type) {
    emit(state.copyWith(serviceProviderType: type));
    refreshItemsMembership(isInit: true);
  }

  Future<void> refreshItemsMembership(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.members?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _initData(MembersTab.membership.rawValue);
    _fetchItemsMembership(_pagination.currentPage);
  }

  Future<void> loadMoreItemsMembership() async {
    if (_pagination.allowMore(state.status)) {
      emit(state.copyWith(status: DataSourceStatus.loadMore));
      _fetchItemsMembership(_pagination.nextPage);
    }
  }

  Future<void> _fetchItemsMembership(int page) async {
    try {
      var type = '';
      if (state.membershipType == MembershipType.serviceProvider.rawValue) {
        type = state.serviceProviderType ?? '';
      } else {
        type = state.membershipType ?? '';
      }
      final DataState<Pagination<User>> results =
          await _memberRepository.getMemberShip(page, type);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          members: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        if (page == 1 &&
            state.membershipType == MembershipType.tulip.rawValue) {
          _membersLocalDataSource.saveMembers(
              _pagination.data, MembersTab.membership.rawValue);
        }
      } else {
        emit(state.copyWith(
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

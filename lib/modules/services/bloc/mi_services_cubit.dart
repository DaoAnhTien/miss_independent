import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/user.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/category.dart';
import '../../../models/pagination.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/mi_services_repository.dart';
import 'mi_services_state.dart';

@Injectable()
class MIServicesCubit extends Cubit<MIServicesState> {
  final AuthRepository _authRepository;
  final MIServicesRepository _miServicesRepository;

  MIServicesCubit(
      {required AuthRepository authRepository,
      required MIServicesRepository miServicesRepository})
      : _authRepository = authRepository,
        _miServicesRepository = miServicesRepository,
        super(const MIServicesState(users: []));
  final Pagination<User> _pagination = Pagination<User>(data: []);

  void initWithType(ServiceProviderType type) {
    emit(state.copyWith(type: type));
  }

  Future<void> getCategories() async {
    try {
      if (state.type == ServiceProviderType.coachMentor) {
        final DataState<List<Category>> coachingCategories =
            await _authRepository.getCategories("coaching-training");
        emit(state.copyWith(categories: coachingCategories.data));
      } else {
        final DataState<List<Category>> coachingCategories =
            await _authRepository.getCategories("service-consultancy");
        emit(state.copyWith(categories: coachingCategories.data));
      }
    } on Exception catch (_) {}
  }

  Future<void> searchServices(String? text, String? location,
      String? categoryName) async {
    _pagination.reset();
    emit(state.copyWith(status: DataSourceStatus.loading));
    try {
      final DataState<Pagination<User>> results =
          await _miServicesRepository.searchServices(
              text,
              location,
              categoryName,
              1,
              state.type ?? ServiceProviderType.coachMentor);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          users: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          users: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.users?.isEmpty ?? true)) {
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
      final DataState<Pagination<User>> results = await _miServicesRepository
          .getServices(page, state.type ?? ServiceProviderType.coachMentor);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          users: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          users: _pagination.data,
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

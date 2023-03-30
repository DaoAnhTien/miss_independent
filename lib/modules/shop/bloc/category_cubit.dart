import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/category_local_datasource.dart';
import 'package:miss_independent/repositories/auth_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/category.dart';
import '../../../models/pagination.dart';
import 'category_state.dart';

@Injectable()
class CategoryCubit extends Cubit<CategoryState> {
  late final AuthRepository _authRepository;
  late final CategoryLocalDatasource _categoryLocalDatasource;

  CategoryCubit(
      {required AuthRepository authRepository,
      required CategoryLocalDatasource categoryLocalDatasource})
      : super(const CategoryState(categories: [])) {
    _authRepository = authRepository;
    _categoryLocalDatasource = categoryLocalDatasource;
  }

  Future<void> getCategories() async {
    try {
      final items = _categoryLocalDatasource.getGeneralCategories();
      if (items?.isNotEmpty ?? false) {
        emit(state.copyWith(
            categories: _categoryLocalDatasource.getGeneralCategories(),
            status: DataSourceStatus.success));
      } else {
        emit(state.copyWith(status: DataSourceStatus.initial));
      }
      final DataState<List<Category>> res =
          await _authRepository.getCategories("general");
      unawaited(_categoryLocalDatasource.saveGeneralCategories(res.data));
      emit(state.copyWith(
          categories: res.data,
          status: (res.data?.isNotEmpty ?? false)
              ? DataSourceStatus.success
              : DataSourceStatus.empty));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }
}

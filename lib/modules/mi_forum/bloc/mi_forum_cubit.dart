import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/forum_local_datasource.dart';
import 'package:miss_independent/models/forum.dart';
import 'package:miss_independent/repositories/forum_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import 'mi_forum_state.dart';

@Injectable()
class MiForumCubit extends Cubit<MiForumState> {
  late final ForumRepository _forumRepository;
  late final ForumLocalDatasource _forumLocalDatasource;

  MiForumCubit(
      {required ForumRepository forumRepository,
      required ForumLocalDatasource forumLocalDatasource})
      : super(const MiForumState()) {
    _forumRepository = forumRepository;
    _forumLocalDatasource = forumLocalDatasource;
    _initData();
  }

  void _initData() {
    var items = _forumLocalDatasource.getForums();
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        forums: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  Future<void> fetchItems() async {
    try {
      final DataState<List<Forum>> res = await _forumRepository.getForums();
      emit(state.copyWith(
        forums: res.data,
        status: DataSourceStatus.success,
      ));
      _forumLocalDatasource.saveForums(res.data);
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/category_local_datasource.dart';
import 'package:miss_independent/modules/home/widgets/home_tabs.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../data/local/datasource/home_posts_local_datasource.dart';
import '../../../models/category.dart';
import '../../../models/pagination.dart';
import '../../../models/post.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/post_repository.dart';
import 'home_posts_state.dart';

@Injectable()
class HomePostsCubit extends Cubit<HomePostsState> with EventBusMixin {
  late final PostRepository _postRepository;
  late final HomePostsLocalDataSource _homePostsLocalDataSource;
  late final AuthRepository _authRepository;
  late final CategoryLocalDatasource _categoryLocalDatasource;

  HomePostsCubit({
    required PostRepository postRepository,
    required HomePostsLocalDataSource homePostsLocalDataSource,
    required AuthRepository authRepository,
    required CategoryLocalDatasource categoryLocalDatasource,
  }) : super(const HomePostsState(posts: [])) {
    _postRepository = postRepository;
    _homePostsLocalDataSource = homePostsLocalDataSource;
    _authRepository = authRepository;
    _categoryLocalDatasource = categoryLocalDatasource;
    _initData();
    _syncGeneralCategories();
  }

  final Pagination<Post> _pagination = Pagination<Post>(data: []);

  void changeType(String type) {
    emit(state.copyWith(type: type, posts: []));
    _initData();
    refreshItems(isInit: true);
  }

  Future _syncGeneralCategories() async {
    try {
      final DataState<List<Category>> res =
          await _authRepository.getCategories("general");
      _categoryLocalDatasource.saveGeneralCategories(res.data);
    } on Exception catch (_) {}
  }

  void _initData() {
    var items = _homePostsLocalDataSource
        .getHomePosts(state.type ?? HomePostType.latest.rawValue);
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        posts: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.posts?.isEmpty ?? true)) {
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
      final DataState<Pagination<Post>> results =
          await _postRepository.getHomePosts(page, state.type ?? '');
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          posts: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        if (page == 1) {
          _homePostsLocalDataSource.saveHomePosts(
              _pagination.data, state.type ?? HomePostType.latest.rawValue);
        }
      } else {
        emit(state.copyWith(
          posts: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> likePost(int postId) async {
    try {
      final DataState<bool> result = await _postRepository.likePost(postId);
      if (result is DataSuccess) {
        emit(state.copyWith(
          posts: state.posts
              ?.map((e) => e.id == postId
                  ? e.copyWith(
                      totalLikes: e.likedByLoggedInUser == true
                          ? ((e.totalLikes ?? 0) - 1)
                          : ((e.totalLikes ?? 0) + 1),
                      likedByLoggedInUser: !(e.likedByLoggedInUser ?? true),
                    )
                  : e)
              .toList(),
          status: DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
            status: DataSourceStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> delPost(int postId) async {
    emit(state.copyWith(delPostStatus: RequestStatus.requesting));
    try {
      final DataState<bool> result = await _postRepository.delPost(postId);
      if (result is DataSuccess) {
        emit(state.copyWith(
            posts:
                state.posts?.where((element) => element.id != postId).toList(),
            delPostStatus: RequestStatus.success,
            status: state.posts
                        ?.where((element) => element.id != postId)
                        .toList()
                        .isEmpty ==
                    true
                ? DataSourceStatus.empty
                : DataSourceStatus.success));
      } else {
        emit(state.copyWith(
            delPostStatus: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          delPostStatus: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> reportPost(int postId, int userId, String text) async {
    emit(state.copyWith(reportPostStatus: RequestStatus.requesting));
    try {
      final DataState<dynamic> result =
          await _postRepository.repostPost(postId, userId, text);
      if (result is DataSuccess) {
        emit(state.copyWith(
          reportPostStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
            reportPostStatus: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          reportPostStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

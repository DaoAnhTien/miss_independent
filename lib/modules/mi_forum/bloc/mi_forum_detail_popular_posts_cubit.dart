import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_popular_posts_state.dart';
import 'package:miss_independent/repositories/forum_repository.dart';

import '../../../common/api_client/data_state.dart';

@Injectable()
class MIForumDetailPopularPostsCubit
    extends Cubit<MIForumDetailPopularPostsState> {
  late final ForumRepository _forumRepository;

  MIForumDetailPopularPostsCubit({required ForumRepository forumRepository})
      : super(const MIForumDetailPopularPostsState(posts: [])) {
    _forumRepository = forumRepository;
  }
  Future<void> fetchItems(int forumId) async {
    try {
      final DataState<List<Post>> results =
          await _forumRepository.getForumPopularPosts(forumId);
      if (results is DataSuccess) {
        emit(state.copyWith(
          posts: results.data,
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

  Future<void> likePost(int forumId, int postId) async {
    try {
      final DataState results =
          await _forumRepository.likeForumPost(forumId, postId);
      if (results is DataSuccess) {
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
}

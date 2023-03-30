import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/repositories/forum_repository.dart';

import '../../../common/api_client/data_state.dart';
import 'mi_forum_detail_all_posts_state.dart';

@Injectable()
class MIForumDetailAllPostsCubit extends Cubit<MIForumDetailAllPostsState> {
  late final ForumRepository _forumRepository;

  MIForumDetailAllPostsCubit({required ForumRepository forumRepository})
      : super(const MIForumDetailAllPostsState(posts: [])) {
    _forumRepository = forumRepository;
  }
  Future<void> fetchItems(int forumId) async {
    try {
      final DataState<List<Post>> results =
          await _forumRepository.getForumAllPosts(forumId);
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
}

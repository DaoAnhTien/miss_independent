import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/repositories/post_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import '../../../models/post.dart';
import '../../../repositories/user_profile_repository.dart';
import 'user_editorials_state.dart';

@Injectable()
class UserEditorialsCubit extends Cubit<UserEditorialsState>
    with EventBusMixin {
  late final UserProfileRepository _userProfileRepository;
  late final PostRepository _postRepository;

  UserEditorialsCubit({required UserProfileRepository userProfileRepository,required PostRepository postRepository})
      : super(const UserEditorialsState(editorials: [])) {
    _userProfileRepository = userProfileRepository;
    _postRepository = postRepository;
  }

  Future<void> fetchItems(int userId) async {
    try {
      final DataState<List<Post>> results =
          await _userProfileRepository.getUserEditorials(userId);
      if (results is DataSuccess) {
        emit(state.copyWith(
          editorials: results.data,
          status: (results.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
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
 Future<void> likePost(int postId) async {
    try {
      final DataState<bool> result = await _postRepository.likePost(postId);
      if (result is DataSuccess) {
        emit(state.copyWith(
          editorials: state.editorials
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
}

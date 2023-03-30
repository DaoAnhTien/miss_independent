import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/forum.dart';
import 'package:miss_independent/repositories/forum_repository.dart';

import '../../../common/api_client/data_state.dart';
import 'mi_forum_detail_state.dart';

@Injectable()
class MiForumDetailCubit extends Cubit<MiForumDetailState> {
  late final ForumRepository _forumRepository;

  MiForumDetailCubit({required ForumRepository forumRepository})
      : super(const MiForumDetailState()) {
    _forumRepository = forumRepository;
  }
  void initForum(Forum? forum) {
    emit(state.copyWith(forum: forum));
  }

  Future<void> getForumDetail() async {
    try {
      emit(state.copyWith(
        status: RequestStatus.requesting,
      ));
      final DataState<Forum> res =
          await _forumRepository.getForumDetail(state.forum?.id ?? 0);
      emit(state.copyWith(
        forum: res.data,
        status: RequestStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> likeForum() async {
    try {
      await _forumRepository.likeForum(state.forum?.id ?? 0);
      emit(state.copyWith(
        forum: state.forum?.copyWith(liked: !(state.forum?.liked ?? true)),
        status: RequestStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> joinForum() async {
    try {
      await _forumRepository.joinForum(state.forum?.id ?? 0);
      emit(state.copyWith(
        forum: state.forum?.copyWith(joined: true),
        status: RequestStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> leaveForum() async {
    try {
      await _forumRepository.leaveForum(state.forum?.id ?? 0);
      emit(state.copyWith(
        forum: state.forum?.copyWith(joined: false),
        status: RequestStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }
}

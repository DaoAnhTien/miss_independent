import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/forum_member.dart';
import 'package:miss_independent/repositories/forum_repository.dart';

import '../../../common/api_client/data_state.dart';
import 'mi_forum_detail_members_state.dart';

@Injectable()
class MiForumDetailMembersCubit extends Cubit<MiForumDetailMembersState> {
  late final ForumRepository _forumRepository;

  MiForumDetailMembersCubit({required ForumRepository forumRepository})
      : super(const MiForumDetailMembersState(members: [])) {
    _forumRepository = forumRepository;
  }
  Future<void> fetchItems(int forumId) async {
    try {
      final DataState<List<ForumMember>> results =
          await _forumRepository.getForumMembers(forumId);
      if (results is DataSuccess) {
        emit(state.copyWith(
          members: results.data,
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

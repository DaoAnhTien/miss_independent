import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/modules/post_comments/bloc/report_comment_state.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/post_comment.dart';
import '../../../repositories/post_comments_repository.dart';
import '../../../widgets/comments_list/comments_list.dart';

@Injectable()
class ReportCommentCubit extends Cubit<ReportCommentState> {
  late final PostCommentsRepository _postCommentsRepository;

  ReportCommentCubit({required PostCommentsRepository postCommentsRepository})
      : super(const ReportCommentState()) {
    _postCommentsRepository = postCommentsRepository;
  }
  void init(PostComment? comment, CommentsListArgs? args) {
    emit(state.copyWith(comment: comment, args: args));
  }

  Future<void> reportComment(int userId, String text, String email) async {
    try {
      emit(state.copyWith(
        status: RequestStatus.requesting,
      ));
      final DataState<dynamic> res =
          await _postCommentsRepository.reportComment(
              state.args, state.comment?.id ?? 0, userId, text, email);
      if (res is DataSuccess) {
        emit(state.copyWith(
          status: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: res.message,
          status: RequestStatus.failed,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: RequestStatus.failed,
      ));
    }
  }
}

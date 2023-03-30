import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/widgets/comments_list/helpers/event_bus_events.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/post_comment.dart';
import '../../../repositories/post_comments_repository.dart';
import '../comments_list.dart';
import 'comment_reply_state.dart';

@Injectable()
class CommentReplyCubit extends Cubit<CommentReplyState> with EventBusMixin {
  late final PostCommentsRepository _postCommentsRepository;

  CommentReplyCubit({required PostCommentsRepository postCommentsRepository})
      : super(const CommentReplyState()) {
    _postCommentsRepository = postCommentsRepository;
  }
  void init(CommentsListArgs? args, int commentId, CommentReply reply) {
    emit(state.copyWith(args: args, commentId: commentId, reply: reply));
  }

  Future<void> editCommentPostReply(int currentUserId, String text) async {
    try {
      emit(state.copyWith(
        editStatus: RequestStatus.requesting,
        status: RequestStatus.requesting,
      ));
      final DataState res = await _postCommentsRepository.editCommentPostReply(
          state.args,
          currentUserId,
          state.reply?.forumPostCommentId ?? 0,
          state.reply?.id ?? 0,
          text);
      if (res is DataSuccess) {
        emit(state.copyWith(
            editStatus: RequestStatus.success,
            status: RequestStatus.success,
            reply: state.reply?.copyWith(reply: text)));
      } else {
        emit(state.copyWith(
          editStatus: RequestStatus.failed,
          status: RequestStatus.failed,
          message: res.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
        editStatus: RequestStatus.failed,
        status: RequestStatus.failed,
        message: e.toString(),
      ));
    }
  }

  Future<void> deleteCommentPostReply() async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState res =
          await _postCommentsRepository.deleteCommentPostReply(state.args,
              state.reply?.forumPostCommentId ?? 0, state.reply?.id ?? 0);
      if (res is DataSuccess) {
        emit(state.copyWith(status: RequestStatus.success));
        shareEvent(DeleteCommentReplyEvent(
            reply: state.reply, commentId: state.commentId));
      } else {
        emit(state.copyWith(
          status: RequestStatus.failed,
          message: res.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
        status: RequestStatus.failed,
        message: e.toString(),
      ));
    }
  }
}

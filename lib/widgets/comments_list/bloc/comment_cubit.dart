import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/post_comment.dart';
import '../../../repositories/post_comments_repository.dart';
import '../comments_list.dart';
import '../helpers/event_bus_events.dart';
import 'comment_state.dart';

@Injectable()
class CommentCubit extends Cubit<CommentState> with EventBusMixin {
  late final PostCommentsRepository _postCommentsRepository;
  StreamSubscription<DeleteCommentReplyEvent>? _deleteSubscription;

  CommentCubit({required PostCommentsRepository postCommentsRepository})
      : super(const CommentState()) {
    _postCommentsRepository = postCommentsRepository;
    _deleteSubscription = listenEvent<DeleteCommentReplyEvent>((event) {
      if (event.commentId == state.comment?.id) {
        var replies = state.comment?.replies
            ?.where((element) => element.id != event.reply?.id)
            .toList();
        emit(
            state.copyWith(comment: state.comment?.copyWith(replies: replies)));
      }
    });
  }

  @override
  Future<void> close() {
    _deleteSubscription?.cancel();
    return super.close();
  }

  void init(CommentsListArgs? args, PostComment comment) {
    emit(state.copyWith(args: args, comment: comment));
  }

  Future<void> replyCommentPost(int userId, String text) async {
    try {
      emit(state.copyWith(
        sendStatus: RequestStatus.requesting,
      ));
      final DataState<CommentReply> res = await _postCommentsRepository
          .replyCommentPost(state.args, state.comment?.id ?? 0, userId, text);
      if (res is DataSuccess && res.data != null) {
        emit(state.copyWith(
            sendStatus: RequestStatus.success,
            comment: state.comment
                ?.copyWith(replies: [...?state.comment?.replies, res.data!])));
      } else {
        emit(state.copyWith(
            message: res.message,
            sendStatus: RequestStatus.failed,
            status: RequestStatus.failed));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          sendStatus: RequestStatus.failed,
          status: RequestStatus.failed));
    }
  }

  Future<void> editCommentPost(String text) async {
    try {
      emit(state.copyWith(
        editStatus: RequestStatus.requesting,
      ));
      final DataState res = await _postCommentsRepository.editCommentPost(
          state.args, state.comment?.id ?? 0, text);
      if (res is DataSuccess) {
        emit(state.copyWith(
            editStatus: RequestStatus.success,
            message: res.message,
            comment: state.comment?.copyWith(text: text)));
      } else {
        emit(state.copyWith(
            editStatus: RequestStatus.failed,
            message: res.message,
            status: RequestStatus.failed));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          editStatus: RequestStatus.failed,
          message: e.toString(),
          status: RequestStatus.failed));
    }
  }

  Future<void> deleteCommentPost() async {
    try {
      emit(state.copyWith(
          delStatus: RequestStatus.requesting,
          status: RequestStatus.requesting));
      final DataState res = await _postCommentsRepository.deleteCommentPost(
          state.args, state.comment?.id ?? 0);
      if (res is DataSuccess) {
        emit(state.copyWith(delStatus: RequestStatus.success));
        shareEvent(DeleteCommentEvent(postComment: state.comment));
      } else {
        emit(state.copyWith(
            delStatus: RequestStatus.failed,
            message: res.message,
            status: RequestStatus.failed));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          delStatus: RequestStatus.failed,
          message: e.toString(),
          status: RequestStatus.failed));
    }
  }
}

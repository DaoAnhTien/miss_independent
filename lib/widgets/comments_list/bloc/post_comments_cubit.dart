import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/widgets/comments_list/bloc/post_comments_state.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import '../../../models/post_comment.dart';
import '../../../repositories/post_comments_repository.dart';
import '../comments_list.dart';
import '../helpers/event_bus_events.dart';

@Injectable()
class PostCommentsCubit extends Cubit<PostCommentsState> with EventBusMixin {
  late final PostCommentsRepository _postCommentsRepository;
  StreamSubscription<DeleteCommentEvent>? _deleteSubscription;
  PostCommentsCubit({required PostCommentsRepository postCommentsRepository})
      : super(const PostCommentsState(postComments: [])) {
    _postCommentsRepository = postCommentsRepository;
    _deleteSubscription = listenEvent<DeleteCommentEvent>((event) {
      if (state.postComments?.isNotEmpty == true) {
        var res = state.postComments!
            .where((element) => element.id != event.postComment?.id)
            .toList();
        emit(state.copyWith(postComments: res));
      }
    });
  }
  void init(CommentsListArgs? args) {
    emit(state.copyWith(args: args));
  }

  @override
  Future<void> close() {
    _deleteSubscription?.cancel();
    return super.close();
  }

  Future<void> fetchComments({bool isInit = false}) async {
    emit(state.copyWith(
        status: isInit ? DataSourceStatus.initial : DataSourceStatus.refreshing,
        sendStatus: RequestStatus.initial));
    try {
      final DataState<List<PostComment>> res =
          await _postCommentsRepository.getPostComments(state.args);
      emit(state.copyWith(
        postComments: res.data,
        status: (res.data?.isEmpty ?? true)
            ? DataSourceStatus.empty
            : DataSourceStatus.success,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> commentPost(String text) async {
    try {
      emit(state.copyWith(
        sendStatus: RequestStatus.requesting,
      ));
      final DataState res =
          await _postCommentsRepository.commentPost(state.args, text);
      if (res is DataSuccess) {
        emit(state.copyWith(
          sendStatus: RequestStatus.success,
        ));
        await fetchComments();
      } else {
        emit(state.copyWith(
          message: res.message,
          sendStatus: RequestStatus.failed,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        sendStatus: RequestStatus.failed,
      ));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/post.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../repositories/post_repository.dart';
import 'add_post_state.dart';

@Injectable()
class AddPostCubit extends Cubit<AddPostState> with EventBusMixin {
  late final PostRepository _postRepository;

  AddPostCubit({required PostRepository postRepository})
      : super(const AddPostState()) {
    _postRepository = postRepository;
  }

  Future<void> createPost(String? title, String? text, int postType,
      int category, List<XFile>? files) async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState<Post> result = await _postRepository.createPost(
          title, text, postType, category, files);
      if (result is DataSuccess) {
        emit(state.copyWith(status: RequestStatus.success));
      } else {
        emit(state.copyWith(
            status: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }
}

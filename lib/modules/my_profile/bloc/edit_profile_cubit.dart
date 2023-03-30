import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';
import 'package:miss_independent/modules/auth/helpers/event_bus_event.dart';
import 'package:miss_independent/repositories/auth_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../data/remote/auth/request_models/update_profile_request.dart';
import '../../../models/user.dart';
import 'edit_profile_state.dart';

@Injectable()
class EditProfileCubit extends Cubit<EditProfileState> with EventBusMixin {
  late final AuthRepository _authRepository;

  EditProfileCubit({required AuthRepository authRepository})
      : super(const EditProfileState()) {
    _authRepository = authRepository;
  }

  void init(User? user) {
    emit(state.copyWith(user: user));
  }

  Future<void> editProfile(UpdateProfileRequest request) async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState<bool> result =
          await _authRepository.editProfile(request.copyWith(
        categories: state.user?.categories,
      ));
      if (result.data == true) {
        shareEvent( ChangeProfileEvent());
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

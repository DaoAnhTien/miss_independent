import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/modules/my_profile/bloc/change_password_state.dart';
import 'package:miss_independent/repositories/auth_repository.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';

@Injectable()
class ChangePasswordCubit extends Cubit<ChangePasswordState> with EventBusMixin {
  late final AuthRepository _authRepository;

  ChangePasswordCubit({required AuthRepository authRepository})
      : super( const ChangePasswordState()) {
    _authRepository = authRepository;
  }
  Future<void> changePassword(String currentPass,  String newPass) async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState<String?> result =
      await _authRepository.changePassword(currentPass,newPass);
      if (result is DataSuccess) {
        emit(state.copyWith(status: RequestStatus.success,message: result.message));
      } else {
        emit(state.copyWith(
            status: RequestStatus.failed,
            message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: RequestStatus.failed,
          message: e.toString()));
    }
  }

}

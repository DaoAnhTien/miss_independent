import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';
import 'package:miss_independent/data/remote/auth/request_models/login_request.dart';
import 'package:miss_independent/modules/auth/helpers/event_bus_event.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../data/local/datasource/auth_local_datasource.dart';
import '../../../data/remote/auth/request_models/create_profile_request.dart';
import '../../../data/remote/auth/request_models/register_request.dart';
import '../../../data/remote/auth/response_models/auth_response.dart';
import '../../../models/category.dart';
import '../../../models/user.dart';
import '../../../repositories/auth_repository.dart';
import 'auth_state.dart';

@Singleton()
class AuthCubit extends Cubit<AuthState> with EventBusMixin {
  final AuthRepository _authRepository;
  final AuthLocalDatasource _authLocalDatasource;
  AuthCubit(
      {required AuthRepository authRepository,
      required AuthLocalDatasource authLocalDatasource})
      : _authRepository = authRepository,
        _authLocalDatasource = authLocalDatasource,
        super(const AuthState()) {
    listenEvent<ChangeProfileEvent>((event) {
      getMyProfile();
    });
  }

  Future<void> init() async {
    final String? token = _authLocalDatasource.getLoggedInToken();
    final User? userInfo = _authLocalDatasource.getLoggedInUser();
    if (token != null) {
      emit(state.copyWith(
          user: userInfo, token: token, loginStatus: RequestStatus.success));
    } else {
      emit(state.copyWith(loginStatus: RequestStatus.success));
    }
  }

  Future<void> login(String email, String password, String? fcmToken) async {
    try {
      emit(AuthState.initState()
          .copyWith(loginStatus: RequestStatus.requesting));
      final DataState<AuthResponse> result = await _authRepository.login(
          LoginRequest(email: email, password: password, fcmToken: fcmToken));
      if (result is DataSuccess) {
        if (result.data?.isInActive == false) {
          emit(state.copyWith(
              email: email,
              isInActive: false,
              isNotCreatedProfile: false,
              loginStatus: RequestStatus.success));
        } else if (result.data?.isNotCreatedProfile == false) {
          emit(state.copyWith(
              email: email,
              token: result.data?.token,
              isInActive: true,
              isNotCreatedProfile: false,
              loginStatus: RequestStatus.success));
        } else {
          emit(state.copyWith(
              email: email,
              token: result.data?.token,
              isInActive: true,
              isNotCreatedProfile: true,
              loginStatus: RequestStatus.success));
        }
      } else {
        emit(state.copyWith(
            loginStatus: RequestStatus.failed, loginMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          loginStatus: RequestStatus.failed, loginMessage: e.toString()));
    }
  }

  Future<void> register(
    String email,
    String password,
    String? dob,
    String? fcmToken,
  ) async {
    try {
      emit(AuthState.initState()
          .copyWith(signUpStatus: RequestStatus.requesting));
      final DataState<AuthResponse> result = await _authRepository.register(
          RegisterRequest(
              email: email, password: password, fcmToken: fcmToken, dob: dob));
      if (result is DataSuccess) {
        emit(state.copyWith(
            email: email,
            token: result.data?.token,
            signUpStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            signUpStatus: RequestStatus.failed, signUpMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          signUpStatus: RequestStatus.failed, signUpMessage: e.toString()));
    }
  }

  Future<void> verifyEmail(String verifyCode) async {
    try {
      emit(state.copyWith(verifyStatus: RequestStatus.requesting));
      final DataState<AuthResponse> result =
          await _authRepository.verifyEmail(state.email ?? '', verifyCode);
      if (result is DataSuccess) {
        emit(state.copyWith(
            token: result.data?.token, verifyStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            verifyStatus: RequestStatus.failed, verifyMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          verifyStatus: RequestStatus.failed, verifyMessage: e.toString()));
    }
  }

  Future<void> getCategories() async {
    try {
      final DataState<List<Category>> generalCategories =
          await _authRepository.getCategories("general");
      final DataState<List<Category>> softCategories =
          await _authRepository.getCategories("soft-skills-coaching-training");
      final DataState<List<Category>> serviceCategories =
          await _authRepository.getCategories("service-consultancy");
      final DataState<List<Category>> coachingCategories =
          await _authRepository.getCategories("coaching-training");
      emit(state.copyWith(
          generalCategories: generalCategories.data,
          softCategories: softCategories.data,
          serviceCategories: serviceCategories.data,
          coachingCategories: coachingCategories.data));
    } on Exception catch (_) {}
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(const AuthState());
    } on Exception catch (_) {}
  }

  Future<void> createProfile(CreateProfileRequest createProfileRequest) async {
    try {
      emit(state.copyWith(createProfileStatus: RequestStatus.requesting));
      final DataState<AuthResponse> result =
          await _authRepository.createProfile(
        createProfileRequest,
      );
      if (result is DataSuccess) {
        emit(state.copyWith(
            token: result.data?.token,
            createProfileStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            createProfileStatus: RequestStatus.failed,
            createProfileMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          createProfileStatus: RequestStatus.failed,
          createProfileMessage: e.toString()));
    }
  }

  Future<void> getMyProfile() async {
    try {
      final DataState<User> result = await _authRepository.getMyProfile();
      if (result is DataSuccess) {
        emit(state.copyWith(user: result.data));
      }
    } on Exception catch (_) {}
  }

  Future<void> resendVerifyCode() async {
    try {
      emit(state.copyWith(resendStatus: RequestStatus.requesting));
      final DataState<String?> result =
          await _authRepository.resendVerifyCode(state.email ?? '');
      if (result is DataSuccess) {
        emit(state.copyWith(resendStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            resendStatus: RequestStatus.failed, resendMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          resendStatus: RequestStatus.failed, resendMessage: e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(state.copyWith(forgotPassStatus: RequestStatus.requesting));
      final DataState<String?> result =
          await _authRepository.forgotPassword(email);
      if (result is DataSuccess) {
        emit(state.copyWith(forgotPassStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            forgotPassStatus: RequestStatus.failed,
            forgotPassMessage: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          forgotPassStatus: RequestStatus.failed,
          forgotPassMessage: e.toString()));
    }
  }

  Future<bool> deactivateAccount() async {
    try {
      emit(state.copyWith(deactivateStatus: RequestStatus.requesting));
      final DataState<bool?> result = await _authRepository.deactivateAccount();
      if (result is DataSuccess) {
        emit(const AuthState());
        return true;
      } else {
        emit(state.copyWith(
            deactivateStatus: RequestStatus.failed,
            deactivateMessage: result.message));
        return false;
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          deactivateStatus: RequestStatus.failed,
          deactivateMessage: e.toString()));
      return false;
    }
  }
}

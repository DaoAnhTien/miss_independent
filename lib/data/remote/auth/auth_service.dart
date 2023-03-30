import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/auth/request_models/create_profile_request.dart';
import 'package:miss_independent/data/remote/auth/request_models/login_request.dart';
import 'package:miss_independent/data/remote/auth/request_models/register_request.dart';
import 'package:miss_independent/data/remote/auth/request_models/update_profile_request.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/category.dart';
import '../../../models/user.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';
import 'response_models/auth_response.dart';

abstract class AuthService {
  Future<DataState<AuthResponse>> login(LoginRequest request);

  Future<DataState<AuthResponse>> register(RegisterRequest request);

  Future<DataState<String?>> resendVerifyCode(String email);

  Future<DataState<String?>> forgotPassword(String email);

  Future<DataState<AuthResponse>> verifyEmail(String email, String code);

  Future<DataState<List<Category>>> getCategories(String type);

  Future<DataState<AuthResponse>> createProfile(CreateProfileRequest request);

  Future<DataState<bool>> editProfile(UpdateProfileRequest request);

  Future<DataState<User>> getMyProfile();

  Future<DataState<String?>> changePassword(String currentPass, String newPass);
  Future<DataState<String?>> logout();
  Future<DataState<bool?>> deactivateAccount();
}

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<AuthResponse>> login(LoginRequest request) async {
    final FormData formData = FormData.fromMap(request.toJson());
    try {
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.login, data: formData);
      if (result.data != null &&
          result.data['id'] != null &&
          result.data['role_id'] == null) {
        return DataSuccess<AuthResponse>(
            AuthResponse.fromJson(result.data as Map<String, dynamic>)
                .copyWith(isNotCreatedProfile: false));
      }
      if (result.data != null && result.data['is_active'] != null) {
        return DataSuccess<AuthResponse>(
            AuthResponse.fromJson(result.data as Map<String, dynamic>)
                .copyWith(isInActive: false));
      }
      if (result.isSuccess()) {
        return DataSuccess<AuthResponse>(
            AuthResponse.fromJson(result.data as Map<String, dynamic>));
      } else {
        return DataFailed<AuthResponse>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<AuthResponse>(e.message);
    } on Exception catch (e) {
      return DataFailed<AuthResponse>(e.toString());
    }
  }

  @override
  Future<DataState<AuthResponse>> register(RegisterRequest request) {
    final ApiHelper<AuthResponse> helper = ApiHelper<AuthResponse>();
    final FormData formData = FormData.fromMap(request.toJson());
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.register, data: formData),
        parseItem: AuthResponse.fromJson);
  }

  @override
  Future<DataState<AuthResponse>> verifyEmail(String email, String code) {
    final ApiHelper<AuthResponse> helper = ApiHelper<AuthResponse>();
    final FormData formData =
        FormData.fromMap({'email': email, 'verfiy_code': code});
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.verifyEmail, data: formData),
        parseItem: AuthResponse.fromJson);
  }

  @override
  Future<DataState<AuthResponse>> createProfile(
      CreateProfileRequest request) async {
    final ApiHelper<AuthResponse> helper = ApiHelper<AuthResponse>();
    FormData formData;
    if (request.image != null) {
      formData = FormData.fromMap({
        ...request.toJson(),
        "image": await MultipartFile.fromFile(request.image!.path,
            filename: request.image!.name)
      });
    } else {
      formData = FormData.fromMap({...request.toJson()});
    }
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.createProfile, data: formData),
        parseItem: AuthResponse.fromJson);
  }

  @override
  Future<DataState<bool>> editProfile(UpdateProfileRequest request) async {
    try {
      FormData formData = FormData.fromMap(await request.toJson());
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.editProfile, data: formData);
      if (result.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }

  @override
  Future<DataState<User>> getMyProfile() async {
    try {
      final ApiResponse result =
          await _apiClient.get(path: ApiEndpoint.profile);
      if (result.isSuccess()) {
        if (result.data is Map<String, dynamic>) {
          return DataSuccess<User>(User.fromProfileJson(
              result.data["User"] as Map<String, dynamic>));
        } else {
          return DataSuccess<User>(result.data);
        }
      } else {
        return DataFailed<User>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<User>(e.message);
    } on Exception catch (e) {
      return DataFailed<User>(e.toString());
    }
  }

  @override
  Future<DataState<List<Category>>> getCategories(String type) {
    final ApiHelper<Category> helper = ApiHelper<Category>();
    return helper.getListWithoutMore(
        _apiClient.get(path: "${ApiEndpoint.categories}?for=$type"),
        Category.fromJson);
  }

  @override
  Future<DataState<String?>> resendVerifyCode(String email) {
    final ApiHelper<String?> helper = ApiHelper<String?>();
    final FormData formData = FormData.fromMap({'email': email});
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.resendVerifyCode, data: formData));
  }

  @override
  Future<DataState<String?>> forgotPassword(String email) {
    final ApiHelper<String?> helper = ApiHelper<String?>();
    final FormData formData = FormData.fromMap({'email': email});
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.forgotPassword, data: formData));
  }

  @override
  Future<DataState<String?>> changePassword(
      String currentPass, String newPass) {
    final ApiHelper<String?> helper = ApiHelper<String?>();
    final FormData formData = FormData.fromMap(
        {'temporary_password': currentPass, 'new_password': newPass});
    return helper.requestApi(
        _apiClient.post(path: ApiEndpoint.changePassword, data: formData));
  }

  @override
  Future<DataState<String?>> logout() {
    final ApiHelper<String?> helper = ApiHelper<String?>();
    return helper.requestApi(_apiClient.post(path: ApiEndpoint.logout));
  }

  @override
  Future<DataState<bool?>> deactivateAccount() async {
    try {
      final ApiResponse result =
          await _apiClient.get(path: ApiEndpoint.deactivateAccount);
      if (result.isSuccess()) {
        return const DataSuccess<bool>(true);
      } else {
        return DataFailed<bool>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<bool>(e.message);
    } on Exception catch (e) {
      return DataFailed<bool>(e.toString());
    }
  }
}

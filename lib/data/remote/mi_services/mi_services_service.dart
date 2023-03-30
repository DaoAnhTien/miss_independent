import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/user.dart';
import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';
import '../helper/index.dart';

abstract class MIServicesService {
  Future<DataState<Pagination<User>>> getServices(
      int page, ServiceProviderType type);
  Future<DataState<Pagination<User>>> searchServices(
      String? text,
      String? location,
      String? categoryName,
      int page,
      ServiceProviderType type);
}

@LazySingleton(as: MIServicesService)
class MIServicesServiceImpl implements MIServicesService {
  MIServicesServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<User>>> getServices(
      int page, ServiceProviderType type) async {
    final ApiHelper<User> helper = ApiHelper<User>();
    return helper.getDataWithMore(
        _apiClient.get(
          path: "${ApiEndpoint.getSevices}/${type.rawValue}/providers",
          queryParameters: {'page': page},
        ),
        User.fromProfileJson);
  }

  @override
  Future<DataState<Pagination<User>>> searchServices(
      String? text,
      String? location,
      String? categoryName,
      int page,
      ServiceProviderType type) async {
    try {
      final ApiResponse result = await _apiClient.post(
        path: ApiEndpoint.searchUser,
        data: {
          'text': text,
          'location': location,
          'category_name': categoryName,
        },
      );
      if (result.isSuccess() && result.data is List) {
        const bool hasNextPage = false;
        return DataSuccess<Pagination<User>>(
          Pagination(
              data: (result.data as List<dynamic>)
                  .map<User>((dynamic e) =>
                      User.fromProfileJson(e as Map<String, dynamic>))
                  .toList(),
              isEnd: !hasNextPage),
        );
      } else {
        return DataFailed<Pagination<User>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<User>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<User>>(e.toString());
    }
  }
}

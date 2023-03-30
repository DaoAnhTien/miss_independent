import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/user.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';

abstract class MemberService {
  Future<DataState<Pagination<User>>> getMemberLatest(int page);
  Future<DataState<Pagination<User>>> getMemberOnline(int page);
  Future<DataState<Pagination<User>>> getMemberShip(
      int page, String memberType);
}

@LazySingleton(as: MemberService)
class MemberServiceImpl implements MemberService {
  MemberServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<User>>> getMemberLatest(int page) async {
    try {
      final ApiResponse result = await _apiClient.get(
          path: "${ApiEndpoint.getLatestMembers}/?page=$page");
      if (result.message?.isEmpty ?? true) {
        final bool hasNextPage = result.data["next_page_url"] != null;
        return DataSuccess<Pagination<User>>(
          Pagination(
              data: (result.data['data'] as List<dynamic>)
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

  @override
  Future<DataState<Pagination<User>>> getMemberOnline(int page) async {
    try {
      final ApiResponse result = await _apiClient.get(
          path: "${ApiEndpoint.getOnlineMembers}/?page=$page");
      if (result.message?.isEmpty ?? true) {
        final bool hasNextPage = result.data["next_page_url"] != null;
        return DataSuccess<Pagination<User>>(
          Pagination(
              data: (result.data['data'] as List<dynamic>)
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

  @override
  Future<DataState<Pagination<User>>> getMemberShip(
      int page, String memberType) async {
    try {
      final FormData formData =
          FormData.fromMap({"page": page, "role_id": memberType});
      final ApiResponse result = await _apiClient.post(
          path: ApiEndpoint.getRolewiseMember, data: formData);
      if (result.message?.isEmpty ?? true) {
        final bool hasNextPage = result.data["next_page_url"] != null;
        return DataSuccess<Pagination<User>>(
          Pagination(
              data: (result.data['data'] as List<dynamic>)
                  .map<User>((dynamic e) =>
                      User.fromProfileJson(e as Map<String, dynamic>))
                  .toList(),
              isEnd: !hasNextPage),
        );
      } else {
        if (result.message == "No member found") {
          return DataSuccess<Pagination<User>>(
            Pagination(data: [], isEnd: true),
          );
        } else {
          return DataFailed<Pagination<User>>(result.message ?? '');
        }
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<User>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<User>>(e.toString());
    }
  }
}

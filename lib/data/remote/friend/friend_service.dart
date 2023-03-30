import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/friend.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';

abstract class FriendService {
  Future<DataState<Pagination<Friend>>> getFriends(int page);
}

@LazySingleton(as: FriendService)
class FriendServiceImpl implements FriendService {
  FriendServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<Friend>>> getFriends(int page) async {
    try {
      final FormData formData = FormData.fromMap({"page": page});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.getFriends, data: formData);
      if (result.isSuccess()) {
        final bool hasNextPage =
            result.data['Friends']['next_page_url'] != null;
        return DataSuccess<Pagination<Friend>>(
          Pagination(
              data: (result.data['Friends']['data'] as List<dynamic>)
                  .map<Friend>(
                      (dynamic e) => Friend.fromJson(e as Map<String, dynamic>))
                  .toList(),
              isEnd: !hasNextPage),
        );
      } else {
        return DataFailed<Pagination<Friend>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<Friend>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<Friend>>(e.toString());
    }
  }
}

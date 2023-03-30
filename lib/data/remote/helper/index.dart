import 'package:dio/dio.dart';

import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';

class ApiHelper<T> {
  Future<DataState<Pagination<T>>> getDataWithMore(Future<ApiResponse> request,
      T Function(Map<String?, dynamic>) parseItem) async {
    try {
      final ApiResponse result = await request;
      if (result.isSuccess() && result.data is Map) {
        final bool hasNextPage = result.data['next_page_url'] != null;
        return DataSuccess<Pagination<T>>(
          Pagination(
              data: (result.data['data'] as List<dynamic>)
                  .map<T>((dynamic e) => parseItem(e as Map<String, dynamic>))
                  .toList(),
              isEnd: !hasNextPage),
        );
      } else {
        return DataFailed<Pagination<T>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<T>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<T>>(e.toString());
    }
  }

  Future<DataState<List<T>>> getListWithoutMore(Future<ApiResponse> request,
      T Function(Map<String?, dynamic>) parseItem) async {
    try {
      final ApiResponse result = await request;
      if (result.isSuccess()) {
        return DataSuccess<List<T>>((result.data as List<dynamic>)
            .map<T>((dynamic e) => parseItem(e as Map<String, dynamic>))
            .toList());
      } else {
        return DataFailed<List<T>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<T>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<T>>(e.toString());
    }
  }

  Future<DataState<T>> requestApi(Future<ApiResponse> request,
      {T Function(Map<String?, dynamic>)? parseItem}) async {
    try {
      final ApiResponse result = await request;
      if (result.isSuccess()) {
        if (result.data is Map<String, dynamic> && parseItem != null) {
          return DataSuccess<T>(parseItem(result.data as Map<String, dynamic>));
        } else {
          return DataSuccess<T>(result.data);
        }
      } else {
        return DataFailed<T>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<T>(e.message);
    } on Exception catch (e) {
      return DataFailed<T>(e.toString());
    }
  }
}

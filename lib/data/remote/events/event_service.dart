import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/event.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';

abstract class EventService {
  Future<DataState<Pagination<Event>>> getEvent(String title, String date);

  Future<DataState<Event>> getEventDetail(int eventId, int userId);
  Future<DataState<bool>> eventFav(int eventId, int userId);
  Future<DataState<bool>> eventUnFav(int eventId, int userId);
}

@LazySingleton(as: EventService)
class EventServiceImpl implements EventService {
  EventServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<Event>>> getEvent(
      String title, String date) async {
    try {
      final FormData formData =
          FormData.fromMap({"title": title, "date": date});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.eventSearch, data: formData);
      if (result.isSuccess()) {
        final bool hasNextPage = result.data != null;
        return DataSuccess<Pagination<Event>>(Pagination(
            data: (result.data as List<dynamic>)
                .map<Event>(
                    (dynamic e) => Event.fromJson(e as Map<String, dynamic>))
                .toList(),
            isEnd: !hasNextPage));
      } else {
        return DataFailed<Pagination<Event>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<Event>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<Event>>(e.toString());
    }
  }

  @override
  Future<DataState<Event>> getEventDetail(int eventId, int userId) async {
    try {
      final FormData formData =
          FormData.fromMap({"eventId": eventId, "user_id": userId});
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.eventDetail, data: formData);
      if (result.isSuccess() &&
          result.data is Map<String, dynamic> &&
          result.data["event"] != null &&
          result.data["event"] is Map<String, dynamic>) {
        Event data = Event.fromJson(result.data["event"])
            .copyWith(favBit: result.data["fav_bit"] == 1);
        return DataSuccess<Event>(data);
      } else {
        return DataFailed<Event>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Event>(e.message);
    } on Exception catch (e) {
      return DataFailed<Event>(e.toString());
    }
  }

  @override
  Future<DataState<bool>> eventFav(int eventId, int userId) async {
    final FormData formData =
        FormData.fromMap({'event_id': eventId, 'user_id': userId});
    try {
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.eventFav, data: formData);
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
  Future<DataState<bool>> eventUnFav(int eventId, int userId) async {
    final FormData formData =
        FormData.fromMap({'event_id': eventId, 'user_id': userId});
    try {
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.eventUnFav, data: formData);
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

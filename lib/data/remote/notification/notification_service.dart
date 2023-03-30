import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/notification.dart';
import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../api_endpoint.dart';

abstract class NotificationService {
  Future<DataState<List<Notification>>> getNotification();
}

@LazySingleton(as: NotificationService)
class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl(this._apiClient);
  final ApiClient _apiClient;
  @override
  Future<DataState<List<Notification>>> getNotification() async{
    try {
      final ApiResponse result =
      await _apiClient.get(path: ApiEndpoint.getNotification);
      if (result.message?.isEmpty ?? true) {
        return DataSuccess<List<Notification>>(
            (result.data as List<dynamic>)
                .map<Notification>((dynamic e) =>  Notification.fromJson(e as Map<String, dynamic>))
                .toList());
      } else {
        return DataFailed<List<Notification>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<Notification>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<Notification>>(e.toString());
    }

  }
}

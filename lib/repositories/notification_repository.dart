import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/api_client/data_state.dart';
import 'package:miss_independent/data/remote/notification/notification_service.dart';
import 'package:miss_independent/models/notification.dart';

abstract class NotificationRepository {
  Future<DataState<List<Notification>>> getNotification();
}

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepositoryImpl({required NotificationService notificationService})
      : _notificationService = notificationService;

  @override
  Future<DataState<List<Notification>>> getNotification() {
    return _notificationService.getNotification();
  }
}

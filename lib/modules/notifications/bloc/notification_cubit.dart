import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/notifications_local_datasource.dart';
import 'package:miss_independent/models/notification.dart';
import 'package:miss_independent/repositories/notification_repository.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import 'notification_state.dart';

@Injectable()
class NotificationCubit extends Cubit<NotificationState> {
  late final NotificationRepository _notificationRepository;
  late final NotificationsLocalDatasource _notificationsLocalDatasource;

  NotificationCubit({required NotificationRepository notificationRepository,required NotificationsLocalDatasource notificationsLocalDatasource})
      : super(const NotificationState()) {
    _notificationRepository = notificationRepository;
    _notificationsLocalDatasource= notificationsLocalDatasource;
    _initData();
  }
  void _initData() {
    var items = _notificationsLocalDatasource.getNotifications();
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        notifications: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  Future<void> fetchItems() async {
    try {
      final DataState<List<Notification>> res =
          await _notificationRepository.getNotification();
      emit(state.copyWith(
        notifications: res.data,
        status: (res.data?.isEmpty ?? true)
            ? DataSourceStatus.empty
            : DataSourceStatus.success,
      ));
      _notificationsLocalDatasource.saveNotifications(res.data);
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/notification.dart';
import '../../../models/pagination.dart';

class NotificationState extends Equatable {
  const NotificationState(
      {this.notifications,
      this.status = DataSourceStatus.initial,
      this.message});

  final List<Notification>? notifications;
  final DataSourceStatus status;
  final String? message;

  NotificationState copyWith(
      {List<Notification>? notifications,
      DataSourceStatus? status,
      String? message}) {
    return NotificationState(
        notifications: notifications ?? this.notifications,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[ notifications, status, message];
}

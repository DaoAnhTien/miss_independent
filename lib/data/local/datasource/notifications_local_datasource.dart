import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/notification.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class NotificationsLocalDatasource {
  List<Notification>? getNotifications();
  Future<void> saveNotifications(List<Notification>? items);
}

@LazySingleton(as: NotificationsLocalDatasource)
class NotificationsLocalDatasourceImpl implements NotificationsLocalDatasource {
  NotificationsLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Notification>? getNotifications() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.notifications);
    if (data == null) {
      return null;
    }
    return List<Notification>.from(
      (jsonDecode(data) as List<dynamic>).map<Notification>(
        (dynamic x) => Notification.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveNotifications(List<Notification>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.notifications, jsonEncode(items));
    }
  }
}

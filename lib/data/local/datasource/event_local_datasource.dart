import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/event.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class EventLocalDatasource {
  List<Event>? getEvents();
  Future<void> saveEvents(List<Event>? items);
}

@LazySingleton(as: EventLocalDatasource)
class EventLocalDatasourceImpl implements EventLocalDatasource {
  EventLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Event>? getEvents() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.events);
    if (data == null) {
      return null;
    }
    return List<Event>.from(
      (jsonDecode(data) as List<dynamic>).map<Event>(
        (dynamic x) => Event.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveEvents(List<Event>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.events, jsonEncode(items));
    }
  }
}

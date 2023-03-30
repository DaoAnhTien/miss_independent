import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../models/forum.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class ForumLocalDatasource {
  List<Forum>? getForums();
  Future<void> saveForums(List<Forum>? items);
}

@LazySingleton(as: ForumLocalDatasource)
class ForumLocalDatasourceImpl implements ForumLocalDatasource {
  ForumLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Forum>? getForums() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.forums);
    if (data == null) {
      return null;
    }
    return List<Forum>.from(
      (jsonDecode(data) as List<dynamic>).map<Forum>(
        (dynamic x) => Forum.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveForums(List<Forum>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.forums, jsonEncode(items));
    }
  }
}

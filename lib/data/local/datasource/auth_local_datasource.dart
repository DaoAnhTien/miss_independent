import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../models/user.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class AuthLocalDatasource {
  User? getLoggedInUser();
  Future<void> saveLoggedInUser(User? user);

  String? getLoggedInToken();
  Future<void> saveLoggedInToken(String? token);
}

@LazySingleton(as: AuthLocalDatasource)
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  AuthLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  String? getLoggedInToken() {
    return _sharedPrefs.get(SharedPrefsKey.token);
  }

  @override
  User? getLoggedInUser() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.userInfo);
    if (data == null) {
      return null;
    }
    return User.fromLocal(jsonDecode(data));
  }

  @override
  Future<void> saveLoggedInToken(String? token) {
    return _sharedPrefs.put(SharedPrefsKey.token, token);
  }

  @override
  Future<void> saveLoggedInUser(User? user) {
    return _sharedPrefs.put(
        SharedPrefsKey.userInfo, user != null ? jsonEncode(user) : null);
  }
}

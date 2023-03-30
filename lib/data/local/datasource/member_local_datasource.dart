import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/modules/members/widgets/members_tab.dart';
import '../../../models/user.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class MembersLocalDataSource {
  List<User>? getMembers(String type);
  Future<void> saveMembers(List<User>? items, String type);
}

@LazySingleton(as: MembersLocalDataSource)
class MembersLocalDataSourceImpl implements MembersLocalDataSource {
  MembersLocalDataSourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<User>? getMembers(String type) {
    final String key = type == MembersTab.latest.rawValue
        ? SharedPrefsKey.latestMembers
        : type == MembersTab.online.rawValue
            ? SharedPrefsKey.onlineMembers
            : SharedPrefsKey.membershipMembers;
    final String? data = _sharedPrefs.get(key);
    if (data == null) {
      return null;
    }
    return List<User>.from(
      (jsonDecode(data) as List<dynamic>).map<User>(
        (dynamic x) => User.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveMembers(List<User>? items, String type) async {
    final String key = type == MembersTab.latest.rawValue
        ? SharedPrefsKey.latestMembers
        : type == MembersTab.online.rawValue
            ? SharedPrefsKey.onlineMembers
            : SharedPrefsKey.membershipMembers;
    if (items != null) {
      await _sharedPrefs.put(key, jsonEncode(items));
    }
  }
}

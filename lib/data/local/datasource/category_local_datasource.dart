import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../models/category.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class CategoryLocalDatasource {
  List<Category>? getGeneralCategories();
  Future<void> saveGeneralCategories(List<Category>? items);
}

@LazySingleton(as: CategoryLocalDatasource)
class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  CategoryLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Category>? getGeneralCategories() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.generalCategories);
    if (data == null) {
      return null;
    }
    return List<Category>.from(
      (jsonDecode(data) as List<dynamic>).map<Category>(
        (dynamic x) => Category.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveGeneralCategories(List<Category>? items) async {
    if (items != null) {
      await _sharedPrefs.put(
          SharedPrefsKey.generalCategories, jsonEncode(items));
    }
  }
}

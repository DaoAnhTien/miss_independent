import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/product.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class ProductLocalDatasource {
  List<Product>? getMyProducts();
  Future<void> saveProducts(List<Product>? items);
}

@LazySingleton(as: ProductLocalDatasource)
class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  ProductLocalDatasourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Product>? getMyProducts() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.products);
    if (data == null) {
      return null;
    }
    return List<Product>.from(
      (jsonDecode(data) as List<dynamic>).map<Product>(
        (dynamic x) => Product.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveProducts(List<Product>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.products, jsonEncode(items));
    }
  }
}

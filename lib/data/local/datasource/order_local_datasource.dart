import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/order/request_model/checkout_request.dart';
import 'package:miss_independent/models/order.dart';

import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class OrderLocalDataSource {
  List<OrderModel>? getOrderHistory();
  Future<void> saveOrderHistory(List<OrderModel>? items);
  List<OrderModel>? getOrderManagement();
  Future<void> saveOrderManagement(List<OrderModel>? items);
  Future<void> saveCheckoutRequest(CheckoutRequest? item);
  CheckoutRequest? getCheckoutRequest();
}

@LazySingleton(as: OrderLocalDataSource)
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  OrderLocalDataSourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<OrderModel>? getOrderHistory() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.orderHistory);
    if (data == null) {
      return null;
    }
    return List<OrderModel>.from(
      (jsonDecode(data) as List<dynamic>).map<OrderModel>(
        (dynamic x) => OrderModel.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveOrderHistory(List<OrderModel>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.orderHistory, jsonEncode(items));
    }
  }
  @override
  List<OrderModel>? getOrderManagement() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.orderManagement);
    if (data == null) {
      return null;
    }
    return List<OrderModel>.from(
      (jsonDecode(data) as List<dynamic>).map<OrderModel>(
        (dynamic x) => OrderModel.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveOrderManagement(List<OrderModel>? items) async {
    if (items != null) {
      await _sharedPrefs.put(SharedPrefsKey.orderManagement, jsonEncode(items));
    }
  }

  @override
  CheckoutRequest? getCheckoutRequest() {
    final String? data = _sharedPrefs.get(SharedPrefsKey.checkoutRequest);
    if (data == null) {
      return null;
    }
    return CheckoutRequest.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<void> saveCheckoutRequest(CheckoutRequest? item) async {
    if (item != null) {
      await _sharedPrefs.put(SharedPrefsKey.checkoutRequest, jsonEncode(item));
    }
  }
}

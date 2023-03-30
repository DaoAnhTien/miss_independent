import 'package:injectable/injectable.dart';

import '../common/api_client/data_state.dart';
import '../data/remote/order/order_service.dart';
import '../data/remote/order/request_model/checkout_request.dart';
import '../models/order.dart';
import '../models/pagination.dart';

abstract class OrderRepository {
  Future<DataState<dynamic>> placeOrder(CheckoutRequest checkoutRequest);
  Future<DataState<Pagination<OrderModel>>> getShopOrders(int page);
  Future<DataState<Pagination<OrderModel>>> getOrderHistory(int page);
}

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderService _orderService;

  OrderRepositoryImpl({required OrderService orderService})
      : _orderService = orderService;

  @override
  Future<DataState> placeOrder(CheckoutRequest checkoutRequest) {
    return _orderService.placeOrder(checkoutRequest);
  }

  @override
  Future<DataState<Pagination<OrderModel>>> getOrderHistory(int page) {
    return _orderService.getOrderHistory(page);
  }

  @override
  Future<DataState<Pagination<OrderModel>>> getShopOrders(int page) {
    return _orderService.getShopOrders(page);
  }
}

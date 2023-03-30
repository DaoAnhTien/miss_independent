import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/helper/index.dart';
import 'package:miss_independent/data/remote/order/request_model/checkout_request.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/order.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../api_endpoint.dart';

abstract class OrderService {
  Future<DataState<dynamic>> placeOrder(CheckoutRequest checkoutRequest);
  Future<DataState<Pagination<OrderModel>>> getOrderHistory(int page);
  Future<DataState<Pagination<OrderModel>>> getShopOrders(int page);
}

@LazySingleton(as: OrderService)
class OrderServiceImpl implements OrderService {
  OrderServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<dynamic>> placeOrder(CheckoutRequest checkoutRequest) async {
    try {
      FormData formData = FormData.fromMap(checkoutRequest.toJson());
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.placeOrder, data: formData);
      if (result.data is Map && result.data['id'] != null) {
        return DataSuccess(result.data);
      } else {
        return DataFailed(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed(e.message);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<Pagination<OrderModel>>> getOrderHistory(int page) {
    final ApiHelper<OrderModel> helper = ApiHelper<OrderModel>();
    return helper.getDataWithMore(
        _apiClient
            .get(path: ApiEndpoint.orders, queryParameters: {'page': page}),
        OrderModel.fromJson);
  }

  @override
  Future<DataState<Pagination<OrderModel>>> getShopOrders(int page) {
    final ApiHelper<OrderModel> helper = ApiHelper<OrderModel>();
    return helper.getDataWithMore(
        _apiClient
            .get(path: ApiEndpoint.shopOrders, queryParameters: {'page': page}),
        OrderModel.fromJson);
  }
}

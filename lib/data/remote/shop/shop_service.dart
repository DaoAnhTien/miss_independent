import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/helper/index.dart';
import 'package:miss_independent/models/product.dart';

import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/cart.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';

abstract class ShopService {
  Future<DataState<Pagination<Product>>> getProducts(int page, int? categoryId);
  Future<DataState<Product>> getProductDetail(int productId);
  Future<DataState<dynamic>> addToCart(int productId, int quantity);
  Future<DataState<dynamic>> editQuantity(int productId, int quantity);
  Future<DataState<dynamic>> deleteCart(int productId);
  Future<DataState<List<Cart>>> showCart();
}

@LazySingleton(as: ShopService)
class ShopServiceImpl implements ShopService {
  ShopServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<Product>>> getProducts(
      int page, int? categoryId) async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: ApiEndpoint.products,
        queryParameters: {'page': page, 'category_id': categoryId},
      );
      if (result.message?.isEmpty ?? true) {
        final bool hasNextPage = result.data['next_page_url'] != null;
        return DataSuccess<Pagination<Product>>(
          Pagination(
              data: (result.data['data'] as List<dynamic>)
                  .map<Product>((dynamic e) =>
                      Product.fromJson(e as Map<String, dynamic>))
                  .toList(),
              isEnd: !hasNextPage),
        );
      } else {
        return DataFailed<Pagination<Product>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Pagination<Product>>(e.message);
    } on Exception catch (e) {
      return DataFailed<Pagination<Product>>(e.toString());
    }
  }

  @override
  Future<DataState<Product>> getProductDetail(int productId) async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: "${ApiEndpoint.products}/$productId",
      );
      if (result.message?.isEmpty ?? true && result.data is Map) {
        return DataSuccess<Product>(Product.fromJson(result.data));
      } else {
        return DataFailed<Product>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<Product>(e.message);
    } on Exception catch (e) {
      return DataFailed<Product>(e.toString());
    }
  }

  @override
  Future<DataState<List<Cart>>> showCart() async {
    try {
      final ApiResponse result = await _apiClient.get(
        path: ApiEndpoint.carts,
      );
      if (result.message?.isEmpty ?? true) {
        return DataSuccess<List<Cart>>((result.data as List<dynamic>)
            .map<Cart>((dynamic e) => Cart.fromJson(e as Map<String, dynamic>))
            .toList());
      } else {
        return DataFailed<List<Cart>>(result.message ?? '');
      }
    } on DioError catch (e) {
      return DataFailed<List<Cart>>(e.message);
    } on Exception catch (e) {
      return DataFailed<List<Cart>>(e.toString());
    }
  }

  @override
  Future<DataState<dynamic>> addToCart(int productId, int quantity) async {
    try {
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.carts, data: {
        'product_id': productId,
        'quantity': quantity,
      });
      if (result.message?.isEmpty ?? true && result.data is Map) {
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
  Future<DataState> editQuantity(int productId, int quantity) async {
    final ApiHelper helper = ApiHelper();
    return helper.requestApi(
        _apiClient.post(path: "${ApiEndpoint.carts}/$productId", data: {
      'quantity': quantity,
    }));
  }

  @override
  Future<DataState> deleteCart(int productId) {
    final ApiHelper helper = ApiHelper();
    return helper
        .requestApi(_apiClient.delete(path: "${ApiEndpoint.carts}/$productId"));
  }
}

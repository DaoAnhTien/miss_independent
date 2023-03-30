import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/models/product.dart';
import '../../../common/api_client/api_client.dart';
import '../../../common/api_client/api_response.dart';
import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../api_endpoint.dart';
import 'request_models/update_product_request.dart';

abstract class ProductService {
  Future<DataState<Pagination<Product>>> getMyProducts(int page);

  Future<DataState<Product>> createProduct(
      UpdateProductRequest updateProductRequest);

  Future<DataState<dynamic>> deleteProduct(int id);

  Future<DataState<Product>> updateProduct(
      int productId, UpdateProductRequest updateProductRequest);
}

@LazySingleton(as: ProductService)
class ProductServiceImpl implements ProductService {
  ProductServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DataState<Pagination<Product>>> getMyProducts(int page) async {
    try {
      final ApiResponse result =
          await _apiClient.get(path: "${ApiEndpoint.getMyProducts}?page=$page");
      if (result.message?.isEmpty ?? true) {
        final bool hasNextPage = result.data["next_page_url"] != null;
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
  Future<DataState<Product>> createProduct(
      UpdateProductRequest updateProductRequest) async {
    try {
      final FormData formData =
          FormData.fromMap(await updateProductRequest.toJson());
      final ApiResponse result =
          await _apiClient.post(path: ApiEndpoint.products, data: formData);
      if (result.isSuccess() && result.data != null) {
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
  Future<DataState<dynamic>> deleteProduct(int id) async {
    try {
      final ApiResponse result =
          await _apiClient.delete(path: "${ApiEndpoint.products}/$id");
      if (result.message?.isEmpty == true) {
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
  Future<DataState<Product>> updateProduct(
      int productId, UpdateProductRequest updateProductRequest) async {
    try {
      final FormData formData =
          FormData.fromMap(await updateProductRequest.toJson());
      final ApiResponse result = await _apiClient.post(
          path: "${ApiEndpoint.products}/$productId", data: formData);
      if (result.message?.isEmpty ?? true && result.data != null) {
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
}

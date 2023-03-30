import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/api_client/data_state.dart';
import 'package:miss_independent/data/remote/product/product_service.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/product.dart';

import '../data/remote/product/request_models/update_product_request.dart';

abstract class ProductRepository {
  Future<DataState<Pagination<Product>>> getMyProducts(int page);

  Future<DataState<Product>> createProduct(
      UpdateProductRequest updateProductRequest);
  Future<DataState<dynamic>> deleteProduct(int id);

  Future<DataState<Product>> updateProduct(
      int productId, UpdateProductRequest updateProductRequest);
}

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;

  ProductRepositoryImpl({required ProductService productService})
      : _productService = productService;

  @override
  Future<DataState<Pagination<Product>>> getMyProducts(int page) {
    return _productService.getMyProducts(page);
  }

  @override
  Future<DataState<Product>> createProduct(
      UpdateProductRequest updateProductRequest) {
    return _productService.createProduct(updateProductRequest);
  }

  @override
  Future<DataState<Product>> updateProduct(
      int productId, UpdateProductRequest updateProductRequest) {
    return _productService.updateProduct(productId, updateProductRequest);
  }

  @override
  Future<DataState<dynamic>> deleteProduct(int id) {
    return _productService.deleteProduct(id);
  }
}

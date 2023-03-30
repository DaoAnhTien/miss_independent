import 'package:injectable/injectable.dart';

import '../common/api_client/data_state.dart';
import '../data/remote/shop/shop_service.dart';
import '../models/cart.dart';
import '../models/pagination.dart';
import '../models/product.dart';

abstract class ShopRepository {
  Future<DataState<Pagination<Product>>> getProducts(int page, int? categoryId);
  Future<DataState<Product>> getProductDetail(int productId);
  Future<DataState<dynamic>> addToCart(int productId, int quantity);
  Future<DataState<dynamic>> editQuantity(int productId, int quantity);
  Future<DataState<dynamic>> deleteCart(int productId);
  Future<DataState<List<Cart>>> showCart();
}

@LazySingleton(as: ShopRepository)
class ShopRepositoryImpl implements ShopRepository {
  final ShopService _shopService;

  ShopRepositoryImpl({required ShopService shopService})
      : _shopService = shopService;

  @override
  Future<DataState<Pagination<Product>>> getProducts(
      int page, int? categoryId) {
    return _shopService.getProducts(page, categoryId);
  }

  @override
  Future<DataState<Product>> getProductDetail(int productId) {
    return _shopService.getProductDetail(productId);
  }

  @override
  Future<DataState<List<Cart>>> showCart() {
    return _shopService.showCart();
  }

  @override
  Future<DataState> addToCart(int productId, int quantity) {
    return _shopService.addToCart(productId, quantity);
  }

  @override
  Future<DataState> deleteCart(int productId) {
    return _shopService.deleteCart(productId);
  }

  @override
  Future<DataState> editQuantity(int productId, int quantity) {
    return _shopService.editQuantity(productId, quantity);
  }
}

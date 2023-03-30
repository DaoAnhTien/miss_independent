import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/product.dart';

import '../../../models/pagination.dart';

class ShopState extends Equatable {
  const ShopState(
      {this.products,
      this.categoryId,
      this.status = DataSourceStatus.initial,
      this.addToCartStatus = RequestStatus.initial,
      this.message});

  final List<Product>? products;
  final DataSourceStatus status;
  final RequestStatus addToCartStatus;
  final int? categoryId;
  final String? message;

  ShopState copyWith(
      {List<Product>? products,
      int? categoryId,
      DataSourceStatus? status,
      RequestStatus? addToCartStatus,
      String? message}) {
    return ShopState(
        products: products ?? this.products,
        categoryId: categoryId ?? this.categoryId,
        status: status ?? this.status,
        addToCartStatus: addToCartStatus ?? this.addToCartStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[products, categoryId, status, addToCartStatus, message];
}

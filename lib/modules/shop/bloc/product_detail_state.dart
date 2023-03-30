import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/product.dart';

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.product,
      this.status = RequestStatus.initial,
      this.addToCartStatus = RequestStatus.initial,
      this.buyNowStatus = RequestStatus.initial,
      this.message});

  final Product? product;
  final RequestStatus status;
  final RequestStatus addToCartStatus;
  final RequestStatus buyNowStatus;
  final String? message;

  ProductDetailState copyWith(
      {Product? product,
      RequestStatus? status,
      RequestStatus? addToCartStatus,
      RequestStatus? buyNowStatus,
      String? message}) {
    return ProductDetailState(
        product: product ?? this.product,
        status: status ?? this.status,
        addToCartStatus: addToCartStatus ?? this.addToCartStatus,
        buyNowStatus: buyNowStatus ?? this.buyNowStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[product, status, addToCartStatus, buyNowStatus, message];
}

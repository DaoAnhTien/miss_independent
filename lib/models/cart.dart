import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/utils/utils.dart';
import 'package:miss_independent/models/product.dart';

class Cart extends Equatable {
  const Cart({
    this.id,
    this.userId,
    this.shopId,
    this.quantity,
    this.product,
  });
  final int? id;
  final int? userId;
  final int? shopId;
  final int? quantity;
  final Product? product;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      id: json['id'],
      userId: json['user_id'],
      shopId: json['shop_id'],
      quantity: parseInt(json['quantity'] ?? 1),
      product: json['shop'] != null && json['shop'] is Map
          ? Product.fromJson(json['shop'] as Map<String, dynamic>)
          : null);
  Cart copyWith({
    int? id,
    int? userId,
    int? shopId,
    int? quantity,
    Product? product,
  }) {
    return Cart(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        quantity: quantity ?? this.quantity,
        userId: userId ?? this.userId,
        product: product ?? this.product);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'shop_id': shopId,
        'quantity': quantity,
        'shop': product?.toJson()
      };

  @override
  List<Object?> get props => [id, userId, shopId, quantity, product];
}

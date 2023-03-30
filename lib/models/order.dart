import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/utils/utils.dart';
import 'package:miss_independent/models/product.dart';

class OrderModel extends Equatable {
  const OrderModel({
    this.id,
    this.userId,
    this.totalPrice,
    this.totalWeight,
    this.quantity,
    this.isCod,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.details,
  });
  final int? id;
  final int? userId;
  final double? totalPrice;
  final double? totalWeight;
  final int? quantity;
  final bool? isCod;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderDetail>? details;

  factory OrderModel.fromJson(Map<String?, dynamic> json) => OrderModel(
      id: parseInt(json['id']) ,
      userId: parseInt(json['user_id']),
      totalPrice: parseDouble(json['total_price']),
      totalWeight: parseDouble(json['total_weight']),
      quantity: parseInt(json['quantity']),
      isCod: json['is_cod'] == 1,
      status: json['status'],
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
      details: (json['details'] as List?)
          ?.map((dynamic e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList());
  OrderModel copyWith({
    int? id,
    int? userId,
    double? totalPrice,
    double? totalWeight,
    int? quantity,
    bool? isCod,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderDetail>? details,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalPrice: totalPrice ?? this.totalPrice,
      totalWeight: totalWeight ?? this.totalWeight,
      quantity: quantity ?? this.quantity,
      isCod: isCod ?? this.isCod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'total_price': totalPrice,
        'total_weight': totalWeight,
        'quantity': quantity,
        'is_cod': isCod == true ? 1 : 0,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'details': details?.map((e) => e.toJson()).toList()
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        totalPrice,
        totalWeight,
        quantity,
        isCod,
        status,
        createdAt,
        updatedAt,
        details
      ];
}

class OrderDetail extends Equatable {
  const OrderDetail({
    this.id,
    this.userId,
    this.productId,
    this.orderId,
    this.quantity,
    this.price,
    this.weight,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.product,
  });
  final int? id;
  final int? userId;
  final int? productId;
  final int? orderId;
  final int? quantity;
  final double? price;
  final double? weight;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? zipCode;
  final Product? product;

  factory OrderDetail.fromJson(Map<String?, dynamic> json) => OrderDetail(
      id: json['id'],
      userId: json['user_id'],
      productId: json['shop_id'],
      orderId: json['order_id'],
      quantity: json['quantity'],
      price: parseDouble(json['price']),
      weight: parseDouble(json['weight']),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
      address: json['address'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      zipCode: json['zip_code'],
      product: (json['shop'] as Map<String, dynamic>?) != null
          ? Product.fromJson(json['shop'] as Map<String, dynamic>)
          : null);
  OrderDetail copyWith(
    int? id,
    int? userId,
    int? productId,
    int? orderId,
    int? quantity,
    double? price,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? address,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    Product? product,
  ) {
    return OrderDetail(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      country: country ?? this.country,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'shop_id': productId,
        'order_id': orderId,
        'quantity': quantity,
        'price': price,
        'weight': weight,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'address': address,
        'country': country,
        'state': state,
        'city': city,
        'zip_code': zipCode,
        'shop': product?.toJson()
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        orderId,
        quantity,
        price,
        weight,
        createdAt,
        updatedAt,
        address,
        country,
        state,
        city,
        zipCode,
        product
      ];
}

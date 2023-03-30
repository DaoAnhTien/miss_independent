import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/utils/utils.dart';
import 'package:miss_independent/models/user.dart';

import 'category.dart';

class Product extends Equatable {
  const Product({
    this.id,
    this.name,
    this.sku,
    this.weight,
    this.price,
    this.image,
    this.description,
    this.userId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.quantity,
    this.user,
    this.category,
  });
  final int? id;
  final String? name;
  final String? sku;
  final int? weight;
  final double? price;
  final String? image;
  final String? description;
  final int? userId;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final int? quantity;
  final User? user;
  final Category? category;

  factory Product.fromJson(Map<String?, dynamic> json) => Product(
        id: parseInt(json['id']),
        name: json['name'],
        sku: json['sku'],
        weight: parseInt(json['weight']),
        price: parseDouble(json['price']),
        image: json['image'],
        description: json['description'],
        userId: parseInt(json['user_id']),
        categoryId: parseInt(json['category_id']),
        createdAt: parseDateTime(json['created_at']),
        updatedAt: parseDateTime(json['updated_at']),
        isActive: json['is_active'] == 1,
        quantity: parseInt(json['quantity']),
        user: json['user'] != null && json['user'] is Map
            ? User.fromProfileJson(json['user'])
            : null,
        category: json['category'] != null && json['category'] is Map
            ? Category.fromJson(json['category'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'weight': weight,
        'price': price,
        'image': image,
        'description': description,
        'user_id': userId,
        'category_id': categoryId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'is_active': isActive,
        'quantity': quantity,
        'user': user?.toJson(),
        'category': category?.toJson()
      };

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        weight,
        price,
        image,
        description,
        userId,
        categoryId,
        createdAt,
        updatedAt,
        isActive,
        quantity,
        user,
        category
      ];
}

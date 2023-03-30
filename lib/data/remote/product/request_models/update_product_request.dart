import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/utils/extensions/interable_extension.dart';
import 'package:miss_independent/common/utils/utils.dart';

class UpdateProductRequest {
  UpdateProductRequest({
    this.image,
    this.name,
    this.weight,
    this.price,
    this.description,
    this.categoryId,
    this.quantity,
    this.sku,
  });

  final XFile? image;
  final String? name;
  final String? price;
  final String? weight;
  final String? description;
  final int? categoryId;
  final String? quantity;
  final String? sku;

  factory UpdateProductRequest.empty() => UpdateProductRequest();

  UpdateProductRequest copyWith({
    XFile? image,
    String? name,
    String? price,
    String? weight,
    String? description,
    int? categoryId,
    String? quantity,
    String? sku,
  }) {
    return UpdateProductRequest(
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
      sku: sku ?? this.sku,
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> data = {
      "name": name ?? '',
      "price": parseDouble(price),
      "weight": parseDouble(weight),
      "description": description,
      "category_id": parseInt(categoryId),
      "quantity": parseInt(quantity),
      "sku": sku,
    }..removeNull();
    if (image != null) {
      data['image'] =
          await MultipartFile.fromFile(image!.path, filename: image!.name);
    }
    return data;
  }
}

import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/product.dart';

import '../../../models/category.dart';

class AddProductState extends Equatable {
  const AddProductState(
      {this.product, this.categories, this.status = RequestStatus.initial, this.message});

  final Product? product;
  final RequestStatus status;
  final List<Category>? categories;
  final String? message;

  AddProductState copyWith(
      {Product? product,List<Category>? categories, RequestStatus? status, String? message}) {
    return AddProductState(
        product: product ?? this.product,
        categories: categories ?? this.categories,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[product, status,categories, message];
}

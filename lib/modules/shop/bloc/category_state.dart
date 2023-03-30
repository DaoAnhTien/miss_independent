import 'package:equatable/equatable.dart';

import '../../../models/category.dart';
import '../../../models/pagination.dart';

class CategoryState extends Equatable {
  const CategoryState(
      {this.categories, this.status = DataSourceStatus.initial, this.message});

  final List<Category>? categories;
  final DataSourceStatus status;
  final String? message;

  CategoryState copyWith(
      {List<Category>? categories, DataSourceStatus? status, String? message}) {
    return CategoryState(
        categories: categories ?? this.categories,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[categories, status, message];
}

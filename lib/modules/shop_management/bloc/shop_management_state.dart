import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/product.dart';
import '../../../models/pagination.dart';

class ShopManagementState extends Equatable {
  const ShopManagementState(
      {this.products,
      this.deleteStatus = RequestStatus.initial,
      this.status = DataSourceStatus.initial,
      this.message});

  final List<Product>? products;
  final DataSourceStatus status;
  final RequestStatus deleteStatus;
  final String? message;

  ShopManagementState copyWith(
      {List<Product>? products,
      DataSourceStatus? status,
      RequestStatus? deleteStatus,
      String? message}) {
    return ShopManagementState(
        products: products ?? this.products,
        status: status ?? this.status,
        deleteStatus: deleteStatus ?? this.deleteStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[products, status, deleteStatus, message];
}

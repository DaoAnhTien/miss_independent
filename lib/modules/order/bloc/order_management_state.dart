import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/pagination.dart';

import '../../../models/order.dart';

class OrderManagementState extends Equatable {
  const OrderManagementState(
      {this.status = DataSourceStatus.initial, this.orders, this.message});

  final DataSourceStatus status;
  final String? message;
  final List<OrderModel>? orders;

  OrderManagementState copyWith(
      {DataSourceStatus? status, List<OrderModel>? orders, String? message}) {
    return OrderManagementState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[status, orders, message];
}

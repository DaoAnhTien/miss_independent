import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/cart.dart';
import '../../../models/pagination.dart';

class CartState extends Equatable {
  const CartState(
      {this.carts,
      this.totalPrice = 0,
      this.status = DataSourceStatus.initial,
      this.editStatus = RequestStatus.initial,
      this.deleteStatus = RequestStatus.initial,
      this.message});

  final List<Cart>? carts;
  final double totalPrice;
  final DataSourceStatus status;
  final RequestStatus editStatus;
  final RequestStatus deleteStatus;
  final String? message;

  CartState copyWith(
      {List<Cart>? carts,
      RequestStatus? editStatus,
      RequestStatus? deleteStatus,
      double? totalPrice,
      DataSourceStatus? status,
      String? message}) {
    return CartState(
        carts: carts ?? this.carts,
        totalPrice: totalPrice ?? this.totalPrice,
        editStatus: editStatus ?? this.editStatus,
        deleteStatus: deleteStatus ?? this.deleteStatus,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[carts, totalPrice, deleteStatus, editStatus, status, message];
}

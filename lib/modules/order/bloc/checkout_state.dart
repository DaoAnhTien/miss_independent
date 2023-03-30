import 'package:equatable/equatable.dart';
import 'package:miss_independent/data/remote/order/request_model/checkout_request.dart';

import '../../../common/enums/status.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = RequestStatus.initial,
    this.message,
  });
  final RequestStatus status;
  final String? message;

  CheckoutState copyWith(
      {RequestStatus? status,
      CheckoutRequest? checkoutRequest,
      String? message}) {
    return CheckoutState(
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[status, message];
}

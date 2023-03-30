import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/data/local/datasource/order_local_datasource.dart';
import 'package:miss_independent/data/remote/order/request_model/checkout_request.dart';
import 'package:miss_independent/modules/order/helpers/event_bus_events.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../repositories/checkout_repository.dart';
import 'checkout_state.dart';

@Injectable()
class CheckoutCubit extends Cubit<CheckoutState> with EventBusMixin {
  late final OrderRepository _orderRepository;
  late final OrderLocalDataSource _orderLocalDataSource;

  CheckoutCubit(
      {required OrderRepository orderRepository,
      required OrderLocalDataSource orderLocalDataSource})
      : super(const CheckoutState()) {
    _orderRepository = orderRepository;
    _orderLocalDataSource = orderLocalDataSource;
  }

  Future<void> placeOrder(CheckoutRequest checkoutRequest) async {
    _orderLocalDataSource.saveCheckoutRequest(checkoutRequest);
    emit(state.copyWith(status: RequestStatus.requesting));
    try {
      final DataState result =
          await _orderRepository.placeOrder(checkoutRequest);
      if (result is DataSuccess) {
        emit(state.copyWith(
          status: RequestStatus.success,
        ));
        shareEvent(CheckoutEvent());
      } else {
        emit(state.copyWith(
          status: RequestStatus.failed,
          message: result.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }
}

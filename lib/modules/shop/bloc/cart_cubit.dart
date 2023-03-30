import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/modules/order/helpers/event_bus_events.dart';
import 'package:miss_independent/modules/shop/helpers/event_bus_events.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/cart.dart';
import '../../../models/pagination.dart';
import '../../../repositories/shop_repository.dart';
import 'cart_state.dart';

@Injectable()
class CartCubit extends Cubit<CartState> with EventBusMixin {
  late final ShopRepository _shopRepository;

  CartCubit({required ShopRepository shopRepository})
      : super(const CartState(carts: [])) {
    _shopRepository = shopRepository;
    listenEvent<AddToCartEvent>((event) {
      fetchItems();
    });
    listenEvent<CheckoutEvent>((event) {
      fetchItems();
    });
  }

  Future<void> fetchItems({bool isInit = false}) async {
    try {
      emit(state.copyWith(
          deleteStatus: RequestStatus.initial,
          editStatus: RequestStatus.initial,
          status:
              isInit ? DataSourceStatus.initial : DataSourceStatus.refreshing));
      final DataState<List<Cart>> result = await _shopRepository.showCart();
      if (result is DataSuccess) {
        emit(state.copyWith(
          totalPrice: result.data?.fold<double>(
              0,
              (sum, item) =>
                  sum + ((item.product?.price ?? 0) * (item.quantity ?? 0))),
          carts: result.data,
          status: (result.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          carts: result.data,
          status: DataSourceStatus.failed,
          message: result.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> editQuantity(int id, int quantity) async {
    try {
      emit(state.copyWith(
          deleteStatus: RequestStatus.initial,
          editStatus: RequestStatus.requesting));
      final DataState result = await _shopRepository.editQuantity(id, quantity);
      if (result is DataSuccess) {
        final list = state.carts!.map<Cart>((element) {
          if (element.id == id) {
            return element.copyWith(quantity: quantity);
          } else {
            return element;
          }
        }).toList();

        emit(state.copyWith(
          totalPrice: list.fold<double>(
              0,
              (sum, item) =>
                  sum + ((item.product?.price ?? 0) * (item.quantity ?? 0))),
          carts: list,
          editStatus: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          editStatus: RequestStatus.failed,
          message: result.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          editStatus: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> deleteCart(int id) async {
    try {
      emit(state.copyWith(
          editStatus: RequestStatus.initial,
          deleteStatus: RequestStatus.requesting));
      final DataState result = await _shopRepository.deleteCart(id);
      if (result is DataSuccess) {
        final list = state.carts?.where((element) => element.id != id).toList();
        emit(state.copyWith(
            totalPrice: list?.fold<double>(
                0,
                (sum, item) =>
                    sum + ((item.product?.price ?? 0) * (item.quantity ?? 0))),
            carts: list,
            deleteStatus: RequestStatus.success,
            status: (list ?? []).isEmpty
                ? DataSourceStatus.empty
                : DataSourceStatus.success));
      } else {
        emit(state.copyWith(
          deleteStatus: RequestStatus.failed,
          message: result.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          deleteStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../models/product.dart';
import '../../../repositories/shop_repository.dart';
import '../helpers/event_bus_events.dart';
import 'product_detail_state.dart';

@Injectable()
class ProductDetailCubit extends Cubit<ProductDetailState> with EventBusMixin {
  late final ShopRepository _shopRepository;

  ProductDetailCubit({required ShopRepository shopRepository})
      : super(const ProductDetailState()) {
    _shopRepository = shopRepository;
  }

  void init(Product? product) {
    emit(state.copyWith(product: product, status: RequestStatus.initial));
  }

  Future<void> fetchItems() async {
    try {
      final DataState<Product> result =
          await _shopRepository.getProductDetail(state.product?.id ?? 0);
      if (result is DataSuccess) {
        emit(state.copyWith(
          product: result.data,
          status: RequestStatus.success,
        ));
      } else {
        emit(state.copyWith(
          product: result.data,
          status: RequestStatus.failed,
          message: result.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> addToCart({bool isBuyNow = false}) async {
    emit(isBuyNow
        ? state.copyWith(buyNowStatus: RequestStatus.requesting)
        : state.copyWith(addToCartStatus: RequestStatus.requesting));
    try {
      final DataState result =
          await _shopRepository.addToCart(state.product?.id ?? 0, 1);
      if (result is DataSuccess) {
        shareEvent(AddToCartEvent());
        emit(isBuyNow
            ? state.copyWith(buyNowStatus: RequestStatus.success)
            : state.copyWith(addToCartStatus: RequestStatus.success));
      } else {
        emit(isBuyNow
            ? state.copyWith(
                buyNowStatus: RequestStatus.failed, message: result.message)
            : state.copyWith(
                addToCartStatus: RequestStatus.failed,
                message: result.message));
      }
    } on Exception catch (e) {
      emit(isBuyNow
          ? state.copyWith(
              buyNowStatus: RequestStatus.failed, message: e.toString())
          : state.copyWith(
              addToCartStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

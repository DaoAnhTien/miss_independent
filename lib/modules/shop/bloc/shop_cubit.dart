import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/pagination.dart';
import '../../../models/product.dart';
import '../../../repositories/shop_repository.dart';
import '../helpers/event_bus_events.dart';
import 'shop_state.dart';

@Injectable()
class ShopCubit extends Cubit<ShopState> with EventBusMixin {
  late final ShopRepository _shopRepository;

  ShopCubit({required ShopRepository shopRepository})
      : super(const ShopState(products: [])) {
    _shopRepository = shopRepository;
  }
  final Pagination<Product> _pagination = Pagination<Product>(data: []);

  void setCategoryId(int? id) {
    emit(state.copyWith(categoryId: id));
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.products?.isEmpty ?? true)) {
      emit(state.copyWith(status: DataSourceStatus.initial));
    } else if (!isInit && !isSearch) {
      emit(state.copyWith(status: DataSourceStatus.refreshing));
    }
    _fetchItems(_pagination.currentPage);
  }

  Future<void> loadMoreItems() async {
    if (_pagination.allowMore(state.status)) {
      emit(state.copyWith(status: DataSourceStatus.loadMore));
      _fetchItems(_pagination.nextPage);
    }
  }

  Future<void> _fetchItems(int page) async {
    try {
      final DataState<Pagination<Product>> results =
          await _shopRepository.getProducts(page, state.categoryId);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          products: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          products: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> addToCart(int productId) async {
    emit(state.copyWith(addToCartStatus: RequestStatus.requesting));
    try {
      final DataState result = await _shopRepository.addToCart(productId, 1);
      if (result is DataSuccess) {
        shareEvent(AddToCartEvent());
        emit(state.copyWith(addToCartStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            addToCartStatus: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          addToCartStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/order_local_datasource.dart';

import '../../../common/api_client/data_state.dart';
import '../../../models/order.dart';
import '../../../models/pagination.dart';
import '../../../repositories/checkout_repository.dart';
import 'order_history_state.dart';

@Injectable()
class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  late final OrderRepository _checkoutRepository;
  late final OrderLocalDataSource _orderLocalDataSource;

  OrderHistoryCubit(
      {required OrderRepository checkoutRepository,
      required OrderLocalDataSource orderLocalDataSource})
      : super(const OrderHistoryState(orders: [])) {
    _checkoutRepository = checkoutRepository;
    _orderLocalDataSource = orderLocalDataSource;
    _initData();
  }
  final Pagination<OrderModel> _pagination = Pagination<OrderModel>(data: []);

  void _initData() {
    var items = _orderLocalDataSource.getOrderHistory();
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        orders: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  Future<void> refreshItems(
      {bool isInit = false, bool isSearch = false}) async {
    _pagination.reset();
    if (isInit && (state.orders?.isEmpty ?? true)) {
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
      final DataState<Pagination<OrderModel>> results =
          await _checkoutRepository.getOrderHistory(page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          orders: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        if (page == 1) {
          _orderLocalDataSource.saveOrderHistory(_pagination.data);
        }
      } else {
        emit(state.copyWith(
          orders: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }
}

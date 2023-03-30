import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/product_local_datasource.dart';
import 'package:miss_independent/models/product.dart';
import 'package:miss_independent/repositories/product_repository.dart';
import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import 'shop_management_state.dart';

@Injectable()
class ShopManagementCubit extends Cubit<ShopManagementState>
    with EventBusMixin {
  late final ProductRepository _productRepository;
  late final ProductLocalDatasource _productLocalDatasource;

  ShopManagementCubit(
      {required ProductRepository productRepository,
      required ProductLocalDatasource productLocalDatasource})
      : super(const ShopManagementState(
          products: [],
        )) {
    _productRepository = productRepository;
    _productLocalDatasource = productLocalDatasource;
    _initData();
  }
  void _initData() {
    var items = _productLocalDatasource.getMyProducts();
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        products: items,
        status: DataSourceStatus.success,
      ));
    }
  }

  final Pagination<Product> _pagination = Pagination<Product>(data: []);

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
          await _productRepository.getMyProducts(page);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          products: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
        _productLocalDatasource.saveProducts(_pagination.data);
      } else {
        emit(state.copyWith(
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      emit(state.copyWith(deleteStatus: RequestStatus.requesting));
      final DataState<dynamic> result =
          await _productRepository.deleteProduct(id);
      if (result is DataSuccess) {
        emit(state.copyWith(
            products:
                state.products?.where((element) => element.id != id).toList(),
            deleteStatus: RequestStatus.success,
            message: result.data));
      } else {
        emit(state.copyWith(
            deleteStatus: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          deleteStatus: RequestStatus.failed, message: e.toString()));
    }
  }
}

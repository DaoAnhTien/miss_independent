import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/product/request_models/update_product_request.dart';
import 'package:miss_independent/models/category.dart';
import 'package:miss_independent/models/product.dart';
import 'package:miss_independent/repositories/auth_repository.dart';
import 'package:miss_independent/repositories/product_repository.dart';
import '../../../common/api_client/data_state.dart';
import '../../../common/enums/status.dart';
import 'add_product_state.dart';

@Injectable()
class AddProductCubit extends Cubit<AddProductState> {
  late final ProductRepository _productRepository;
  late final AuthRepository _authRepository;

  AddProductCubit(
      {required ProductRepository productRepository,
      required AuthRepository authRepository})
      : super(const AddProductState()) {
    _productRepository = productRepository;
    _authRepository = authRepository;
  }

  void init(Product? product) {
    emit(state.copyWith(product: product, status: RequestStatus.initial));
  }

  Future<void> getCategories() async {
    try {
      final DataState<List<Category>> generalCategories =
          await _authRepository.getCategories("general");
      emit(state.copyWith(categories: generalCategories.data));
    } on Exception catch (_) {}
  }

  Future<void> addProduct(UpdateProductRequest updateProductRequest) async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState<Product?> result =
          await _productRepository.createProduct(updateProductRequest);
      if (result is DataSuccess) {
        emit(state.copyWith(
            status: RequestStatus.success, message: result.message));
      } else {
        emit(state.copyWith(
            status: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> updateProduct(UpdateProductRequest updateProductRequest) async {
    try {
      emit(state.copyWith(status: RequestStatus.requesting));
      final DataState<Product?> result = await _productRepository.updateProduct(
          state.product?.id ?? 0, updateProductRequest);
      if (result is DataSuccess) {
        emit(state.copyWith(
            status: RequestStatus.success, message: result.message));
      } else {
        emit(state.copyWith(
            status: RequestStatus.failed, message: result.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }
}

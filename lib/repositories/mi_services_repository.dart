import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/mi_services/mi_services_service.dart';
import 'package:miss_independent/models/user.dart';

import '../common/api_client/data_state.dart';
import '../models/pagination.dart';

abstract class MIServicesRepository {
  Future<DataState<Pagination<User>>> getServices(
      int page, ServiceProviderType type);
  Future<DataState<Pagination<User>>> searchServices(
      String? text,
      String? location,
      String? categoryName,
      int page,
      ServiceProviderType type);
}

@LazySingleton(as: MIServicesRepository)
class MIServicesRepositoryImpl implements MIServicesRepository {
  final MIServicesService _miServicesService;

  MIServicesRepositoryImpl({required MIServicesService miServicesService})
      : _miServicesService = miServicesService;

  @override
  Future<DataState<Pagination<User>>> getServices(
      int page, ServiceProviderType type) {
    return _miServicesService.getServices(page, type);
  }

  @override
  Future<DataState<Pagination<User>>> searchServices(
      String? text,
      String? location,
      String? categoryName,
      int page,
      ServiceProviderType type) {
    return _miServicesService.searchServices(
        text, location, categoryName, page, type);
  }
}

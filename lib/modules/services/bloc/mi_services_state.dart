import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/category.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/user.dart';

class MIServicesState extends Equatable {
  const MIServicesState(
      {this.status = DataSourceStatus.initial,
      this.message,
      this.searchName,
      this.location,
      this.categories,
      this.users,
      this.type});

  final DataSourceStatus? status;
  final String? message;
  final String? searchName;
  final String? location;
  final List<Category>? categories;
  final List<User>? users;
  final ServiceProviderType? type;

  factory MIServicesState.initState() => const MIServicesState();

  MIServicesState copyWith(
      {DataSourceStatus? status,
      String? message,
      String? searchName,
      String? location,
      List<Category>? categories,
      List<User>? users,
      ServiceProviderType? type}) {
    return MIServicesState(
      status: status ?? this.status,
      message: message ?? this.message,
      searchName: searchName ?? this.searchName,
      location: location ?? this.location,
      categories: categories ?? this.categories,
      users: users ?? this.users,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[status, message, searchName, location, categories, users, type];
}

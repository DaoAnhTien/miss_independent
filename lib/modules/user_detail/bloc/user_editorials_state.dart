import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/post.dart';

class UserEditorialsState extends Equatable {
  const UserEditorialsState(
      {this.type,
      this.editorials,
      this.status = DataSourceStatus.initial,
      this.message});

  final String? type;
  final List<Post>? editorials;
  final DataSourceStatus status;
  final String? message;

  UserEditorialsState copyWith(
      {String? type,
      List<Post>? editorials,
      DataSourceStatus? status,
      String? message}) {
    return UserEditorialsState(
        type: type ?? this.type,
        editorials: editorials ?? this.editorials,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[type, editorials, status, message];
}

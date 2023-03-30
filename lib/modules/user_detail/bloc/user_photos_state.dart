import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/post.dart';

import '../../../models/user.dart';

class UserPhotosState extends Equatable {
  const UserPhotosState(
      {this.type,
      this.photos,
      this.user,
      this.status = DataSourceStatus.initial,
      this.message});

  final String? type;
  final List<Post>? photos;
  final DataSourceStatus status;
  final String? message;
  final User? user;

  UserPhotosState copyWith(
      {String? type,
      List<Post>? photos,
      User? user,
      DataSourceStatus? status,
      String? message}) {
    return UserPhotosState(
        type: type ?? this.type,
        photos: photos ?? this.photos,
        user: user ?? this.user,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[type, photos, user, status, message];
}

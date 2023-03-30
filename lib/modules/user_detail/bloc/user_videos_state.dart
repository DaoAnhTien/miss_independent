import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/models/user.dart';

class UserVideosState extends Equatable {
  const UserVideosState(
      {this.type,
      this.videos,
      this.user,
      this.status = DataSourceStatus.initial,
      this.message});

  final String? type;
  final List<Post>? videos;
  final DataSourceStatus status;
  final String? message;
  final User? user;

  UserVideosState copyWith(
      {String? type,
      List<Post>? videos,
      User? user,
      DataSourceStatus? status,
      String? message}) {
    return UserVideosState(
        type: type ?? this.type,
        videos: videos ?? this.videos,
        user: user ?? this.user,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[type, videos, user, status, message];
}

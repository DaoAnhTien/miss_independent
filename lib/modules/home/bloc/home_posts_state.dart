import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/pagination.dart';
import '../../../models/post.dart';

class HomePostsState extends Equatable {
  const HomePostsState(
      {this.type,
      this.posts,
      this.status = DataSourceStatus.initial,
      this.delPostStatus,
      this.reportPostStatus,
      this.message});

  final String? type;
  final List<Post>? posts;
  final DataSourceStatus status;
  final RequestStatus? delPostStatus;
  final RequestStatus? reportPostStatus;
  final String? message;

  HomePostsState copyWith(
      {String? type,
      List<Post>? posts,
      DataSourceStatus? status,
      RequestStatus? delPostStatus,
      RequestStatus? reportPostStatus,
      String? message}) {
    return HomePostsState(
        type: type ?? this.type,
        posts: posts ?? this.posts,
        status: status ?? this.status,
        delPostStatus: delPostStatus ?? this.delPostStatus,
        reportPostStatus: reportPostStatus ?? this.reportPostStatus,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[type, posts, status, delPostStatus, reportPostStatus, message];
}

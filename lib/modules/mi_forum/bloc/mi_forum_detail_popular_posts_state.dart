import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/post.dart';

class MIForumDetailPopularPostsState extends Equatable {
  const MIForumDetailPopularPostsState(
      {this.posts, this.status = RequestStatus.initial, this.message});

  final List<Post>? posts;
  final RequestStatus status;
  final String? message;

  MIForumDetailPopularPostsState copyWith(
      {List<Post>? posts, RequestStatus? status, String? message}) {
    return MIForumDetailPopularPostsState(
        posts: posts ?? this.posts,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[posts, status, message];
}

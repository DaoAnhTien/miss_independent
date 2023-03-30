import 'package:equatable/equatable.dart';
import '../../../models/forum.dart';
import '../../../models/pagination.dart';

class MiForumState extends Equatable {
  const MiForumState(
      {this.forums,
      this.status = DataSourceStatus.initial,
      this.message});

  final List<Forum>? forums;
  final DataSourceStatus status;
  final String? message;

  MiForumState copyWith(
      {List<Forum>? forums,
      DataSourceStatus? status,
      String? message}) {
    return MiForumState(
        forums: forums ?? this.forums,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[ forums, status, message];
}

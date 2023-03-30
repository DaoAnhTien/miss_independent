import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/forum_member.dart';

class MiForumDetailMembersState extends Equatable {
  const MiForumDetailMembersState(
      {this.members, this.status = RequestStatus.initial, this.message});

  final List<ForumMember>? members;
  final RequestStatus status;
  final String? message;

  MiForumDetailMembersState copyWith(
      {List<ForumMember>? members, RequestStatus? status, String? message}) {
    return MiForumDetailMembersState(
        members: members ?? this.members,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[members, status, message];
}

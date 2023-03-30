import 'package:equatable/equatable.dart';

import '../../../models/pagination.dart';
import '../../../models/user.dart';

class MemberState extends Equatable {
  const MemberState(
      {this.membershipType,
      this.serviceProviderType,
      this.members,
      this.status = DataSourceStatus.initial,
      this.message});

  final String? membershipType;
  final String? serviceProviderType;
  final List<User>? members;
  final DataSourceStatus status;
  final String? message;

  MemberState copyWith(
      {String? membershipType,
      String? serviceProviderType,
      List<User>? members,
      DataSourceStatus? status,
      String? message}) {
    return MemberState(
        membershipType: membershipType ?? this.membershipType,
        serviceProviderType: serviceProviderType ?? this.serviceProviderType,
        members: members ?? this.members,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      <Object?>[membershipType, serviceProviderType, members, status, message];
}

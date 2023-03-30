import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({this.status,
    this.message});

  final RequestStatus? status;
  final String? message;


  ChangePasswordState copyWith({
    RequestStatus? status,
    String? message}) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[status, message];
}

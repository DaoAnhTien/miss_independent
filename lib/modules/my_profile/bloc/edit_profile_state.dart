import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';

import '../../../models/user.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = RequestStatus.initial,
    this.user,
    this.message,
  });

  final RequestStatus status;
  final String? message;
  final User? user;

  EditProfileState copyWith({
    RequestStatus? status,
    User? user,
    String? message,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        user,
        message,
      ];
}

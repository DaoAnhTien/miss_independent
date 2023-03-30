import 'package:equatable/equatable.dart';
import 'package:miss_independent/common/enums/status.dart';


class AddPostState extends Equatable {
  const AddPostState(
      {this.type, this.status = RequestStatus.initial, this.message});

  final String? type;
  final RequestStatus status;
  final String? message;

  AddPostState copyWith(
      {String? type,
      RequestStatus? status,
      String? message}) {
    return AddPostState(
        type: type ?? this.type,
        status: status ?? this.status,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => <Object?>[type, status, message];
}

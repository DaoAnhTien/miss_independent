import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/event.dart';

import '../../../common/enums/status.dart';

class EventDetailState extends Equatable {
  const EventDetailState({
    this.event,
    this.status = RequestStatus.initial,
    this.message,
  });

  final Event? event;
  final RequestStatus status;
  final String? message;

  EventDetailState copyWith(
      {Event? event, RequestStatus? status, String? message}) {
    return EventDetailState(
      event: event ?? this.event,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[event, status, message];
}

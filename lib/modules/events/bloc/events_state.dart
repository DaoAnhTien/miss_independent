import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/event.dart';

import '../../../models/pagination.dart';

class EventsState extends Equatable {
  const EventsState({
    this.events,
    this.status = DataSourceStatus.initial,
    this.message,
  });

  final List<Event>? events;
  final DataSourceStatus status;
  final String? message;

  EventsState copyWith(
      {List<Event>? events, DataSourceStatus? status, String? message}) {
    return EventsState(
      events: events ?? this.events,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[events, status, message];
}

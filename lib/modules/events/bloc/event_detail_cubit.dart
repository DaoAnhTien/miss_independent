import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/models/event.dart';
import 'package:miss_independent/repositories/event_repository.dart';
import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import 'event_detail_state.dart';

@Injectable()
class EventDetailCubit extends Cubit<EventDetailState> with EventBusMixin {
  late final EventRepository _eventRepository;

  EventDetailCubit({required EventRepository eventRepository})
      : super(const EventDetailState()) {
    _eventRepository = eventRepository;
  }

  void init(Event? event) {
    emit(state.copyWith(event: event, status: RequestStatus.initial));
  }

  Future<void> fetchEvent(int eventId, int userId) async {
    emit(state.copyWith(status: RequestStatus.requesting));
    try {
      final DataState<Event> results =
          await _eventRepository.getEventDetail(eventId, userId);
      if (results is DataSuccess) {
        emit(
            state.copyWith(event: results.data, status: RequestStatus.success));
      } else {
        emit(state.copyWith(
          event: results.data,
          status: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> eventFav(int eventId, int userId) async {
    emit(state.copyWith(status: RequestStatus.requesting));
    try {
      final DataState<bool?> results =
          await _eventRepository.eventFav(eventId, userId);
      if (results is DataSuccess) {
        emit(state.copyWith(
            event: state.event?.copyWith(favBit: true),
            message: results.message,
            status: RequestStatus.success));
      } else {
        emit(state.copyWith(
          status: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> eventUnFav(int eventId, int userId) async {
    emit(state.copyWith(status: RequestStatus.requesting));
    try {
      final DataState<bool?> results =
          await _eventRepository.eventUnFav(eventId, userId);
      if (results is DataSuccess) {
        emit(state.copyWith(
            event: state.event?.copyWith(favBit: false),
            message: results.message,
            status: RequestStatus.success));
      } else {
        emit(state.copyWith(
          status: RequestStatus.failed,
          message: results.message,
        ));
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }
}

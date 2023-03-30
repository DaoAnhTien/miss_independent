import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/remote/events/event_service.dart';
import 'package:miss_independent/models/event.dart';

import '../common/api_client/data_state.dart';
import '../models/pagination.dart';

abstract class EventRepository {
  Future<DataState<Pagination<Event>>> getEvent(String title, String date);

  Future<DataState<Event>> getEventDetail(int eventId, int userId);
  Future<DataState<bool>> eventFav(int eventId, int userId);
  Future<DataState<bool>> eventUnFav(int eventId, int userId);
}

@LazySingleton(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventService _eventService;

  EventRepositoryImpl({required EventService eventService})
      : _eventService = eventService;

  @override
  Future<DataState<Pagination<Event>>> getEvent(String title, String date) {
    return _eventService.getEvent(title, date);
  }

  @override
  Future<DataState<Event>> getEventDetail(int eventId, int userId) {
    return _eventService.getEventDetail(eventId, userId);
  }
  @override
  Future<DataState<bool>> eventFav(int eventId, int userId) {
    return _eventService.eventFav(eventId, userId);
  }
  @override
  Future<DataState<bool>> eventUnFav(int eventId, int userId) {
    return _eventService.eventUnFav(eventId, userId);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:miss_independent/data/local/datasource/event_local_datasource.dart';
import 'package:miss_independent/models/event.dart';
import 'package:miss_independent/repositories/event_repository.dart';
import '../../../common/api_client/data_state.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../models/pagination.dart';
import 'events_state.dart';

@Injectable()
class EventsCubit extends Cubit<EventsState> with EventBusMixin {
  late final EventRepository _eventRepository;
  late final EventLocalDatasource _eventLocalDatasource;
  EventsCubit({required EventRepository eventRepository, required EventLocalDatasource eventLocalDatasource})
      : super(const EventsState(events: [])) {
    _eventRepository = eventRepository;
    _eventLocalDatasource =eventLocalDatasource;
    _initData();
  }
  void _initData() {
    var items = _eventLocalDatasource.getEvents();
    if (items?.isNotEmpty ?? false) {
      emit(state.copyWith(
        events: items,
        status: DataSourceStatus.success,
      ));
    }
  }


  final Pagination<Event> _pagination = Pagination<Event>(data: []);

  Future<void> fetchItems(String title, String date) async {
    try {
      final DataState<Pagination<Event>> results =
          await _eventRepository.getEvent(title, date);
      if (results is DataSuccess) {
        _pagination.update(results.data);
        emit(state.copyWith(
          events: _pagination.data,
          status: (_pagination.data ?? []).isEmpty
              ? DataSourceStatus.empty
              : DataSourceStatus.success,
        ));
      } else {
        emit(state.copyWith(
          events: _pagination.data,
          status: DataSourceStatus.failed,
          message: results.message,
        ));
      }
      _eventLocalDatasource.saveEvents(_pagination.data);
    } on Exception catch (e) {
      emit(state.copyWith(
          status: DataSourceStatus.failed, message: e.toString()));
    }
  }

}

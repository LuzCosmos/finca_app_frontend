import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/simple_event_data_source.dart';
import 'massive_event_event.dart';
import 'massive_event_state.dart';

class MassiveEventBloc extends Bloc<MassiveEventEvent, MassiveEventState> {
  final ISimpleEventDataSource dataSource;

  MassiveEventBloc({required this.dataSource}) : super(MassiveEventInitial()) {
    on<AddSimpleEvent>(_onAddSimpleEventConfig);
  }

  Future<void> _onAddSimpleEventConfig(
    AddSimpleEvent event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      await dataSource.saveSimpleEvent(
        simpleEvent: event.config,
        idMassiveEvent: event.idMassiveEvent,
        idTenant: event.idTenant,
      );
      emit(
        MassiveEventSuccess(
          messageKey: 'simpleEventAdded',
          configs: [event.config],
        ),
      );
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'simpleEventError',
          debugInfo: e.toString(),
        ),
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import '../data/simple_event_data_source.dart';
import 'massive_event_event.dart';
import 'massive_event_state.dart';

class MassiveEventBloc extends Bloc<MassiveEventEvent, MassiveEventState> {
  final ISimpleEventDataSource dataSource;

  MassiveEventBloc({required this.dataSource}) : super(MassiveEventInitial()) {
    on<AddSimpleEvent>(_onAddSimpleEventConfig);
    on<AddMassiveEventWithConfig>(_onSaveMassiveEventWithConfig);
  }

  Future<SimpleEventModel> _onAddSimpleEventConfig(
    AddSimpleEvent event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      final result = await dataSource.saveSimpleEvent(
        simpleEvent: event.simpleEvent,
        idTenant: event.idTenant,
      );
      emit(
        MassiveEventSuccess(
          messageKey: 'simpleEventAdded',
          configs: [event.simpleEvent],
        ),
      );
      return result;
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'simpleEventError',
          debugInfo: e.toString(),
        ),
      );
      throw Exception(e);
    }
  }

  Future<MassiveEventModel> _onSaveMassiveEventWithConfig(
    AddMassiveEventWithConfig event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      final massiveEvent = event.massiveEvent.copyWith();
      final result = await dataSource.saveMassiveEvent(
        massiveEvent: massiveEvent,
        idTenant: event.idTenant,
      );
      emit(
        MassiveEventSuccess(
          messageKey: 'massiveEventSaved',
          configs: result.simpleEvents,
        ),
      );
      return result;
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'massiveEventError',
          debugInfo: e.toString(),
        ),
      );
      throw Exception(e);
    }
  }
}

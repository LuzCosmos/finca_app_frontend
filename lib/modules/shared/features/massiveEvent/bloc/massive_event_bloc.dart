import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'massive_event_event.dart';
import 'massive_event_state.dart';

class MassiveEventBloc extends Bloc<MassiveEventEvent, MassiveEventState> {
  final IMassiveEventPageDataSource dataSource;

  MassiveEventBloc({required this.dataSource}) : super(MassiveEventInitial()) {
    on<AddSimpleEvent>(_onAddSimpleEventConfig);
    on<AddMassiveEventWithConfig>(_onSaveMassiveEventWithConfig);
    on<AddBrand>(_onAddBrand);
    on<AddAnimalSimpleEvents>(_onSaveAnimalSimpleEvents);
    on<CloseMassiveEvent>(_onCloseMassiveEvent);
  }

  Future<SimpleEventModel> _onAddSimpleEventConfig(
    AddSimpleEvent event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      final outcome = await dataSource.saveSimpleEvent(
        simpleEvent: event.simpleEvent,
      );
      final result = outcome.saved;
      emit(
        MassiveEventSuccess(
          messageKey: 'simpleEventAdded',
          configs: [result],
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

  Future<void> _onAddBrand(
    AddBrand event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      final result = await dataSource.saveBrand(brand: event.brand);
      emit(BrandCreatedSuccess(brand: result));
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'brandSaveError',
          debugInfo: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSaveAnimalSimpleEvents(
    AddAnimalSimpleEvents event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      final outcome = await dataSource.saveAnimalSimpleEvents(
        animalSimpleEvents: event.animalSimpleEvents,
        cattleNumber: event.cattleNumber,
      );
      emit(
        AnimalSimpleEventsAdded(
          animalSimpleEvents: outcome.animalSimpleEvents,
        ),
      );
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'animalSimpleEventError',
          debugInfo: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCloseMassiveEvent(
    CloseMassiveEvent event,
    Emitter<MassiveEventState> emit,
  ) async {
    emit(MassiveEventLoading());
    try {
      await dataSource.closeMassiveEvent(idMassiveEvent: event.idMassiveEvent);
      emit(MassiveEventClosed(idMassiveEvent: event.idMassiveEvent));
    } catch (e) {
      emit(
        MassiveEventError(
          messageKey: 'massiveEventCloseError',
          debugInfo: e.toString(),
        ),
      );
    }
  }
}

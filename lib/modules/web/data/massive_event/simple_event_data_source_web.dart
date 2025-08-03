import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class SimpleEventDataSourceWeb implements ISimpleEventDataSource {
  @override
  Future<SimpleEventModel> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idTenant,
  }) async {
    final simpleEventSaved = await MassiveEventApiService.createSimpleEvent(
      simpleEvent: simpleEvent,
      massiveEventServerId: '',
    );
    return simpleEventSaved;
  }

  @override
  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  }) async {
    final created = await MassiveEventApiService.createMassiveEvent(
      massiveEvent: massiveEvent,
      idTenant: idTenant,
    );
    return created; // respuesta del backend
  }
}

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class SimpleEventDataSourceWeb implements ISimpleEventDataSource {
  String? _massiveEventServerId;
  bool _massiveEventCreated = false;

  SimpleEventDataSourceWeb();

  @override
  Future<void> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idMassiveEvent, // ignorado, lo maneja el servidor
    required String idTenant,
  }) async {
    if (!_massiveEventCreated) {
      _massiveEventServerId = await MassiveEventApiService.createMassiveEvent(
        eventDate: DateTime.now(),
        simpleEvents: [simpleEvent],
      );
      _massiveEventCreated = true;
    } else {
      await MassiveEventApiService.createSimpleEvent(
        massiveEventServerId: _massiveEventServerId!,
        simpleEvent: simpleEvent,
      );
    }
  }
}

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_config.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class SimpleEventDataSourceWeb implements ISimpleEventDataSource {
  final MassiveEventApiService apiService;
  final String createdBy; // puedes inyectar datos de sesión aquí

  String? _massiveEventServerId;
  bool _massiveEventCreated = false;

  SimpleEventDataSourceWeb({required this.apiService, required this.createdBy});

  @override
  Future<void> saveSimpleEvent({
    required SimpleEventConfig config,
    required String massiveEventId, // ignorado, lo maneja el servidor
    required String idTenant,
  }) async {
    if (!_massiveEventCreated) {
      _massiveEventServerId = await apiService.createMassiveEvent(
        idTenant: idTenant,
        eventDate: DateTime.now(),
        createdBy: createdBy,
      );
      _massiveEventCreated = true;
    }

    await apiService.createSimpleEvent(
      massiveEventServerId: _massiveEventServerId!,
      idTenant: idTenant,
      config: config,
    );
  }
}

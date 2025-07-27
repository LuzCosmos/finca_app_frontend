import '../models/simple_event_config.dart';

abstract class ISimpleEventDataSource {
  /// Guarda un simple event y retorna el id generado o null
  Future<void> saveSimpleEvent({
    required SimpleEventConfig config,
    required String massiveEventId,
    required String idTenant,
  });
}

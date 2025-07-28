import '../models/simple_event_model.dart';

abstract class ISimpleEventDataSource {
  /// Guarda un simple event y retorna el id generado o null
  Future<void> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idMassiveEvent,
    required String idTenant,
  });
}

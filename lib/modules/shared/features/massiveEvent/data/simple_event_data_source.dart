import '../models/simple_event_model.dart';
import '../models/massive_event_model.dart';

abstract class ISimpleEventDataSource {
  /// Guarda un simple event y retorna el id generado o null
  Future<SimpleEventModel> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idTenant,
  });

  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  });
}

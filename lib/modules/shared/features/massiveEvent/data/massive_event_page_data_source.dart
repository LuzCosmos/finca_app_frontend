import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_session_load.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

/// Resultado de guardar un simple: si se subió antes un masivo pendiente, la UI
/// debe actualizar [newMassiveEventId] y sustituir la lista por [remappedSimpleEvents].
class SaveSimpleEventResult {
  final SimpleEventModel saved;
  final String? newMassiveEventId;
  final List<SimpleEventModel>? remappedSimpleEvents;

  const SaveSimpleEventResult({
    required this.saved,
    this.newMassiveEventId,
    this.remappedSimpleEvents,
  });
}

class SaveAnimalSimpleEventsResult {
  final List<AnimalSimpleEventModel> animalSimpleEvents;
  final String? newMassiveEventId;
  final List<SimpleEventModel>? remappedSimpleEvents;

  /// En móvil, `false` cuando solo se persistió en Drift a la espera de red.
  final bool syncedWithServer;

  const SaveAnimalSimpleEventsResult({
    required this.animalSimpleEvents,
    this.newMassiveEventId,
    this.remappedSimpleEvents,
    this.syncedWithServer = true,
  });
}

abstract class IMassiveEventPageDataSource {
  Future<SaveSimpleEventResult> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
  });

  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
  });

  Future<BrandModel> saveBrand({required BrandModel brand});

  Future<List<BrandModel>> getAllBrands();

  Future<List<AnimalSimpleEventModel>> getAnimalSimpleEvents({
    required String idMassiveEvent,
  });

  Future<SaveAnimalSimpleEventsResult> saveAnimalSimpleEvents({
    required List<AnimalSimpleEventModel> animalSimpleEvents,
    required String cattleNumber,
  });

  Future<void> closeMassiveEvent({required String idMassiveEvent});

  Future<void> updateSimpleEvent({required SimpleEventModel simpleEvent, required String endpoint});

  /// Carga masivo + animales ya aplicados (edición / continuar sesión).
  Future<MassiveSessionLoadResult> loadMassiveEventSession({required String idMassiveEvent});

  /// Actualiza el nombre del masivo (flujo autónomo).
  Future<MassiveEventModel> updateMassiveEventName({
    required String idMassiveEvent,
    required String name,
  });
}

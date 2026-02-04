import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

abstract class IMassiveEventPageDataSource {
  /// Guarda un simple event y retorna el id generado o null
  Future<SimpleEventModel> saveSimpleEvent({
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

  Future<List<AnimalSimpleEventModel>> saveAnimalSimpleEvents({
    required List<AnimalSimpleEventModel> animalSimpleEvents,
    required String cattleNumber,
  });

  Future<void> closeMassiveEvent({required String idMassiveEvent});

  Future<void> updateSimpleEvent({required SimpleEventModel simpleEvent, required String endpoint});
}

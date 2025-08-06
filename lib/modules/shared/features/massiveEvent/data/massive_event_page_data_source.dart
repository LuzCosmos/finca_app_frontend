import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';

import '../models/simple_event_model.dart';
import '../models/massive_event_model.dart';

abstract class IMassiveEventPageDataSource {
  /// Guarda un simple event y retorna el id generado o null
  Future<SimpleEventModel> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idTenant,
  });

  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  });

  Future<BrandModel> saveBrand({required BrandModel brand});

  Future<List<BrandModel>> getAllBrands();
}

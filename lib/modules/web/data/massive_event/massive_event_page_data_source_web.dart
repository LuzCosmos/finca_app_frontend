import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class MassiveEventPageDataSourceWeb implements IMassiveEventPageDataSource {
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

  @override
  Future<BrandModel> saveBrand({required BrandModel brand}) async {
    final created = BrandApiService.createBrand(brand: brand);
    return created;
  }

  @override
  Future<List<BrandModel>> getAllBrands() {
    final brands = BrandApiService.getAllBrands();
    return brands;
  }
}

import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_session_load.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class MassiveEventPageDataSourceWeb implements IMassiveEventPageDataSource {
  @override
  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    final created = await MassiveEventApiService.createMassiveEvent(
      massiveEvent: massiveEvent,
      idTenant: idTenant!,
    );
    return created;
  }

  @override
  Future<SaveSimpleEventResult> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    simpleEvent.idTenant = idTenant;
    final simpleEventSaved = await MassiveEventApiService.createSimpleEvent(
      simpleEvent: simpleEvent,
      massiveEventServerId: '',
    );
    return SaveSimpleEventResult(saved: simpleEventSaved);
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

  @override
  Future<List<AnimalSimpleEventModel>> getAnimalSimpleEvents({
    required String idMassiveEvent,
  }) {
    // TODO: implement getAnimalSimpleEvents
    throw UnimplementedError();
  }

  @override
  Future<SaveAnimalSimpleEventsResult> saveAnimalSimpleEvents({
    required List<AnimalSimpleEventModel> animalSimpleEvents,
    required String cattleNumber,
  }) async {
    final appliedBy = await SessionService.getIdUser();
    for (var animalSimpleEvent in animalSimpleEvents) {
      animalSimpleEvent.appliedBy = appliedBy;
    }
    final animalSimpleEventsSaved =
        await MassiveEventApiService.saveAnimalSimpleEvents(
          animalSimpleEvents: animalSimpleEvents,
          cattleNumber: cattleNumber,
        );
    return SaveAnimalSimpleEventsResult(
      animalSimpleEvents: animalSimpleEventsSaved,
    );
  }

  @override
  Future<void> closeMassiveEvent({required String idMassiveEvent}) async {
    await MassiveEventApiService.closeMassiveEvent(
      idMassiveEvent: idMassiveEvent,
    );
  }

  @override
  Future<void> updateSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String endpoint,
  }) async {
    await MassiveEventApiService.updateSimpleEvent(
      simpleEvent: simpleEvent,
      endpoint: endpoint,
    );
  }

  @override
  Future<MassiveEventModel> updateMassiveEventName({
    required String idMassiveEvent,
    required String name,
  }) {
    return MassiveEventApiService.updateMassiveEventName(
      idMassiveEvent: idMassiveEvent,
      name: name,
    );
  }

  @override
  Future<MassiveSessionLoadResult> loadMassiveEventSession({
    required String idMassiveEvent,
  }) async {
    final massive = await MassiveEventApiService.getMassiveEventByIdHydratingSimpleEvents(
      idMassiveEvent: idMassiveEvent,
    );
    final appliedJson = await MassiveEventApiService.getAppliedAnimalsSession(
      idMassiveEvent: idMassiveEvent,
    );
    return massiveSessionFromAppliedAnimalsJson(massive, appliedJson);
  }
}

import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';
import 'package:finca_app_frontend/core/services/network_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class MassiveEventPageDataSourceMobile implements IMassiveEventPageDataSource {
  final SimpleEventRepository repo;
  final MassiveEventRepository _massiveEventRepository;

  MassiveEventPageDataSourceMobile(this.repo, this._massiveEventRepository);

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
    /*var enriched = massiveEvent.copyWith();
    enriched.idTenant = idTenant;
    try {
      var isSynced = false;
      final hasNetwork = await NetworkService().hasNetwork();
      if (hasNetwork) {
        try {
          enriched = await MassiveEventApiService.createMassiveEvent(
            massiveEvent: enriched,
            idTenant: idTenant!,
          );
          isSynced = true;
        } catch (e) {
          isSynced = false;
        }
      } else {
        isSynced = false;
      }
      await _massiveEventRepository.insert(enriched, isSynced: isSynced);
      return enriched;
    } catch (_) {
      await _massiveEventRepository.insert(enriched, isSynced: false);
      return enriched;
    }*/
  }

  @override
  Future<SimpleEventModel> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    simpleEvent.idTenant = idTenant;
    final simpleEventSaved = await MassiveEventApiService.createSimpleEvent(
      simpleEvent: simpleEvent,
      massiveEventServerId: '',
    );
    return simpleEventSaved;
    /*var simpleEventEnriched = simpleEvent.copyWith();
    simpleEventEnriched.idTenant = idTenant!;
    var isSynced = false;
    //TODO:Revisar que aunque haya un idMssiveEvent pude ser que sea porque se guardo en el repo local pero no en el del backend
    try {
      final hasNetwork = await NetworkService().hasNetwork();
      if (hasNetwork) {
        try {
          simpleEventEnriched = await MassiveEventApiService.createSimpleEvent(
            simpleEvent: simpleEventEnriched,
            massiveEventServerId: simpleEventEnriched.idMassiveEvent!,
          );
          isSynced = true;
        } catch (e) {
          isSynced = false;
        }
      } else {
        isSynced = false;
      }
    } catch (e) {
      isSynced = false;
    }
    await repo.create(
      simpleEventEnriched.toLocalCompanion(
        simpleEventEnriched.idMassiveEvent!,
        idTenant!,
        isSynced: isSynced,
      ),
    );
    return simpleEventEnriched;*/
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
  Future<List<AnimalSimpleEventModel>> saveAnimalSimpleEvents({
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
    return animalSimpleEventsSaved;
  }

  @override
  Future<void> closeMassiveEvent({required String idMassiveEvent}) {
    // TODO: implement closeMassiveEvent
    throw UnimplementedError();
  }
}

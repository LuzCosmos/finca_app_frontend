import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';
import 'package:finca_app_frontend/core/services/network_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

class MassiveEventPageDataSourceMobile implements IMassiveEventPageDataSource {
  final SimpleEventRepository repo;
  final MassiveEventRepository _massiveEventRepository;

  MassiveEventPageDataSourceMobile(this.repo, this._massiveEventRepository);

  @override
  Future<SimpleEventModel> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String idTenant,
  }) async {
    var simpleEventEnriched = simpleEvent.copyWith();
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
        idTenant,
        isSynced: isSynced,
      ),
    );
    return simpleEventEnriched;
  }

  @override
  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  }) async {
    var enriched = massiveEvent.copyWith();
    enriched.idTenant = idTenant;
    try {
      var isSynced = false;
      final hasNetwork = await NetworkService().hasNetwork();
      if (hasNetwork) {
        try {
          enriched = await MassiveEventApiService.createMassiveEvent(
            massiveEvent: enriched,
            idTenant: idTenant,
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
    }
  }

  @override
  Future<BrandModel> saveBrand({required BrandModel brand}) async {
    // TODO: implement getAllBrands
    throw UnimplementedError();
  }

  @override
  Future<List<BrandModel>> getAllBrands() {
    // TODO: implement getAllBrands
    throw UnimplementedError();
  }
}

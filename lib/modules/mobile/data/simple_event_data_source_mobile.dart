import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_config.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/modules/mobile/mappers/simple_event_config_mapper.dart';

class SimpleEventDataSourceMobile implements ISimpleEventDataSource {
  final SimpleEventRepository repo;

  SimpleEventDataSourceMobile(this.repo);

  @override
  Future<void> saveSimpleEvent({
    required SimpleEventConfig config,
    required String massiveEventId,
    required String idTenant,
  }) async {
    // guarda local en SQLite usando el repo
    await repo.create(config.toLocalCompanion(massiveEventId, idTenant));
  }
}

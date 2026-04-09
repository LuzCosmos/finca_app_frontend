import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_page_data_source_mobile.dart';

IMassiveEventPageDataSource createMassiveEventPageDataSource() {
  final db = DatabaseProvider.database;
  final repo = SimpleEventRepository(db.simpleEventDao);
  final massiveEventRepo = MassiveEventRepository(
    db.massiveEventDao,
    db.simpleEventDao,
  );
  final animalRepo = AnimalSimpleEventRepository(db.animalSimpleEventDao);
  return MassiveEventPageDataSourceMobile(
    repo,
    massiveEventRepo,
    animalRepo,
  );
}

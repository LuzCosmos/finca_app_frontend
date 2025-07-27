import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/mobile/data/simple_event_data_source_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';

ISimpleEventDataSource createMassiveEventDataSource() {
  final db = AppDatabase();
  final repo = SimpleEventRepository(db.simpleEventDao);
  return SimpleEventDataSourceMobile(repo);
}

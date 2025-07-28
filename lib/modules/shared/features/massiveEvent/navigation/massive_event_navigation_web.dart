import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';
import 'package:finca_app_frontend/modules/web/data/simple_event_data_source_web.dart';

ISimpleEventDataSource createMassiveEventDataSource() {
  return SimpleEventDataSourceWeb();
}

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web.dart';

IMassiveEventPageDataSource createMassiveEventPageDataSource() {
  return MassiveEventPageDataSourceWeb();
}

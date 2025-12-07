import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web.dart';

ISalesDataSource createSalesDataSource() {
  return SalesDataSourceWeb();
}

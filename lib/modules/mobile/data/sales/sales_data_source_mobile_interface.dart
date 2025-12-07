import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/modules/mobile/data/sales/sales_data_source_mobile.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';

ISalesDataSource createSalesDataSource() {
  final db = DatabaseProvider.database;
  return SalesDataSourceMobile(db);
}

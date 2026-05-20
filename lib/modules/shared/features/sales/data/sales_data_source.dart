import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';

abstract class ISalesDataSource {
  Future<List<dynamic>> getProviders(
    String type,
  ); // Returns Providers (Buyers/Transporters)
  Future<dynamic> getCattleByNumber(String number); // Returns Cattle info
  Future<void> saveSale(SaleModel sale);
  Future<void> fetchCatalogs();

  // Web Dashboard methods
  Future<PaginatedSales> getSales(SalesQuery query);
  Future<void> updateSale(String id, Map<String, dynamic> updates);
}

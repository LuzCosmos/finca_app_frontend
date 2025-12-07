import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/core/data/database/tables/provider_local.dart'; // Using table class as model for simplicity or Create Provider Model?
// Better to return a List<ProviderModel> but naming might conflict.
// Let's assume we return dynamic or a defined ProviderModel if it exists.
// I'll check if ProviderModel exists, if not I'll use a simple Map or create one.
// I'll just use dynamic or create a local definition here.

import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';

abstract class ISalesDataSource {
  Future<List<dynamic>> getProviders(String type); // Returns Providers (Buyers/Transporters)
  Future<dynamic> getCattleByNumber(String number); // Returns Cattle info
  Future<void> saveSale(SaleModel sale);
  Future<List<SaleModel>> getUnsyncedSales();
  Future<void> syncSales();
  Future<void> fetchCatalogs();
  
  // Web Dashboard methods
  Future<PaginatedSales> getSales(SalesQuery query);
  Future<void> updateSale(String id, Map<String, dynamic> updates);
}


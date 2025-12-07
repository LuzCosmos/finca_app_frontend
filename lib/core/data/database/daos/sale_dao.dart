import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/tables/sale_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/sale_detail_local.dart';

part 'sale_dao.g.dart';

@DriftAccessor(tables: [SaleLocal, SaleDetailLocal])
class SaleDao extends DatabaseAccessor<AppDatabase> with _$SaleDaoMixin {
  SaleDao(AppDatabase db) : super(db);

  Future<void> insertSale(SaleLocalCompanion sale, List<SaleDetailLocalCompanion> details) {
    return transaction(() async {
      await into(saleLocal).insert(sale);
      for (final detail in details) {
        await into(saleDetailLocal).insert(detail);
      }
    });
  }

  Future<List<SaleLocalData>> getUnsyncedSales() {
    return (select(saleLocal)..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  Future<void> markSaleAsSynced(String saleId) {
    return (update(saleLocal)..where((tbl) => tbl.id.equals(saleId)))
        .write(const SaleLocalCompanion(isSynced: Value(true)));
  }
  
  Future<List<SaleDetailLocalData>> getDetailsForSale(String saleId) {
    return (select(saleDetailLocal)..where((tbl) => tbl.saleId.equals(saleId))).get();
  }
}

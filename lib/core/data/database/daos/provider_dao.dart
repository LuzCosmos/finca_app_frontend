import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/tables/provider_local.dart';

part 'provider_dao.g.dart';

@DriftAccessor(tables: [ProviderLocal])
class ProviderDao extends DatabaseAccessor<AppDatabase> with _$ProviderDaoMixin {
  ProviderDao(AppDatabase db) : super(db);

  Future<void> insertOrUpdateProvider(ProviderLocalCompanion provider) {
    return into(providerLocal).insertOnConflictUpdate(provider);
  }
  
  Future<List<ProviderLocalData>> getAllProviders() => select(providerLocal).get();

  Future<List<ProviderLocalData>> getProvidersByType(String type) {
    return (select(providerLocal)..where((tbl) => tbl.type.equals(type))).get();
  }
}

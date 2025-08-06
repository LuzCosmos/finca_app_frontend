import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/tables/brand_local.dart';

part 'package:finca_app_frontend/core/data/database/daos/brand_dao.g.dart';

@DriftAccessor(tables: [BrandLocal])
class BrandDao extends DatabaseAccessor<AppDatabase> with _$BrandDaoMixin {
  BrandDao(AppDatabase db) : super(db);

  Future<int> insert(BrandLocalCompanion entity) =>
      into(brandLocal).insert(entity);

  Future<List<Brand>> getAll(String idTentant) {
    return (select(brandLocal)
          ..where((t) => t.idTenant.equals(idTentant))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> markAsSynced(String id) async {
    await (update(brandLocal)..where(
      (t) => t.id.equals(id),
    )).write(BrandLocalCompanion(isSynced: Value(true))); // 👈 sin const
  }

  Future<int> deleteBrand(String id) {
    return (delete(brandLocal)..where((t) => t.id.equals(id))).go();
  }
}

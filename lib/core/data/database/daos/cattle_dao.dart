import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/tables/cattle_local.dart';

part 'cattle_dao.g.dart';

@DriftAccessor(tables: [CattleLocal])
class CattleDao extends DatabaseAccessor<AppDatabase> with _$CattleDaoMixin {
  CattleDao(AppDatabase db) : super(db);

  Future<void> insertOrUpdateCattle(CattleLocalCompanion cattle) {
    return into(cattleLocal).insertOnConflictUpdate(cattle);
  }
  
  Future<List<CattleLocalData>> getAllCattle() => select(cattleLocal).get();

  Future<CattleLocalData?> getCattleById(String id) {
     return (select(cattleLocal)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<CattleLocalData?> getCattleByNumber(String number) {
     return (select(cattleLocal)..where((tbl) => tbl.number.equals(number))).getSingleOrNull();
  }
  
  Future<List<CattleLocalData>> getActiveCattle() {
    return (select(cattleLocal)..where((tbl) => tbl.status.equals('ACTIVE'))).get();
  }
}

import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database//app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database//tables/massive_event_local.dart';
import 'package:finca_app_frontend/core/data/database//tables/simple_event_local.dart';
part 'massive_event_dao.g.dart';

@DriftAccessor(tables: [MassiveEventLocal, SimpleEventLocal])
class MassiveEventDao extends DatabaseAccessor<AppDatabase>
    with _$MassiveEventDaoMixin {
  MassiveEventDao(AppDatabase db) : super(db);

  Future<int> insert(MassiveEventLocalCompanion entity) =>
      into(massiveEventLocal).insert(entity);

  Future<List<MassiveEvent>> getAll() => select(massiveEventLocal).get();

  Future<List<MassiveEvent>> getByStatus(String status) {
    return (select(massiveEventLocal)
      ..where((t) => t.status.equals(status))).get();
  }

  Future<List<MassiveEvent>> getAllUnsynced() {
    return (select(massiveEventLocal)
      ..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  Future<int> updateMassiveEvent(String id, MassiveEventLocalCompanion entity) {
    return (update(massiveEventLocal)
      ..where((t) => t.id.equals(id))).write(entity);
  }

  Future<int> deleteMassiveEvent(String id) {
    return (delete(massiveEventLocal)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markAsSynced(String id) async {
    await (update(massiveEventLocal)..where(
      (t) => t.id.equals(id),
    )).write(MassiveEventLocalCompanion(isSynced: Value(true)));
  }
}

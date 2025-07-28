import 'package:drift/drift.dart';
import '../app_database_mobile.dart';
import '../tables/simple_event_local.dart';

part 'simple_event_dao.g.dart';

@DriftAccessor(tables: [SimpleEventLocal])
class SimpleEventDao extends DatabaseAccessor<AppDatabase>
    with _$SimpleEventDaoMixin {
  SimpleEventDao(AppDatabase db) : super(db);

  Future<int> insert(SimpleEventLocalCompanion entity) =>
      into(simpleEventLocal).insert(entity);

  Future<List<SimpleEvent>> getAll() {
    return select(simpleEventLocal).get();
  }

  Future<List<SimpleEvent>> getAllUnsynced() {
    return (select(simpleEventLocal)
      ..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  Future<List<SimpleEvent>> getByidMassiveEvent(String idMassiveEvent) {
    return (select(simpleEventLocal)
      ..where((t) => t.idMassiveEvent.equals(idMassiveEvent))).get();
  }

  Future<int> deleteSimpleEvent(String id) {
    return (delete(simpleEventLocal)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markAsSynced(String id) async {
    await (update(simpleEventLocal)..where(
      (t) => t.id.equals(id),
    )).write(SimpleEventLocalCompanion(isSynced: Value(true)));
  }
}

import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/tables/animal_simple_event_local.dart';

part 'animal_simple_event_dao.g.dart';

@DriftAccessor(tables: [AnimalSimpleEventLocal])
class AnimalSimpleEventDao extends DatabaseAccessor<AppDatabase>
    with _$AnimalSimpleEventDaoMixin {
  AnimalSimpleEventDao(AppDatabase db) : super(db);

  Future<int> insert(AnimalSimpleEventLocalCompanion entity) =>
      into(animalSimpleEventLocal).insert(entity);

  Future<List<AnimalSimpleEvent>> getPendingEvents(String idTentant) {
    return (select(animalSimpleEventLocal)..where(
      (t) => t.idTenant.equals(idTentant) & t.isSynced.equals(false),
    )).get();
  }

  Future<void> markAsSynced(String id) async {
    await (update(animalSimpleEventLocal)..where(
      (t) => t.id.equals(id),
    )).write(AnimalSimpleEventLocalCompanion(isSynced: Value(true)));
  }

  Future<void> markAsInvalid(String id) async {
    await (update(animalSimpleEventLocal)..where(
      (t) => t.id.equals(id),
    )).write(AnimalSimpleEventLocalCompanion(isInvalid: Value(true)));
  }
}

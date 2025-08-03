import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/daos/massive_event_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/simple_event_dao.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/data/mappers/massive_event_model_mapper.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';

class MassiveEventRepository {
  final MassiveEventDao _dao;
  final SimpleEventDao _simpleEventDao;

  MassiveEventRepository(this._dao, this._simpleEventDao);

  /*Future<int> create(MassiveEventLocalCompanion event) {
    return _dao.insert(event);
  }*/

  Future<void> insert(
    MassiveEventModel massiveEvent, {
    required bool isSynced,
  }) async {
    final companion = massiveEvent.toLocalCompanion(
      massiveEvent.idTenant!,
      isSynced: isSynced,
    );
    final simpleEventCompanions = massiveEvent.simpleEvents.map(
      (se) => se.toLocalCompanion(
        massiveEvent.id,
        massiveEvent.idTenant!,
        isSynced: isSynced,
      ),
    );

    await _dao.db.transaction(() async {
      await _dao.insert(companion);
      for (final simple in simpleEventCompanions) {
        await _simpleEventDao.insert(simple);
      }
    });
  }

  Future<void> createWithSimpleEvents({
    required MassiveEventLocalCompanion event,
    required List<SimpleEventLocalCompanion> simpleEvents,
  }) async {
    await _dao.db.transaction(() async {
      await _dao.insert(event);
      for (final se in simpleEvents) {
        await _dao.db.simpleEventDao.insert(se);
      }
    });
  }

  Future<List<MassiveEvent>> getAll() {
    return _dao.getAll();
  }

  Future<List<MassiveEvent>> getByStatus(String status) {
    return _dao.getByStatus(status);
  }

  Future<void> updateStatus(String id, String newStatus) {
    return _dao.updateMassiveEvent(
      id,
      MassiveEventLocalCompanion(status: Value(newStatus)),
    );
  }

  Future<void> delete(String id) {
    return _dao.deleteMassiveEvent(id);
  }

  Future<void> markAsSynced(String id) {
    return _dao.markAsSynced(id);
  }
}

import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/daos/massive_event_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/simple_event_dao.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
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
      createdBy: massiveEvent.createdBy,
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

  Future<MassiveEvent?> getById(String id) => _dao.getById(id);

  Future<List<MassiveEvent>> getByStatus(String status) {
    return _dao.getByStatus(status);
  }

  Future<void> updateStatus(String id, String newStatus) {
    return _dao.updateMassiveEvent(
      id,
      MassiveEventLocalCompanion(status: Value(newStatus)),
    );
  }

  Future<void> updateName(String id, String name) {
    return _dao.updateMassiveEvent(
      id,
      MassiveEventLocalCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(String id) {
    return _dao.deleteMassiveEvent(id);
  }

  Future<void> markAsSynced(String id) {
    return _dao.markAsSynced(id);
  }

  /// Sustituye un masivo local (y sus simples) por la respuesta del servidor,
  /// manteniendo coherencia en filas de animal_simple_event.
  Future<void> replaceLocalMassiveWithServerResponse({
    required String oldLocalMassiveId,
    required MassiveEventModel savedFromServer,
    required bool isSynced,
  }) async {
    final animalDao = _dao.db.animalSimpleEventDao;
    final oldRows = await _simpleEventDao.getByidMassiveEvent(oldLocalMassiveId);
    final newSimples = List<SimpleEventModel>.from(savedFromServer.simpleEvents);
    if (oldRows.length != newSimples.length) {
      throw StateError(
        'replaceLocalMassiveWithServerResponse: conteo simples local (${oldRows.length}) '
        '!= servidor (${newSimples.length})',
      );
    }
    int cmpSimple(SimpleEvent a, SimpleEvent b) {
      final t = a.type.compareTo(b.type);
      if (t != 0) return t;
      final ca = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final cb = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return ca.compareTo(cb);
    }

    int cmpModel(SimpleEventModel a, SimpleEventModel b) {
      final t = a.type.name.compareTo(b.type.name);
      if (t != 0) return t;
      return a.createdAt.compareTo(b.createdAt);
    }

    final oldOrdered = [...oldRows]..sort(cmpSimple);
    newSimples.sort(cmpModel);
    final simpleIdMap = <String, String>{};
    for (var i = 0; i < oldOrdered.length; i++) {
      simpleIdMap[oldOrdered[i].id] = newSimples[i].id;
    }

    await _dao.db.transaction(() async {
      for (final e in simpleIdMap.entries) {
        await animalDao.remapSimpleEventId(e.key, e.value);
      }
      await animalDao.remapMassiveEventId(
        oldLocalMassiveId,
        savedFromServer.id,
      );
      for (final r in oldOrdered) {
        await _simpleEventDao.deleteSimpleEvent(r.id);
      }
      await _dao.deleteMassiveEvent(oldLocalMassiveId);
      await insert(savedFromServer, isSynced: isSynced);
    });
  }
}

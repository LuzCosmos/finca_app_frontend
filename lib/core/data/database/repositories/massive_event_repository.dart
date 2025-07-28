import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/daos/massive_event_dao.dart';
import 'package:drift/drift.dart';

class MassiveEventRepository {
  final MassiveEventDao _dao;

  MassiveEventRepository(this._dao);

  Future<int> create(MassiveEventLocalCompanion event) {
    return _dao.insert(event);
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

import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/daos/simple_event_dao.dart';

class SimpleEventRepository {
  final SimpleEventDao _dao;

  SimpleEventRepository(this._dao);

  /// Crear un nuevo simple event asociado a un massive event
  Future<int> create(SimpleEventLocalCompanion event) {
    return _dao.insert(event);
  }

  Future<List<SimpleEvent>> getAll() {
    return _dao.getAll();
  }

  Future<List<SimpleEvent>> getAllUnsynced() {
    return _dao.getAllUnsynced();
  }

  /// Obtener todos los simple events asociados a un massive event
  Future<List<SimpleEvent>> getByidMassiveEvent(String idMassiveEvent) {
    return _dao.getByidMassiveEvent(idMassiveEvent);
  }

  /// Eliminar un simple event específico
  Future<void> delete(String id) {
    return _dao.deleteSimpleEvent(id);
  }

  Future<void> markAsSynced(String id) {
    return _dao.markAsSynced(id);
  }
}

import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/daos/animal_simple_event_dao.dart';

class AnimalSimpleEventRepository {
  final AnimalSimpleEventDao _dao;

  AnimalSimpleEventRepository(this._dao);

  Future<int> create(AnimalSimpleEventLocalCompanion event) {
    return _dao.insert(event);
  }

  Future<List<AnimalSimpleEvent>> getPendingEvents(String idTentant) {
    return _dao.getPendingEvents(idTentant);
  }

  Future<void> markSynced(String id) {
    return _dao.markAsSynced(id);
  }

  Future<void> markInvalid(String id) {
    return _dao.markAsInvalid(id);
  }
}

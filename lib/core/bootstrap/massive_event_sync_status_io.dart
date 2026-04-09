import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';

/// Devuelve true si el evento masivo existe en SQLite y aún no está sincronizado.
Future<bool> isMassiveEventPendingSync(String id) async {
  final db = DatabaseProvider.database;
  final repo = MassiveEventRepository(db.massiveEventDao, db.simpleEventDao);
  final row = await repo.getById(id);
  return row != null && row.isSynced == false;
}

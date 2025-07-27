import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_config.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';

extension ToCompanion on SimpleEventConfig {
  SimpleEventLocalCompanion toLocalCompanion(
    String massiveEventId,
    String idTenant,
  ) {
    return SimpleEventLocalCompanion.insert(
      id: id, // usa el mismo UUID
      idTenant: idTenant,
      idMassiveEvent: massiveEventId,
      type: type.name,
      dataJson: dataJson != null ? Value(dataJson) : const Value(null),
      isSynced: const Value(false),
      createdAt: Value(createdAt),
    );
  }
}

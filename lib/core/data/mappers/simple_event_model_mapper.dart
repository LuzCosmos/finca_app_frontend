import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';

extension ToCompanion on SimpleEventModel {
  SimpleEventLocalCompanion toLocalCompanion(
    String idMassiveEvent,
    String idTenant, {
    bool isSynced = false,
  }) {
    return SimpleEventLocalCompanion.insert(
      id: id, // usa el mismo UUID
      idTenant: idTenant,
      idMassiveEvent: idMassiveEvent,
      type: type.name,
      data: data != null ? Value(data) : const Value(null),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }
}

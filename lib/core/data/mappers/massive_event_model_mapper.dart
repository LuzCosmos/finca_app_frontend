import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

extension ToCompanion on MassiveEventModel {
  MassiveEventLocalCompanion toLocalCompanion(
    String idTenant, {
    bool isSynced = false,
  }) {
    return MassiveEventLocalCompanion.insert(
      id: id,
      idTenant: idTenant,
      eventDate: eventDate,
      status: Value(status),
      isSynced: Value(isSynced),
    );
  }
}

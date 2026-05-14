import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

extension ToCompanion on MassiveEventModel {
  MassiveEventLocalCompanion toLocalCompanion(
    String idTenant, {
    bool isSynced = false,
    String? createdBy,
  }) {
    return MassiveEventLocalCompanion.insert(
      id: id,
      idTenant: idTenant,
      eventDate: eventDate,
      name: name != null ? Value(name!) : const Value.absent(),
      status: Value(status),
      createdBy: createdBy != null ? Value(createdBy) : const Value.absent(),
      linkedToPurchaseReception: Value(linkedToPurchaseReception),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }
}

import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';

class SimpleEventService {
  final SimpleEventRepository repo;

  SimpleEventService({required this.repo});

  Future<void> createSimpleEvent({
    required String idTenant,
    required String idMassiveEvent,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    final uuid = const Uuid().v4();
    final entity = SimpleEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      idMassiveEvent: idMassiveEvent,
      type: type,
      data: Value(data != null ? jsonEncode(data) : null),
      isSynced: const Value(false),
    );
    await repo.create(entity);
  }

  Future<List<SimpleEvent>> getByidMassiveEvent(String id) async {
    return await repo.getByidMassiveEvent(id);
  }
}

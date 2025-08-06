import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';

class AnimalSimpleEventService {
  final AnimalSimpleEventRepository repo;

  AnimalSimpleEventService({required this.repo});

  Future<void> createAnimalSimpleEvent({
    required String idTenant,
    required String animalNumber,
    required String type,
    required Map<String, dynamic> data,
    required String appliedBy,
    String? idMassiveEvent,
  }) async {
    final uuid = const Uuid().v4();
    final entity = AnimalSimpleEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      animalNumber: animalNumber,
      type: type,
      data: Value(jsonEncode(data)),
      appliedAt: DateTime.now(),
      appliedBy: Value(appliedBy),
      recordedInMassiveEvent: Value(idMassiveEvent),
      isSynced: const Value(false),
    );

    await repo.create(entity);
  }
}

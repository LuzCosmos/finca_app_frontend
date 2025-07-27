import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/repositories/animal_simple_event_repository.dart';

class AnimalSimpleEventService {
  final AnimalSimpleEventRepository repo;
  final String baseUrl;
  final Future<String> Function() getToken;
  final Future<bool> Function() hasNetwork;

  AnimalSimpleEventService({
    required this.repo,
    required this.baseUrl,
    required this.getToken,
    required this.hasNetwork,
  });

  Future<void> createAnimalSimpleEvent({
    required String idTenant,
    required String animalNumber,
    required String type,
    required Map<String, dynamic> data,
    required String appliedBy,
    String? massiveEventId,
  }) async {
    final uuid = const Uuid().v4();
    final entity = AnimalSimpleEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      animalNumber: animalNumber,
      type: type,
      dataJson: Value(jsonEncode(data)),
      appliedAt: DateTime.now(),
      appliedBy: Value(appliedBy),
      recordedInMassiveEvent: Value(massiveEventId),
      isSynced: const Value(false),
    );

    // 1️⃣ guardar siempre local
    await repo.create(entity);

    // 2️⃣ intentar enviar si hay red
    if (await hasNetwork()) {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl/simple-events/sync'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "simpleEvents": [
            {
              "id": entity.id.value,
              "idTenant": idTenant,
              "massiveEventServerId": massiveEventId,
              "type": type,
              "dataJson": jsonEncode(data),
              "appliedAt": DateTime.now().toIso8601String(),
              "appliedBy": appliedBy,
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markSynced(entity.id.value);
      }
    }
  }
}

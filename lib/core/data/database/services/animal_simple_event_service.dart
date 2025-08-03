import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimalSimpleEventService {
  final AnimalSimpleEventRepository repo;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Future<String?> Function() getToken = SessionService.getToken;
  final Future<bool> Function() hasNetwork;

  AnimalSimpleEventService({required this.repo, required this.hasNetwork});

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

    // guardar siempre local
    await repo.create(entity);

    // intentar enviar si hay red
    /*if (await hasNetwork()) {
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
              "massiveEventServerId": idMassiveEvent,
              "type": type,
              "data": jsonEncode(data),
              "appliedAt": DateTime.now().toIso8601String(),
              "appliedBy": appliedBy,
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markSynced(entity.id.value);
      }
    }*/
  }
}

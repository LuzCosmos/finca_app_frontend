import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SimpleEventService {
  final SimpleEventRepository repo;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Future<String?> Function() getToken = SessionService.getToken;
  //final Future<bool> Function() hasNetwork;

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
              "data": data != null ? jsonEncode(data) : null,
              "createdAt": DateTime.now().toIso8601String(),
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markAsSynced(entity.id.value);
      }
    }*/
  }

  Future<List<SimpleEvent>> getByidMassiveEvent(String id) async {
    return await repo.getByidMassiveEvent(id);
  }
}

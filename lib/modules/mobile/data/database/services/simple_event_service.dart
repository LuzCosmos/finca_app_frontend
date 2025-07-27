import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/repositories/simple_event_repository.dart';

class SimpleEventService {
  final SimpleEventRepository repo;
  final String baseUrl;
  final Future<String> Function() getToken;
  final Future<bool> Function() hasNetwork;

  SimpleEventService({
    required this.repo,
    required this.baseUrl,
    required this.getToken,
    required this.hasNetwork,
  });

  Future<void> createSimpleEvent({
    required String idTenant,
    required String massiveEventId,
    required String type,
    Map<String, dynamic>? dataJson,
  }) async {
    final uuid = const Uuid().v4();
    final entity = SimpleEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      idMassiveEvent: massiveEventId,
      type: type,
      dataJson: Value(dataJson != null ? jsonEncode(dataJson) : null),
      isSynced: const Value(false),
    );

    await repo.create(entity);

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
              "dataJson": dataJson != null ? jsonEncode(dataJson) : null,
              "createdAt": DateTime.now().toIso8601String(),
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markAsSynced(entity.id.value);
      }
    }
  }

  Future<List<SimpleEvent>> getByMassiveEventId(String id) async {
    return await repo.getByMassiveEventId(id);
  }
}

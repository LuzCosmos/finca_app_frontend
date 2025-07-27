import 'dart:convert';
import 'package:finca_app_frontend/modules/mobile/data/database/services/simple_event_service.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/repositories/massive_event_repository.dart';

class MassiveEventService {
  final MassiveEventRepository repo;
  final SimpleEventService simpleEventService;
  final String baseUrl;
  final Future<String> Function() getToken;
  final Future<bool> Function() hasNetwork;

  MassiveEventService({
    required this.repo,
    required this.baseUrl,
    required this.getToken,
    required this.hasNetwork,
    required this.simpleEventService,
  });

  Future<void> createMassiveEvent({
    required String idTenant,
    required DateTime eventDate,
    required String createdBy,
  }) async {
    final uuid = const Uuid().v4();
    final entity = MassiveEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      eventDate: eventDate,
      status: Value('open'),
      createdBy: Value(createdBy),
      createdAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );

    await repo.create(entity);

    if (await hasNetwork()) {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl/massive-events/sync'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "massiveEvents": [
            {
              "id": entity.id.value,
              "idTenant": idTenant,
              "eventDate": eventDate.toIso8601String(),
              "status": 'open',
              "createdBy": createdBy,
              "createdAt": DateTime.now().toIso8601String(),
              "simpleEvents": [],
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markAsSynced(entity.id.value);
      }
    }
  }
}

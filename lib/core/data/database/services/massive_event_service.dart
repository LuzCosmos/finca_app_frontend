import 'dart:convert';
import 'package:finca_app_frontend/core/data/database/services/simple_event_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/data/mappers/massive_event_model_mapper.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MassiveEventService {
  final MassiveEventRepository repo;
  final SimpleEventService simpleEventService;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Future<String?> Function() getToken = SessionService.getToken;
  //final Future<bool> Function() hasNetwork;

  MassiveEventService({
    required this.repo,
    //required this.hasNetwork,
    required this.simpleEventService,
  });

  Future<void> createMassiveEvent({
    required String idTenant,
    required DateTime eventDate,
    required String createdBy,
    List<SimpleEventModel>? simpleEvents,
  }) async {
    final uuid = const Uuid().v4();
    final eventCompanion = MassiveEventLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      eventDate: eventDate,
      status: Value('open'),
      createdBy: Value(createdBy),
      createdAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );

    final simpleEventCompanions =
        simpleEvents?.map((e) {
          return e.toLocalCompanion(uuid, idTenant);
        }).toList() ??
        [];

    await repo.createWithSimpleEvents(
      event: eventCompanion,
      simpleEvents: simpleEventCompanions,
    );

    /*if (await hasNetwork()) {
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
              "id": uuid,
              "idTenant": idTenant,
              "eventDate": eventDate.toIso8601String(),
              "status": 'open',
              "createdBy": createdBy,
              "createdAt": DateTime.now().toIso8601String(),
              "simpleEvents":
                  simpleEvents
                      ?.map(
                        (e) => {
                          "id": e.id,
                          "idTenant": idTenant,
                          "massiveEventServerId": uuid,
                          "type": e.type.name,
                          "data": e.data,
                          "createdAt": DateTime.now().toIso8601String(),
                        },
                      )
                      .toList() ??
                  [],
            },
          ],
        }),
      );

      if (res.statusCode == 200) {
        await repo.markAsSynced(uuid);
        for (final se in simpleEventCompanions) {
          await simpleEventService.repo.markAsSynced(se.id.value);
        }
      }
    }*/
  }

  /*Future<void> createMassiveEvent({
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
  }*/

  /*Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  }) async {
    final eventLocal = massiveEvent.toLocalCompanion(idTenant);
    final simpleEventsLocal =
        massiveEvent.simpleEvents
            .map((e) => e.toLocalCompanion(massiveEvent.id, idTenant))
            .toList();

    final saved = await repo.createWithSimpleEvents(
      eventLocal,
      simpleEventsLocal,
    );

    return saved;
  }*/
}

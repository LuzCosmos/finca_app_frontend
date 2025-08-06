import 'package:finca_app_frontend/core/data/database/services/simple_event_service.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';

class MassiveEventService {
  final MassiveEventRepository repo;
  final SimpleEventService simpleEventService;

  MassiveEventService({required this.repo, required this.simpleEventService});

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
  }
}

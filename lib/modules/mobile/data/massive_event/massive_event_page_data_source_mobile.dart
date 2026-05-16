import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/mappers/simple_event_model_mapper.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/network_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_session_load.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:uuid/uuid.dart';

bool _isConnectionFailure(Object e) {
  return e is ApiException &&
      e.code == ApiExceptionCode.serverConnectionError.name;
}

int _cmpDriftSimple(SimpleEvent a, SimpleEvent b) {
  final t = a.type.compareTo(b.type);
  if (t != 0) return t;
  final ca = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final cb = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  return ca.compareTo(cb);
}

int _cmpSimpleModel(SimpleEventModel a, SimpleEventModel b) {
  final t = a.type.name.compareTo(b.type.name);
  if (t != 0) return t;
  return a.createdAt.compareTo(b.createdAt);
}

SimpleEventModel _simpleModelFromDrift(SimpleEvent row) {
  return SimpleEventModel(
    id: row.id,
    idTenant: row.idTenant,
    idMassiveEvent: row.idMassiveEvent,
    type: SimpleEventType.values.firstWhere((e) => e.name == row.type),
    data: row.data,
    createdAt: row.createdAt ?? DateTime.now(),
    isActive: row.isActive,
  );
}

MassiveEventModel _massiveModelFromDrift(MassiveEvent row, List<SimpleEventModel> simples) {
  return MassiveEventModel(
    id: row.id,
    idTenant: row.idTenant,
    name: row.name,
    createdBy: row.createdBy,
    eventDate: row.eventDate,
    simpleEvents: simples,
    status: row.status,
    createdAt: row.createdAt ?? DateTime.now(),
    updatedAt: row.updatedAt ?? DateTime.now(),
    linkedToPurchaseReception: row.linkedToPurchaseReception,
  );
}

AnimalSimpleEventModel _animalModelFromLocalDrift(AnimalSimpleEvent r, String idMassive) {
  return AnimalSimpleEventModel(
    id: r.id,
    idTenant: r.idTenant,
    idAnimal: null,
    animalNumber: r.animalNumber,
    type: SimpleEventType.values.firstWhere((e) => e.name == r.type),
    data: r.data,
    appliedAt: r.appliedAt,
    appliedBy: r.appliedBy,
    idMassiveEvent: r.idMassiveEvent ?? idMassive,
    idSimpleEvent: r.idSimpleEvent ?? '',
  );
}

/// Tras subir un masivo pendiente: modelo servidor y mapa id simple local → servidor.
class _PushMassiveOutcome {
  final MassiveEventModel savedMassive;
  final Map<String, String> simpleIdByOld;

  _PushMassiveOutcome({
    required this.savedMassive,
    required this.simpleIdByOld,
  });
}

class MassiveEventPageDataSourceMobile implements IMassiveEventPageDataSource {
  final SimpleEventRepository repo;
  final MassiveEventRepository _massiveEventRepository;
  final AnimalSimpleEventRepository _animalSimpleEventRepository;
  final NetworkService _networkService;

  MassiveEventPageDataSourceMobile(
    this.repo,
    this._massiveEventRepository,
    this._animalSimpleEventRepository, {
    NetworkService? networkService,
  }) : _networkService = networkService ?? NetworkService();

  /// Sube masivo + simples actuales en BD y reemplaza filas locales por la respuesta.
  Future<_PushMassiveOutcome?> _pushUnsyncedMassiveBranch(
    String localMassiveId,
  ) async {
    final row = await _massiveEventRepository.getById(localMassiveId);
    if (row == null) {
      throw StateError('No existe el evento masivo $localMassiveId');
    }
    if (row.isSynced) return null;

    final dbRows = await repo.getByidMassiveEvent(localMassiveId);
    if (dbRows.isEmpty) {
      throw StateError('El masivo no tiene simple events en el dispositivo');
    }
    final models = dbRows.map(_simpleModelFromDrift).toList();
    final pushModel = _massiveModelFromDrift(row, models);
    final saved = await MassiveEventApiService.createMassiveEvent(
      massiveEvent: pushModel,
      idTenant: row.idTenant,
    );

    final oldOrdered = [...dbRows]..sort(_cmpDriftSimple);
    final newOrdered = [...saved.simpleEvents]..sort(_cmpSimpleModel);
    if (oldOrdered.length != newOrdered.length) {
      throw StateError(
        'Respuesta del servidor: número de simple events distinto al local',
      );
    }
    final simpleIdByOld = <String, String>{};
    for (var i = 0; i < oldOrdered.length; i++) {
      simpleIdByOld[oldOrdered[i].id] = newOrdered[i].id;
    }

    await _massiveEventRepository.replaceLocalMassiveWithServerResponse(
      oldLocalMassiveId: localMassiveId,
      savedFromServer: saved,
      isSynced: true,
    );
    return _PushMassiveOutcome(
      savedMassive: saved,
      simpleIdByOld: simpleIdByOld,
    );
  }

  @override
  Future<MassiveEventModel> saveMassiveEvent({
    required MassiveEventModel massiveEvent,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    final idUser = await SessionService.getIdUser();
    if (idTenant == null || idUser == null) {
      throw StateError('Sesión incompleta: falta idTenant o idUser');
    }
    final enriched = massiveEvent.copyWith(
      idTenant: idTenant,
      createdBy: idUser,
    );

    if (await _networkService.hasNetwork()) {
      try {
        final saved = await MassiveEventApiService.createMassiveEvent(
          massiveEvent: enriched,
          idTenant: idTenant,
        );
        for (final s in saved.simpleEvents) {
          s.idMassiveEvent = saved.id;
        }
        await _massiveEventRepository.insert(saved, isSynced: true);
        return saved;
      } catch (e) {
        if (!_isConnectionFailure(e)) rethrow;
      }
    }

    await _massiveEventRepository.insert(enriched, isSynced: false);
    for (final s in enriched.simpleEvents) {
      s.idMassiveEvent = enriched.id;
    }
    return enriched;
  }

  @override
  Future<SaveSimpleEventResult> saveSimpleEvent({
    required SimpleEventModel simpleEvent,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    if (idTenant == null) {
      throw StateError('Sesión incompleta: falta idTenant');
    }
    final idMe = simpleEvent.idMassiveEvent;
    if (idMe == null) {
      throw StateError('Falta idMassiveEvent para el simple event');
    }
    simpleEvent.idTenant = idTenant;

    Future<SaveSimpleEventResult> saveNewSimpleOffline() async {
      await repo.create(
        simpleEvent.toLocalCompanion(idMe, idTenant, isSynced: false),
      );
      return SaveSimpleEventResult(saved: simpleEvent);
    }

    if (!await _networkService.hasNetwork()) {
      return saveNewSimpleOffline();
    }

    try {
      final massiveRow = await _massiveEventRepository.getById(idMe);
      if (massiveRow == null) {
        throw StateError('No existe el evento masivo $idMe');
      }

      if (!massiveRow.isSynced) {
        final inDb = await repo.getByidMassiveEvent(idMe);
        final idsInDb = inDb.map((r) => r.id).toSet();
        if (!idsInDb.contains(simpleEvent.id)) {
          await repo.create(
            simpleEvent.toLocalCompanion(idMe, idTenant, isSynced: false),
          );
        }
        final allRows = await repo.getByidMassiveEvent(idMe);
        final dbModels = allRows.map(_simpleModelFromDrift).toList();
        final pushModel = _massiveModelFromDrift(massiveRow, dbModels);
        final saved = await MassiveEventApiService.createMassiveEvent(
          massiveEvent: pushModel,
          idTenant: idTenant,
        );
        await _massiveEventRepository.replaceLocalMassiveWithServerResponse(
          oldLocalMassiveId: idMe,
          savedFromServer: saved,
          isSynced: true,
        );
        final sortedRows = [...allRows]..sort(_cmpDriftSimple);
        final sortedSaved = [...saved.simpleEvents]..sort(_cmpSimpleModel);
        final idx = sortedRows.indexWhere((r) => r.id == simpleEvent.id);
        final savedSimple =
            idx >= 0 && idx < sortedSaved.length
                ? sortedSaved[idx]
                : sortedSaved.last;
        return SaveSimpleEventResult(
          saved: savedSimple,
          newMassiveEventId: saved.id,
          remappedSimpleEvents: saved.simpleEvents,
        );
      }

      final saved = await MassiveEventApiService.createSimpleEvent(
        massiveEventServerId: idMe,
        simpleEvent: simpleEvent,
      );
      final massiveId = saved.idMassiveEvent ?? idMe;
      await repo.create(
        saved.toLocalCompanion(
          massiveId,
          idTenant,
          isSynced: true,
        ),
      );
      return SaveSimpleEventResult(saved: saved);
    } catch (e) {
      if (!_isConnectionFailure(e)) rethrow;
      return saveNewSimpleOffline();
    }
  }

  @override
  Future<BrandModel> saveBrand({required BrandModel brand}) async {
    final created = BrandApiService.createBrand(brand: brand);
    return created;
  }

  @override
  Future<List<BrandModel>> getAllBrands() {
    final brands = BrandApiService.getAllBrands();
    return brands;
  }

  @override
  Future<List<AnimalSimpleEventModel>> getAnimalSimpleEvents({
    required String idMassiveEvent,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SaveAnimalSimpleEventsResult> saveAnimalSimpleEvents({
    required List<AnimalSimpleEventModel> animalSimpleEvents,
    required String cattleNumber,
  }) async {
    final idTenant = await SessionService.getIdTenant();
    if (idTenant == null) {
      throw StateError('Sesión incompleta: falta idTenant');
    }
    final appliedBy = await SessionService.getIdUser();
    if (animalSimpleEvents.isEmpty) {
      return SaveAnimalSimpleEventsResult(animalSimpleEvents: const []);
    }

    if (await _networkService.hasNetwork()) {
      try {
        final mid = animalSimpleEvents.first.idMassiveEvent;
        final pushed = await _pushUnsyncedMassiveBranch(mid);
        var forApi =
            animalSimpleEvents
                .map((e) => e.copyWith(appliedBy: appliedBy))
                .toList();
        if (pushed != null) {
          forApi =
              forApi
                  .map((e) {
                    final ns = pushed.simpleIdByOld[e.idSimpleEvent];
                    return e.copyWith(
                      idMassiveEvent: pushed.savedMassive.id,
                      idSimpleEvent: ns ?? e.idSimpleEvent,
                    );
                  })
                  .toList();
        }
        final savedAnimals =
            await MassiveEventApiService.saveAnimalSimpleEvents(
              animalSimpleEvents: forApi,
              cattleNumber: cattleNumber,
            );
        return SaveAnimalSimpleEventsResult(
          animalSimpleEvents: savedAnimals,
          newMassiveEventId: pushed?.savedMassive.id,
          remappedSimpleEvents: pushed?.savedMassive.simpleEvents,
          syncedWithServer: true,
        );
      } catch (e) {
        if (!_isConnectionFailure(e)) rethrow;
      }
    }

    final out = <AnimalSimpleEventModel>[];
    for (final e in animalSimpleEvents) {
      final id = e.id ?? const Uuid().v4();
      var row = e.copyWith(id: id, idTenant: idTenant, appliedBy: appliedBy);
      await _animalSimpleEventRepository.create(
        AnimalSimpleEventLocalCompanion.insert(
          id: id,
          idTenant: idTenant,
          animalNumber: row.animalNumber,
          type: row.type.name,
          data: row.data != null ? Value(row.data!) : const Value.absent(),
          idMassiveEvent: Value(row.idMassiveEvent),
          idSimpleEvent: Value(row.idSimpleEvent),
          appliedAt: row.appliedAt,
          appliedBy: row.appliedBy != null ? Value(row.appliedBy!) : const Value.absent(),
          recordedInMassiveEvent: Value(row.idMassiveEvent),
          isSynced: const Value(false),
        ),
      );
      out.add(row);
    }
    return SaveAnimalSimpleEventsResult(
      animalSimpleEvents: out,
      syncedWithServer: false,
    );
  }

  @override
  Future<void> closeMassiveEvent({required String idMassiveEvent}) async {
    await MassiveEventApiService.closeMassiveEvent(
      idMassiveEvent: idMassiveEvent,
    );
  }

  @override
  Future<void> updateSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String endpoint,
  }) async {
    await MassiveEventApiService.updateSimpleEvent(
      simpleEvent: simpleEvent,
      endpoint: endpoint,
    );
  }

  @override
  Future<MassiveSessionLoadResult> loadMassiveEventSession({
    required String idMassiveEvent,
  }) async {
    if (await _networkService.hasNetwork()) {
      try {
        final massive = await MassiveEventApiService.getMassiveEventByIdHydratingSimpleEvents(
          idMassiveEvent: idMassiveEvent,
        );
        final appliedJson = await MassiveEventApiService.getAppliedAnimalsSession(
          idMassiveEvent: idMassiveEvent,
        );
        return massiveSessionFromAppliedAnimalsJson(massive, appliedJson);
      } catch (e) {
        if (!_isConnectionFailure(e)) rethrow;
      }
    }

    final row = await _massiveEventRepository.getById(idMassiveEvent);
    if (row == null) {
      throw StateError('No existe el evento masivo en el dispositivo');
    }
    final simpleRows = await repo.getByidMassiveEvent(idMassiveEvent);
    final simpleModels = simpleRows.map(_simpleModelFromDrift).toList();
    final massive = _massiveModelFromDrift(row, simpleModels);
    final animalRows = await _animalSimpleEventRepository.findByMassiveEventId(idMassiveEvent);
    final models = animalRows.map((r) => _animalModelFromLocalDrift(r, idMassiveEvent)).toList();
    final anyUnsynced = animalRows.any((r) => !r.isSynced);
    return massiveSessionFromAnimalModels(
      massive,
      models,
      const {},
      markRowsSynced: !anyUnsynced,
    );
  }
}

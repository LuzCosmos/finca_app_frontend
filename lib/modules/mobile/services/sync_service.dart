import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class SyncResult {
  final bool success;
  final String message;
  SyncResult({required this.success, required this.message});
}

/// Servicio encargado de sincronizar datos locales con el backend.
/// Orden secuencial:
/// 1. Brands → 2. MassiveEvents (incluyendo sus SimpleEvents) → 3. SimpleEvents (restantes) → 4. AnimalSimpleEvents
class SyncService {
  final AnimalSimpleEventRepository animalSimpleEventRepository;
  final BrandRepository brandRepository;
  final MassiveEventRepository massiveEventRepository;
  final SimpleEventRepository simpleEventRepository;
  final String baseUrl;
  final Future<String> Function() getToken;

  SyncService({
    required this.animalSimpleEventRepository,
    required this.brandRepository,
    required this.massiveEventRepository,
    required this.simpleEventRepository,
    required this.baseUrl,
    required this.getToken,
  });

  Future<SyncResult> _syncEntities<T>({
    required Future<List<T>> Function() fetchAll,
    required bool Function(T) isUnsynced,
    required Map<String, dynamic> Function(T) toJson,
    required Future<void> Function(String) markSynced,
    required String endpointKey,
    required String endpointPath,
  }) async {
    try {
      //final token = await getToken();
      final all = await fetchAll();
      final pending = all.where(isUnsynced).toList();
      if (pending.isEmpty) {
        return SyncResult(
          success: true,
          message: '✅ No hay pendientes para $endpointKey',
        );
      }
      final payload = pending.map(toJson).toList();
      final response = await _postWithRetry(
        Uri.parse('$baseUrl/$endpointPath'),
        {endpointKey: payload},
      );
      if (response.statusCode == 200) {
        for (var entity in pending) {
          final id = (entity as dynamic).id as String;
          await markSynced(id);
        }
        return SyncResult(
          success: true,
          message: '✅ $endpointKey sincronizados correctamente',
        );
      } else {
        return SyncResult(
          success: false,
          message:
              '❌ Error al sincronizar $endpointKey: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      return SyncResult(
        success: false,
        message: '❌ Excepción en $endpointKey: $e',
      );
    }
  }

  Future<SyncResult> syncBrands(String idTenant) async {
    return await _syncEntities<Brand>(
      fetchAll: () => brandRepository.getAll(idTenant),
      isUnsynced: (b) => b.isSynced == false,
      toJson:
          (b) => {
            "id": b.id,
            "idTenant": b.idTenant,
            "name": b.name,
            "image": b.imageBytes,
            "imageMimeType": b.imageMimeType,
            "createdAt": b.createdAt?.toIso8601String(),
          },
      markSynced: (id) => brandRepository.markAsSynced(id),
      endpointKey: 'brands',
      endpointPath: 'brands/sync',
    );
  }

  Future<SyncResult> syncMassiveEvents(String idTenant) async {
    try {
      //final token = await getToken();
      final allMassive = await massiveEventRepository.getAll();
      final unsyncedMassive =
          allMassive.where((m) => m.isSynced == false).toList();
      if (unsyncedMassive.isEmpty) {
        return SyncResult(
          success: true,
          message: '✅ No hay massive events pendientes',
        );
      }

      final allUnsyncedSimples = await simpleEventRepository.getAllUnsynced();
      final mapByMassive = <String, List<SimpleEvent>>{};
      for (var s in allUnsyncedSimples) {
        mapByMassive.putIfAbsent(s.idMassiveEvent, () => []).add(s);
      }

      final payload =
          unsyncedMassive.map((m) {
            final unsyncedSimple = mapByMassive[m.id] ?? [];
            final simpleEventsJson =
                unsyncedSimple
                    .map(
                      (s) => {
                        "id": s.id,
                        "idTenant": s.idTenant,
                        "type": s.type,
                        "data": s.data,
                        "createdAt": s.createdAt?.toIso8601String(),
                      },
                    )
                    .toList();
            return {
              "id": m.id,
              "idTenant": m.idTenant,
              "eventDate": m.eventDate.toIso8601String(),
              "status": m.status,
              "createdBy": m.createdBy,
              "createdAt": m.createdAt?.toIso8601String(),
              "simpleEvents": simpleEventsJson,
            };
          }).toList();

      final response = await _postWithRetry(
        Uri.parse('$baseUrl/massive-events/sync'),
        {"massiveEvents": payload},
      );

      if (response.statusCode == 200) {
        for (var m in unsyncedMassive) {
          await massiveEventRepository.markAsSynced(m.id);
          final relatedSimpleEvents = await simpleEventRepository
              .getByidMassiveEvent(m.id);
          for (var s in relatedSimpleEvents.where((s) => s.isSynced == false)) {
            await simpleEventRepository.markAsSynced(s.id);
          }
        }
        return SyncResult(
          success: true,
          message: '✅ MassiveEvents sincronizados correctamente',
        );
      } else {
        return SyncResult(
          success: false,
          message:
              '❌ Error al sincronizar massive events: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      return SyncResult(
        success: false,
        message: '❌ Excepción en massive events: $e',
      );
    }
  }

  Future<SyncResult> syncSimpleEvents(String idTenant) async {
    return await _syncEntities<SimpleEvent>(
      fetchAll: () => simpleEventRepository.getAll(),
      isUnsynced: (s) => s.isSynced == false,
      toJson:
          (s) => {
            "id": s.id,
            "idTenant": s.idTenant,
            "massiveEventServerId": s.idMassiveEvent,
            "type": s.type,
            "data": s.data,
            "createdAt": s.createdAt?.toIso8601String(),
          },
      markSynced: (id) => simpleEventRepository.markAsSynced(id),
      endpointKey: 'simpleEvents',
      endpointPath: 'simple-events/sync',
    );
  }

  Future<SyncResult> syncAnimalSimpleEvents(String idTenant) async {
    return await _syncEntities<AnimalSimpleEvent>(
      fetchAll: () => animalSimpleEventRepository.getPendingEvents(idTenant),
      isUnsynced: (a) => a.isSynced == false && a.isInvalid == false,
      toJson:
          (a) => {
            "id": a.id,
            "idTenant": a.idTenant,
            "massiveEventServerId": a.recordedInMassiveEvent,
            "type": a.type,
            "data": a.data,
            "appliedAt": a.appliedAt.toIso8601String(),
            "appliedBy": a.appliedBy,
          },
      markSynced: (id) => animalSimpleEventRepository.markSynced(id),
      endpointKey: 'cattle',
      endpointPath: 'cattle/sync-cattle-simple-event',
    );
  }

  /// ⚡ secuential order :
  /// 1. Brands → 2. MassiveEvents (including its SimpleEvents) → 3. SimpleEvents (rest) → 4. AnimalSimpleEvents
  Future<List<SyncResult>> syncAllInOrder(String idTenant) async {
    final results = <SyncResult>[];

    results.add(await syncBrands(idTenant));
    results.add(await syncMassiveEvents(idTenant));
    results.add(await syncSimpleEvents(idTenant));
    results.add(await syncAnimalSimpleEvents(idTenant));

    return results;
  }

  Future<int> getPendingCount(String idTenant) async {
    final animalPending =
        (await animalSimpleEventRepository.getPendingEvents(idTenant)).length;
    final brandPending =
        (await brandRepository.getAll(
          idTenant,
        )).where((b) => b.isSynced == false).length;
    final massivePending =
        (await massiveEventRepository.getAll())
            .where((m) => m.isSynced == false)
            .length;
    final simplePending =
        (await simpleEventRepository.getAll())
            .where((s) => s.isSynced == false)
            .length;
    return animalPending + brandPending + massivePending + simplePending;
  }

  Future<http.Response> _postWithRetry(
    Uri url,
    Map<String, dynamic> payload, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 2),
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await BasicApiService.authorizedPost(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          // ✅ Éxito, salimos inmediatamente
          return response;
        } else {
          debugPrint(
            '⚠️ POST intento $attempt falló: ${response.statusCode} ${response.body}',
          );
        }
      } catch (e) {
        debugPrint('⚠️ POST intento $attempt lanzó excepción: $e');
      }

      // Si no fue el último intento, esperamos antes de reintentar
      if (attempt < maxRetries - 1) {
        final delay = Duration(
          seconds: initialDelay.inSeconds * (1 << attempt),
        );
        debugPrint('🔄 Reintentando en ${delay.inSeconds} segundos...');
        await Future.delayed(delay);
      }
    }

    // ❌ Si llegamos aquí, agotamos todos los intentos
    throw Exception(
      '❌ Se alcanzó el número máximo de reintentos ($maxRetries) para $url',
    );
  }
}

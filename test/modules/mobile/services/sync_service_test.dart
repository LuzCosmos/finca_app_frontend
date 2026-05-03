import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

// Bajo prueba:
// - lib/modules/mobile/services/sync_service.dart

class MockAnimalSimpleEventRepository extends Mock
    implements AnimalSimpleEventRepository {}

class MockBrandRepository extends Mock implements BrandRepository {}

class MockMassiveEventRepository extends Mock
    implements MassiveEventRepository {}

class MockSimpleEventRepository extends Mock implements SimpleEventRepository {}

String _jwtExp(int offsetSeconds) {
  final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + offsetSeconds;
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': exp})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

Future<void> _hydrateAuth() async {
  await SessionService.saveSession(
    token: _jwtExp(7200),
    permissions: {},
    idTenant: 'tid',
    idUser: 'u',
    refreshToken: 'rt',
  );
  BasicApiService.setBaseUrl('https://sync.test/api/v1');
}

SyncService _service({
  required MockAnimalSimpleEventRepository animalRepo,
  required MockBrandRepository brandRepo,
  required MockMassiveEventRepository massiveRepo,
  required MockSimpleEventRepository simpleRepo,
  int maxRetries = 2,
}) {
  return SyncService(
    animalSimpleEventRepository: animalRepo,
    brandRepository: brandRepo,
    massiveEventRepository: massiveRepo,
    simpleEventRepository: simpleRepo,
    baseUrl: 'https://sync.test/api/v1',
    getToken: () async => (await SessionService.getToken())!,
    retryInitialDelay: Duration.zero,
    maxRetries: maxRetries,
  );
}

Brand _brand({bool synced = false, String id = 'b1'}) {
  return Brand(
    id: id,
    idTenant: 'tid',
    name: 'Brand',
    imageBytes: Uint8List.fromList([1, 2]),
    imageMimeType: 'image/png',
    imageFileName: 'f.png',
    isSynced: synced,
    createdAt: DateTime(2024, 1, 2),
  );
}

MassiveEvent _massive({bool synced = false, String id = 'm1'}) {
  return MassiveEvent(
    id: id,
    idTenant: 'tid',
    name: 'ME',
    eventDate: DateTime(2024, 1, 1),
    status: 'open',
    createdBy: 'u1',
    isSynced: synced,
    createdAt: DateTime(2024, 1, 1),
  );
}

SimpleEvent _simple({
  bool synced = false,
  String id = 's1',
  String massiveId = 'm1',
}) {
  return SimpleEvent(
    id: id,
    idTenant: 'tid',
    idMassiveEvent: massiveId,
    type: 'weight',
    data: '{"w":1}',
    isActive: true,
    isSynced: synced,
    createdAt: DateTime(2024, 1, 3),
  );
}

AnimalSimpleEvent _animal({
  bool synced = false,
  bool invalid = false,
  String id = 'a1',
}) {
  return AnimalSimpleEvent(
    id: id,
    idTenant: 'tid',
    animalNumber: 'N1',
    type: 't',
    data: '{}',
    appliedAt: DateTime(2024, 1, 4),
    appliedBy: 'u',
    recordedInMassiveEvent: 'm1',
    isSynced: synced,
    isInvalid: invalid,
  );
}

void main() {
  // SyncService usa `debugPrint` en reintentos HTTP (códigos de error esperados
  // en varios tests). Silenciar aquí evita ensuciar `flutter test` cuando todo
  // pasa; el comportamiento sigue cubierto por los asserts, no por la consola.
  final DebugPrintCallback originalDebugPrint = debugPrint;

  late MockAnimalSimpleEventRepository animalRepo;
  late MockBrandRepository brandRepo;
  late MockMassiveEventRepository massiveRepo;
  late MockSimpleEventRepository simpleRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    animalRepo = MockAnimalSimpleEventRepository();
    brandRepo = MockBrandRepository();
    massiveRepo = MockMassiveEventRepository();
    simpleRepo = MockSimpleEventRepository();
  });

  setUpAll(() {
    registerFallbackValue('');
    debugPrint = (String? message, {int? wrapWidth}) {};
  });

  tearDownAll(() {
    debugPrint = originalDebugPrint;
  });

  group('syncAllInOrder', () {
    test(
      'sin pendientes: orden brands → massive → simple → animal y sin HTTP',
      () async {
        final callLog = <String>[];

        when(() => brandRepo.getAll(any())).thenAnswer((inv) async {
          callLog.add('brand.getAll');
          return <Brand>[];
        });
        when(() => massiveRepo.getAll()).thenAnswer((_) async {
          callLog.add('massive.getAll');
          return <MassiveEvent>[];
        });
        when(() => simpleRepo.getAll()).thenAnswer((_) async {
          callLog.add('simple.getAll');
          return <SimpleEvent>[];
        });
        when(() => animalRepo.getPendingEvents(any())).thenAnswer((_) async {
          callLog.add('animal.getPending');
          return <AnimalSimpleEvent>[];
        });

        final service = _service(
          animalRepo: animalRepo,
          brandRepo: brandRepo,
          massiveRepo: massiveRepo,
          simpleRepo: simpleRepo,
        );

        await http.runWithClient(() async {
          await service.syncAllInOrder('tenant-x');
        }, () {
          return MockClient((req) async {
            fail('no HTTP: ${req.url}');
          });
        });

        expect(callLog, [
          'brand.getAll',
          'massive.getAll',
          'simple.getAll',
          'animal.getPending',
        ]);
        verify(() => brandRepo.getAll('tenant-x')).called(1);
        verify(() => massiveRepo.getAll()).called(1);
        verify(() => simpleRepo.getAll()).called(1);
        verifyNever(() => simpleRepo.getAllUnsynced());
        verify(() => animalRepo.getPendingEvents('tenant-x')).called(1);
      },
    );

    test('devuelve exactamente 4 SyncResult y sigue tras fallo de etapa', () async {
      when(() => brandRepo.getAll(any())).thenThrow(Exception('db brand'));
      when(() => massiveRepo.getAll()).thenAnswer((_) async => <MassiveEvent>[]);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => <SimpleEvent>[]);
      when(
        () => animalRepo.getPendingEvents(any()),
      ).thenAnswer((_) async => <AnimalSimpleEvent>[]);

      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );

      final results = await http.runWithClient(() async {
        return service.syncAllInOrder('tid');
      }, () {
        return MockClient((req) async {
          fail('no HTTP');
        });
      });

      expect(results, hasLength(4));
      expect(results[0].success, false);
      expect(results[0].message, contains('Excepción en brands'));
      expect(results[1].success, true);
    });
  });

  group('getPendingCount', () {
    test('devuelve 0 sin pendientes', () async {
      when(() => animalRepo.getPendingEvents(any())).thenAnswer(
        (_) async => <AnimalSimpleEvent>[],
      );
      when(() => brandRepo.getAll(any())).thenAnswer((_) async => <Brand>[]);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => <MassiveEvent>[]);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => <SimpleEvent>[]);

      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );

      expect(await service.getPendingCount('tid'), 0);
    });

    test('no cuenta brands/massive/simple ya sincronizados', () async {
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer((_) async => []);
      when(
        () => brandRepo.getAll('tid'),
      ).thenAnswer((_) async => [_brand(synced: true)]);
      when(() => massiveRepo.getAll()).thenAnswer(
        (_) async => [_massive(synced: true)],
      );
      when(() => simpleRepo.getAll()).thenAnswer(
        (_) async => [_simple(synced: true)],
      );

      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      expect(await service.getPendingCount('tid'), 0);
    });

    test('animal: usa longitud bruta de getPendingEvents (sin filtrar aquí)', () async {
      final syncedAnimal = _animal(synced: true);
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer(
        (_) async => [syncedAnimal],
      );
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => []);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => []);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => []);

      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      expect(await service.getPendingCount('tid'), 1);
    });

    test('suma pendientes mixtos', () async {
      when(
        () => animalRepo.getPendingEvents('tid'),
      ).thenAnswer((_) async => [_animal()]);
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => [_brand()]);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => [_massive()]);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => [_simple()]);

      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      expect(await service.getPendingCount('tid'), 4);
    });
  });

  group('syncBrands', () {
    test('sin pendientes: mensaje y sin HTTP', () async {
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => []);
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await http.runWithClient(() => service.syncBrands('tid'), () {
        return MockClient((req) async => fail('HTTP ${req.url}'));
      });
      expect(r.success, true);
      expect(r.message, contains('No hay pendientes'));
    });

    test('todas sincronizadas: sin HTTP ni markAsSynced', () async {
      when(
        () => brandRepo.getAll('tid'),
      ).thenAnswer((_) async => [_brand(synced: true)]);
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncBrands('tid');
        expect(r.success, true);
      }, () {
        return MockClient((req) async => fail('HTTP'));
      });
      verifyNever(() => brandRepo.markAsSynced(any()));
    });

    test('pendientes + 200: POST brands/sync y markAsSynced', () async {
      final b = _brand();
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => [b]);
      when(() => brandRepo.markAsSynced('b1')).thenAnswer((_) async {});

      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );

      await http.runWithClient(() async {
        final r = await service.syncBrands('tid');
        expect(r.success, true);
        expect(r.message, contains('brands'));
      }, () {
        return MockClient((req) async {
          expect(req.method, 'POST');
          expect(req.url.toString(), contains('/brands/sync'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body.containsKey('brands'), true);
          final list = body['brands'] as List<dynamic>;
          expect(list.length, 1);
          final o = list.first as Map<String, dynamic>;
          expect(o['id'], 'b1');
          expect(o['idTenant'], 'tid');
          expect(o['name'], 'Brand');
          expect(o['imageMimeType'], 'image/png');
          return http.Response('ok', 200);
        });
      });
      verify(() => brandRepo.markAsSynced('b1')).called(1);
    });

    test('HTTP 500 tras reintentos → fallo sin mark', () async {
      final b = _brand();
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => [b]);
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
        maxRetries: 2,
      );
      await http.runWithClient(() async {
        final r = await service.syncBrands('tid');
        expect(r.success, false);
        expect(r.message, contains('Excepción en brands'));
      }, () {
        return MockClient((_) async => http.Response('e', 500));
      });
      verifyNever(() => brandRepo.markAsSynced(any()));
    });

    test('getAll lanza → SyncResult false', () async {
      when(() => brandRepo.getAll('tid')).thenThrow(Exception('boom'));
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await service.syncBrands('tid');
      expect(r.success, false);
      expect(r.message, contains('Excepción en brands'));
    });

    test('reintento: 500 luego 200 marca sincronizado', () async {
      final b = _brand();
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => [b]);
      when(() => brandRepo.markAsSynced('b1')).thenAnswer((_) async {});
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
        maxRetries: 3,
      );
      var n = 0;
      await http.runWithClient(() async {
        final r = await service.syncBrands('tid');
        expect(r.success, true);
      }, () {
        return MockClient((_) async {
          n++;
          if (n == 1) {
            return http.Response('bad', 500);
          }
          return http.Response('ok', 200);
        });
      });
      verify(() => brandRepo.markAsSynced('b1')).called(1);
    });
  });

  group('syncMassiveEvents', () {
    test('vacío: sin getAllUnsynced ni HTTP', () async {
      when(() => massiveRepo.getAll()).thenAnswer((_) async => []);
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncMassiveEvents('tid');
        expect(r.success, true);
        expect(r.message, contains('No hay massive'));
      }, () {
        return MockClient((r) async => fail('HTTP'));
      });
      verifyNever(() => simpleRepo.getAllUnsynced());
    });

    test('solo sincronizados masivos → éxito sin HTTP', () async {
      when(() => massiveRepo.getAll()).thenAnswer(
        (_) async => [_massive(synced: true)],
      );
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        await service.syncMassiveEvents('tid');
      }, () {
        return MockClient((r) async => fail('HTTP'));
      });
      verifyNever(() => simpleRepo.getAllUnsynced());
    });

    test('pendiente sin simples: sync y mark massive', () async {
      final m = _massive(synced: false);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => [m]);
      when(() => simpleRepo.getAllUnsynced()).thenAnswer((_) async => []);
      when(() => massiveRepo.markAsSynced('m1')).thenAnswer((_) async {});
      when(() => simpleRepo.getByidMassiveEvent('m1')).thenAnswer((_) async => []);
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncMassiveEvents('tid');
        expect(r.success, true);
      }, () {
        return MockClient((req) async {
          expect(req.url.path, contains('massive-events/sync'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          final arr = body['massiveEvents'] as List<dynamic>;
          expect((arr.first as Map)['simpleEvents'], isEmpty);
          return http.Response('ok', 200);
        });
      });
      verify(() => massiveRepo.markAsSynced('m1')).called(1);
    });

    test('pendiente con simples del mismo massive', () async {
      final m = _massive(synced: false, id: 'mx');
      final s = _simple(synced: false, id: 'sx', massiveId: 'mx');
      when(() => massiveRepo.getAll()).thenAnswer((_) async => [m]);
      when(() => simpleRepo.getAllUnsynced()).thenAnswer((_) async => [s]);
      when(() => massiveRepo.markAsSynced('mx')).thenAnswer((_) async {});
      when(() => simpleRepo.getByidMassiveEvent('mx')).thenAnswer((_) async => [s]);
      when(() => simpleRepo.markAsSynced('sx')).thenAnswer((_) async {});

      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        await service.syncMassiveEvents('tid');
      }, () {
        return MockClient((req) async {
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          final arr = body['massiveEvents'] as List<dynamic>;
          final mes = arr.first as Map<String, dynamic>;
          final se = mes['simpleEvents'] as List<dynamic>;
          expect(se.length, 1);
          expect((se.first as Map)['id'], 'sx');
          return http.Response('ok', 200);
        });
      });
      verify(() => simpleRepo.markAsSynced('sx')).called(1);
    });

    test('error HTTP no marca', () async {
      when(() => massiveRepo.getAll()).thenAnswer((_) async => [_massive()]);
      when(() => simpleRepo.getAllUnsynced()).thenAnswer((_) async => []);
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncMassiveEvents('tid');
        expect(r.success, false);
      }, () {
        return MockClient((_) async => http.Response('x', 500));
      });
      verifyNever(() => massiveRepo.markAsSynced(any()));
    });

    test('excepción repositorio', () async {
      when(() => massiveRepo.getAll()).thenThrow(Exception('x'));
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await service.syncMassiveEvents('tid');
      expect(r.success, false);
      expect(r.message, contains('Excepción en massive'));
    });
  });

  group('syncSimpleEvents', () {
    test('sin pendientes', () async {
      when(() => simpleRepo.getAll()).thenAnswer((_) async => []);
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await http.runWithClient(() => service.syncSimpleEvents('tid'), () {
        return MockClient((r) async => fail('HTTP'));
      });
      expect(r.success, true);
      expect(r.message, contains('No hay pendientes'));
    });

    test('200 → simple-events/sync y mark', () async {
      final s = _simple();
      when(() => simpleRepo.getAll()).thenAnswer((_) async => [s]);
      when(() => simpleRepo.markAsSynced('s1')).thenAnswer((_) async {});
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncSimpleEvents('tid');
        expect(r.success, true);
      }, () {
        return MockClient((req) async {
          expect(req.url.path, contains('simple-events/sync'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          final list = body['simpleEvents'] as List;
          expect((list.first as Map)['massiveEventServerId'], 'm1');
          return http.Response('ok', 200);
        });
      });
      verify(() => simpleRepo.markAsSynced('s1')).called(1);
    });

    test('error HTTP', () async {
      when(() => simpleRepo.getAll()).thenAnswer((_) async => [_simple()]);
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncSimpleEvents('tid');
        expect(r.success, false);
      }, () {
        return MockClient((_) async => http.Response('e', 400));
      });
      verifyNever(() => simpleRepo.markAsSynced(any()));
    });

    test('getAll lanza', () async {
      when(() => simpleRepo.getAll()).thenThrow(Exception('db'));
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await service.syncSimpleEvents('tid');
      expect(r.success, false);
      expect(r.message, contains('simpleEvents'));
    });
  });

  group('syncAnimalSimpleEvents', () {
    test('sin pendientes vía filtro isUnsynced', () async {
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer((_) async => []);
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await http.runWithClient(
        () => service.syncAnimalSimpleEvents('tid'),
        () => MockClient((r) async => fail('HTTP')),
      );
      expect(r.success, true);
    });

    test('ignora isInvalid aunque no sincronizado', () async {
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer(
        (_) async => [_animal(invalid: true, synced: false)],
      );
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await http.runWithClient(
        () => service.syncAnimalSimpleEvents('tid'),
        () => MockClient((r) async => fail('HTTP')),
      );
      expect(r.success, true);
      expect(r.message, contains('No hay pendientes'));
    });

    test('200 → cattle/sync-cattle-simple-event y markSynced', () async {
      final a = _animal();
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer((_) async => [a]);
      when(() => animalRepo.markSynced('a1')).thenAnswer((_) async {});
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        await service.syncAnimalSimpleEvents('tid');
      }, () {
        return MockClient((req) async {
          expect(req.url.path, contains('cattle/sync-cattle-simple-event'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          final cattle = body['cattle'] as List;
          final o = cattle.first as Map<String, dynamic>;
          expect(o['id'], 'a1');
          expect(o['massiveEventServerId'], 'm1');
          expect(o.containsKey('appliedAt'), true);
          return http.Response('ok', 200);
        });
      });
      verify(() => animalRepo.markSynced('a1')).called(1);
    });

    test('HTTP error sin mark', () async {
      when(() => animalRepo.getPendingEvents('tid')).thenAnswer(
        (_) async => [_animal()],
      );
      await _hydrateAuth();
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      await http.runWithClient(() async {
        final r = await service.syncAnimalSimpleEvents('tid');
        expect(r.success, false);
      }, () {
        return MockClient((_) async => http.Response('n', 502));
      });
      verifyNever(() => animalRepo.markSynced(any()));
    });

    test('getPendingEvents lanza', () async {
      when(() => animalRepo.getPendingEvents('tid')).thenThrow(Exception('e'));
      final service = _service(
        animalRepo: animalRepo,
        brandRepo: brandRepo,
        massiveRepo: massiveRepo,
        simpleRepo: simpleRepo,
      );
      final r = await service.syncAnimalSimpleEvents('tid');
      expect(r.success, false);
      expect(r.message, contains('cattle'));
    });
  });
}

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

// Bajo prueba:
// - lib/modules/mobile/services/sync_service.dart
// (repositorios y AppDatabase mockeados / no ejercidos como SUT)

class MockAnimalSimpleEventRepository extends Mock
    implements AnimalSimpleEventRepository {}

class MockBrandRepository extends Mock implements BrandRepository {}

class MockMassiveEventRepository extends Mock
    implements MassiveEventRepository {}

class MockSimpleEventRepository extends Mock implements SimpleEventRepository {}

void main() {
  late MockAnimalSimpleEventRepository animalRepo;
  late MockBrandRepository brandRepo;
  late MockMassiveEventRepository massiveRepo;
  late MockSimpleEventRepository simpleRepo;

  setUp(() {
    animalRepo = MockAnimalSimpleEventRepository();
    brandRepo = MockBrandRepository();
    massiveRepo = MockMassiveEventRepository();
    simpleRepo = MockSimpleEventRepository();
  });

  setUpAll(() {
    registerFallbackValue('');
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

        final service = SyncService(
          animalSimpleEventRepository: animalRepo,
          brandRepository: brandRepo,
          massiveEventRepository: massiveRepo,
          simpleEventRepository: simpleRepo,
          baseUrl: 'http://localhost',
          getToken: () async => '',
        );

        await service.syncAllInOrder('tenant-x');

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
  });

  group('getPendingCount', () {
    test('devuelve 0 sin pendientes', () async {
      when(() => animalRepo.getPendingEvents(any())).thenAnswer(
        (_) async => <AnimalSimpleEvent>[],
      );
      when(() => brandRepo.getAll(any())).thenAnswer((_) async => <Brand>[]);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => <MassiveEvent>[]);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => <SimpleEvent>[]);

      final service = SyncService(
        animalSimpleEventRepository: animalRepo,
        brandRepository: brandRepo,
        massiveEventRepository: massiveRepo,
        simpleEventRepository: simpleRepo,
        baseUrl: 'http://localhost',
        getToken: () async => '',
      );

      expect(await service.getPendingCount('tid'), 0);
    });

    test('suma pendientes de animal, brand, massive y simple', () async {
      final now = DateTime.now();
      final animal = AnimalSimpleEvent(
        id: 'a1',
        idTenant: 'tid',
        animalNumber: '1',
        type: 'x',
        appliedAt: now,
        isSynced: false,
        isInvalid: false,
      );
      final brand = Brand(
        id: 'b1',
        idTenant: 'tid',
        name: 'n',
        imageBytes: Uint8List(0),
        imageMimeType: 'image/png',
        imageFileName: 'f',
        isSynced: false,
      );
      final massive = MassiveEvent(
        id: 'm1',
        idTenant: 'tid',
        name: 'me',
        eventDate: now,
        status: 'open',
        createdBy: 'u',
        isSynced: false,
      );
      final simple = SimpleEvent(
        id: 's1',
        idTenant: 'tid',
        idMassiveEvent: 'm1',
        type: 't',
        data: '{}',
        isActive: true,
        isSynced: false,
      );

      when(
        () => animalRepo.getPendingEvents('tid'),
      ).thenAnswer((_) async => [animal]);
      when(() => brandRepo.getAll('tid')).thenAnswer((_) async => [brand]);
      when(() => massiveRepo.getAll()).thenAnswer((_) async => [massive]);
      when(() => simpleRepo.getAll()).thenAnswer((_) async => [simple]);

      final service = SyncService(
        animalSimpleEventRepository: animalRepo,
        brandRepository: brandRepo,
        massiveEventRepository: massiveRepo,
        simpleEventRepository: simpleRepo,
        baseUrl: 'http://localhost',
        getToken: () async => '',
      );

      expect(await service.getPendingCount('tid'), 4);
    });
  });
}

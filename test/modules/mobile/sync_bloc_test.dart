import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

// Bajo prueba:
// - lib/modules/mobile/bloc/sync_bloc.dart
// - lib/modules/mobile/bloc/sync_event.dart
// - lib/modules/mobile/bloc/sync_state.dart
// - lib/modules/mobile/services/sync_service.dart (contrato, vía mock)

class MockSyncService extends Mock implements SyncService {}

void main() {
  late MockSyncService mockSyncService;

  setUp(() {
    mockSyncService = MockSyncService();
  });

  group('SyncEvent', () {
    test('StartSync equatable y props', () {
      expect(const StartSync('tenant-1'), const StartSync('tenant-1'));
      expect(const StartSync('tenant-1').props, ['tenant-1']);
      expect(const StartSync('tenant-1'), isNot(const StartSync('tenant-2')));
    });
  });

  group('SyncState', () {
    test('SyncFailure equatable y props', () {
      expect(const SyncFailure('error'), const SyncFailure('error'));
      expect(const SyncFailure('error').props, ['error']);
      expect(const SyncFailure('error'), isNot(const SyncFailure('other')));
    });

    test('estados sin props comparan por tipo y lista vacía', () {
      expect(SyncInitial(), SyncInitial());
      expect(SyncInitial().props, isEmpty);
      expect(SyncInProgress(), SyncInProgress());
      expect(SyncInProgress().props, isEmpty);
      expect(SyncSuccess(), SyncSuccess());
      expect(SyncSuccess().props, isEmpty);
      expect(SyncInitial(), isNot(SyncInProgress()));
    });
  });

  group('SyncResult (DTO)', () {
    test('expone success y message', () {
      final r = SyncResult(success: true, message: 'ok');
      expect(r.success, true);
      expect(r.message, 'ok');
    });
  });

  group('SyncBloc', () {
    test('estado inicial SyncInitial', () async {
      final bloc = SyncBloc(mockSyncService);
      expect(bloc.state, SyncInitial());
      await bloc.close();
      verifyZeroInteractions(mockSyncService);
    });

    blocTest<SyncBloc, SyncState>(
      'StartSync emite SyncInProgress y SyncSuccess si todos los resultados ok',
      build: () => SyncBloc(mockSyncService),
      setUp: () {
        when(() => mockSyncService.syncAllInOrder('tenant-1')).thenAnswer(
          (_) async => [
            SyncResult(success: true, message: 'a'),
            SyncResult(success: true, message: 'b'),
          ],
        );
      },
      act: (bloc) => bloc.add(const StartSync('tenant-1')),
      expect: () => [SyncInProgress(), SyncSuccess()],
      verify: (_) {
        verify(() => mockSyncService.syncAllInOrder('tenant-1')).called(1);
        verifyNoMoreInteractions(mockSyncService);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'StartSync con lista vacía de SyncResult emite SyncSuccess',
      build: () => SyncBloc(mockSyncService),
      setUp: () {
        when(
          () => mockSyncService.syncAllInOrder('tenant-empty'),
        ).thenAnswer((_) async => <SyncResult>[]);
      },
      act: (bloc) => bloc.add(const StartSync('tenant-empty')),
      expect: () => [SyncInProgress(), SyncSuccess()],
      verify: (_) {
        verify(() => mockSyncService.syncAllInOrder('tenant-empty')).called(1);
        verifyNoMoreInteractions(mockSyncService);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'StartSync emite SyncFailure si un resultado falla',
      build: () => SyncBloc(mockSyncService),
      setUp: () {
        when(() => mockSyncService.syncAllInOrder('t')).thenAnswer(
          (_) async => [
            SyncResult(success: true, message: 'ok'),
            SyncResult(success: false, message: 'falló'),
          ],
        );
      },
      act: (bloc) => bloc.add(const StartSync('t')),
      expect: () => [SyncInProgress(), const SyncFailure('falló')],
      verify: (_) {
        verify(() => mockSyncService.syncAllInOrder('t')).called(1);
        verifyNoMoreInteractions(mockSyncService);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'StartSync concatena mensajes de varios resultados fallidos con \\n',
      build: () => SyncBloc(mockSyncService),
      setUp: () {
        when(() => mockSyncService.syncAllInOrder('t-multi')).thenAnswer(
          (_) async => [
            SyncResult(success: true, message: 'ok'),
            SyncResult(success: false, message: 'brands failed'),
            SyncResult(success: false, message: 'events failed'),
          ],
        );
      },
      act: (bloc) => bloc.add(const StartSync('t-multi')),
      expect:
          () => [
            SyncInProgress(),
            const SyncFailure('brands failed\nevents failed'),
          ],
      verify: (_) {
        verify(() => mockSyncService.syncAllInOrder('t-multi')).called(1);
        verifyNoMoreInteractions(mockSyncService);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'StartSync emite SyncFailure si el servicio lanza',
      build: () => SyncBloc(mockSyncService),
      setUp: () {
        when(
          () => mockSyncService.syncAllInOrder('t-err'),
        ).thenThrow(StateError('red'));
      },
      act: (bloc) => bloc.add(const StartSync('t-err')),
      expect: () => [SyncInProgress(), const SyncFailure('Bad state: red')],
      verify: (_) {
        verify(() => mockSyncService.syncAllInOrder('t-err')).called(1);
        verifyNoMoreInteractions(mockSyncService);
      },
    );
  });
}

import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_sync_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/pages/massive_event_sync_listener.dart
// - lib/modules/shared/features/massiveEvent/pages/massive_event_sync_listener_io.dart (VM)

class _MockSync extends Mock implements SyncService {}

void main() {
  setUpAll(() {
    registerFallbackValue('fb-tenant');
  });

  late _MockSync syncService;

  setUp(() {
    syncService = _MockSync();
    when(
      () => syncService.syncAllInOrder(any()),
    ).thenAnswer((_) async => <SyncResult>[]);
  });

  testWidgets(
    'sync móvil desactivado: SyncSuccess no dispara onSyncSuccess',
    (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => SyncBloc(syncService),
            child: wrapMassiveEventPageSyncListener(
              onSyncSuccess: () => calls++,
              child: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      final sync = tester.element(find.byType(SizedBox)).read<SyncBloc>();
      sync.add(const StartSync('tenant-1'));
      await tester.pumpAndSettle();

      expect(calls, 0);
    },
  );
}

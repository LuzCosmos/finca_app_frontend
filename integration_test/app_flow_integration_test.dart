import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';
import 'package:finca_app_frontend/router/router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/integration_fake_auth_service.dart';
import 'support/sync_bloc_factory.dart';

// Bajo prueba (integración): lib/main.dart (MainApp, appRouter), lib/router/router.dart,
// lib/core/services/session_service.dart, capa masiva IO + Drift vía navegación real,
// lib/core/bootstrap/mobile_sync_provider.dart (syncBlocOverride), login con auth fake.

class _MockSyncService extends Mock implements SyncService {}

/// JWT mínimo con `exp` (misma idea que `test/core/services/session_service_test.dart`).
String _jwtWithExp(int expUnix) {
  final header = base64Url.encode(
    utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})),
  );
  final payload = base64Url.encode(
    utf8.encode(jsonEncode({'exp': expUnix})),
  );
  return '$header.$payload.dummy';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue('');
  });

  tearDown(() async {
    await DatabaseProvider.close();
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  testWidgets('sin sesión: MainApp muestra login', (tester) async {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
    await SessionService.hydrateFromStorage();

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'sesión fake: home → tap Evento masivo → lista embebida (historial)',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});
      BasicApiService.setBaseUrl('http://127.0.0.1:9');

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': true},
        },
        idTenant: 't-integration',
        idUser: 'u-integration',
        refreshToken: 'rt-integration',
      );
      await SessionService.hydrateFromStorage();

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(
        find.byKey(const ValueKey<String>('home-page')),
        findsOneWidget,
      );

      await tester.tap(find.text('Evento masivo'));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      expect(find.byType(MassiveEventListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('massive-event-list-embedded')),
        findsOneWidget,
      );
      expect(find.text('Eventos masivos'), findsWidgets);
      expect(find.text('Reintentar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'login por UI: credenciales en LoginForm → AuthService fake → home',
    (tester) async {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
    await SessionService.hydrateFromStorage();

    final mockSync = _MockSyncService();
    when(() => mockSync.syncAllInOrder(any())).thenAnswer((_) async => <SyncResult>[]);
    final SyncBloc syncBloc = createIntegrationSyncBloc(mockSync);
    addTearDown(() async {
      await syncBloc.close();
      reset(mockSync);
    });

    // Sin override de hasValidToken: tras saveSession el redirect debe ver sesión válida.
    final router = createAppRouter(
      initialLocation: '/loading',
      loginAuthService: IntegrationFakeAuthService(),
    );

    await tester.pumpWidget(
      MainApp(router: router, syncBlocOverride: syncBloc),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const ValueKey<String>('login-page')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login-username-field')),
      'usuario_integration',
    );
    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'cualquiera',
    );
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
    expect(tester.takeException(), isNull);
  },
  );

  testWidgets(
    'sync mockeado: home → Sincronizar ahora → SyncSuccess (sin red)',
    (tester) async {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await SessionService.saveSession(
      token: _jwtWithExp(now + 86400),
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
      },
      idTenant: 't-integration',
      idUser: 'u-integration',
      refreshToken: 'rt-integration',
    );
    await SessionService.hydrateFromStorage();

    final mockSync = _MockSyncService();
    var syncCalls = 0;
    when(() => mockSync.syncAllInOrder(any())).thenAnswer((_) async {
      syncCalls++;
      return <SyncResult>[];
    });
    final SyncBloc syncBloc = createIntegrationSyncBloc(mockSync);
    addTearDown(() async {
      await syncBloc.close();
      reset(mockSync);
    });

    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/loading',
    );

    await tester.pumpWidget(
      MainApp(router: router, syncBlocOverride: syncBloc),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);

    final baseline = syncCalls;

    final success = syncBloc.stream.firstWhere((s) => s is SyncSuccess);
    await tester.tap(find.text('Sincronizar ahora'));
    await success.timeout(const Duration(seconds: 10));
    expect(syncCalls, greaterThan(baseline));
    expect(tester.takeException(), isNull);
  },
  );
}

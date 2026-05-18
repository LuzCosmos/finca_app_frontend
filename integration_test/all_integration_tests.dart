import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/pages/devices_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../test/support/test_l10n.dart';
import 'support/integration_fake_auth_service.dart';
import 'support/integration_test_session.dart';
import 'support/sync_bloc_factory.dart';

// Suite única de integration_test: un solo bundle evita en macOS el fallo
// "Unable to start the app on the device" / "log reader stopped" al ejecutar
// `flutter test integration_test/ -d macos` con varios archivos (segundo launch).
//
// Bajo prueba: MainApp, router, sesión, lista masivos, dispositivos (Equipment and Resource), login fake, SyncBloc.

class _MockSyncService extends Mock implements SyncService {}

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

  setUp(() {
    integrationBindOnlineApiForTests();
  });

  tearDown(() async {
    await DatabaseProvider.close();
    SessionService.resetForTesting();
    integrationResetOnlineApiForTests();
  });

  testWidgets(
    'ruta inicial /massive-events: lista a pantalla completa y reintento si API cae',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': true},
        },
        idTenant: 't-integration-list',
        idUser: 'u-integration-list',
        refreshToken: 'rt',
      );
      await SessionService.hydrateFromStorage();

      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/massive-events',
      );

      await tester.pumpWidget(MainApp(router: router));
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(find.byType(MassiveEventListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('massive-event-list-page')),
        findsOneWidget,
      );
      final l10n = l10nFromTester(tester);
      expect(find.text(l10n.retry), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ruta inicial /equipment-resources: lista a pantalla completa y reintento si API cae',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'PROD_CENTER': {'devices': true},
        },
        idTenant: 't-integration-devices',
        idUser: 'u-integration-devices',
        refreshToken: 'rt',
      );
      await SessionService.hydrateFromStorage();

      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/equipment-resources',
      );

      await tester.pumpWidget(MainApp(router: router));
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(find.byType(DevicesListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('devices-list-page')),
        findsOneWidget,
      );
      final l10n = l10nFromTester(tester);
      expect(find.text(l10n.devicesList_retry), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ruta /massive-events/edit?id=…: carga de sesión falla con API inalcanzable y muestra banner',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': true},
        },
        idTenant: 't-integration-edit',
        idUser: 'u-integration-edit',
        refreshToken: 'rt',
      );
      await SessionService.hydrateFromStorage();

      const editId = '00000000-0000-0000-0000-00000000a001';
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/massive-events/edit?id=$editId',
      );

      await tester.pumpWidget(MainApp(router: router));
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(find.byType(MassiveEventPage), findsOneWidget);
      final l10n = l10nFromTester(tester);
      expect(find.textContaining(l10n.massiveEventLoadSessionError), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

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
    'home online: permisos completos muestran todas las opciones (rejilla compacta)',
    (tester) async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await pumpIntegrationHomeWithFullPermissions(
        tester,
        token: _jwtWithExp(now + 86400),
      );

      expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('home-compact-layout')), findsOneWidget);

      final l10n = l10nFromTester(tester);
      expectAllHomeMenuOptionsVisible(l10n);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'home online ancho: rail lateral con todas las opciones',
    (tester) async {
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await pumpIntegrationHomeWithFullPermissions(
        tester,
        token: _jwtWithExp(now + 86400),
      );

      expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
      final l10n = l10nFromTester(tester);
      expect(find.text(l10n.dashboard_title), findsWidgets);
      expect(find.text(l10n.purchase), findsOneWidget);
      expect(find.text(l10n.massiveEvent), findsOneWidget);
      expect(find.text(l10n.sale), findsOneWidget);
      expect(find.text(l10n.users), findsOneWidget);
      expect(find.text(l10n.masterListTitle), findsOneWidget);
      expect(find.text(l10n.equipmentAndResource_title), findsOneWidget);
      expect(find.text(l10n.syncNow), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'home offline: solo evento masivo y sincronizar (requiresOnline oculto)',
    (tester) async {
      HomeConnectivityService.debugForceOnline = false;
      integrationBindApiForTests();

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await pumpIntegrationHomeWithFullPermissions(
        tester,
        token: _jwtWithExp(now + 86400),
      );

      final l10n = l10nFromTester(tester);
      expect(find.text(l10n.massiveEvent), findsOneWidget);
      expect(find.text(l10n.syncNow), findsOneWidget);
      expect(find.text(l10n.dashboard_title), findsNothing);
      expect(find.text(l10n.purchase), findsNothing);
      expect(find.text(l10n.sale), findsNothing);
      expect(find.text(l10n.users), findsNothing);
      expect(find.text(l10n.masterListTitle), findsNothing);
      expect(find.text(l10n.equipmentAndResource_title), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sesión fake: home → tap Equipment and Resource → lista embebida',
    (tester) async {
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: integrationFullHomePermissions(),
        idTenant: 't-integration',
        idUser: 'u-integration',
        refreshToken: 'rt-integration',
      );
      await SessionService.hydrateFromStorage();

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);

      final l10n = l10nFromTester(tester);
      await tester.tap(find.text(l10n.equipmentAndResource_title));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      expect(find.byType(DevicesListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('devices-list-embedded')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('home-wide-panel-equipment_resources')),
        findsOneWidget,
      );
      expect(find.text(l10n.devicesList_retry), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sesión fake: home → tap Evento masivo → lista embebida (historial)',
    (tester) async {
      // Home nativo solo embebe masivos con rail si el cuerpo es ancho
      // (kHomeWideLayoutBreakpoint); el viewport por defecto del runner (~800)
      // usa rejilla compacta y `push('/massive-events')` → clave distinta.
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: integrationFullHomePermissions(),
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

      final l10n = l10nFromTester(tester);
      await tester.tap(find.text(l10n.massiveEvent));
      await tester.pumpAndSettle(const Duration(seconds: 15));

      expect(find.byType(MassiveEventListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('massive-event-list-embedded')),
        findsOneWidget,
      );
      // Embebido: no hay `FincaScaffold` del listado con `massiveEventsListTitle`;
      // el shell del home usa el título del menú (`massiveEvent`, singular).
      expect(
        find.byKey(const ValueKey<String>('home-wide-panel-massive_events')),
        findsOneWidget,
      );
      expect(find.text(l10n.retry), findsOneWidget);
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
      final l10n = l10nFromTester(tester);
      await tester.tap(find.text(l10n.login));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);

      final l10nHome = l10nFromTester(tester);
      expectAllHomeMenuOptionsVisible(l10nHome);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sync mockeado: home → Sincronizar eventos masivos → SyncSuccess (sin red)',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: integrationFullHomePermissions(),
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

      final l10n = l10nFromTester(tester);
      final baseline = syncCalls;

      final success = syncBloc.stream.firstWhere((s) => s is SyncSuccess);
      await tester.tap(find.text(l10n.syncNow));
      await success.timeout(const Duration(seconds: 10));
      expect(syncCalls, greaterThan(baseline));
      expect(tester.takeException(), isNull);
    },
  );
}

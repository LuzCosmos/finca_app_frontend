import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../../../../support/app_test_host.dart';
import '../../../../support/router_test_host.dart';

// Bajo prueba:
// - lib/modules/shared/features/home/page/home_page.dart
// - lib/core/services/session_service.dart (permisos vía getPermissions)
// - navigación Home: masivo vía createAppRouter; usuarios vía GoRouter stub (/users)

void main() {
  setUp(() {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
    HomePage.resetWideRailCollapseSessionForTesting();
    HomeConnectivityService.debugForceOnline = true;
  });

  tearDown(() {
    HomeConnectivityService.debugForceOnline = null;
  });

  testWidgets('título L10n Inicio y opciones según permisos (móvil / no web)', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't.ok',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
        'EMP_MGMT': {'users': true},
        'COMMERCE': {'purchases': true, 'sales': true},
        'FARM': {'cattle': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
    expect(find.text(l10n.home_title), findsWidgets);

    expect(find.text(l10n.dashboard_title), findsOneWidget);
    // Módulos 100 % online visibles en móvil cuando hay conexión (forzada en tests).
    expect(find.text(l10n.purchase), findsOneWidget);
    expect(find.text(l10n.sale), findsOneWidget);
    expect(find.text(l10n.masterListTitle), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsOneWidget);
    expect(find.text(l10n.users), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'permisos como máscara CRUDL (strings tipo backend) equivalen a bool en Home',
    (tester) async {
      await SessionService.saveSession(
        token: 't.ok',
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': '11111'},
          'EMP_MGMT': {'users': '11111'},
          'COMMERCE': {'purchases': '11111', 'sales': '11111'},
          'FARM': {'cattle': '11111'},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
      expect(find.text(l10n.dashboard_title), findsOneWidget);
      expect(find.text(l10n.purchase), findsOneWidget);
      expect(find.text(l10n.sale), findsOneWidget);
      expect(find.text(l10n.masterListTitle), findsOneWidget);
      expect(find.text(l10n.massiveEvent), findsOneWidget);
      expect(find.text(l10n.users), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sin conexión: oculta módulos requiresOnline (dashboard, comercio, usuarios, ganado)',
    (tester) async {
      HomeConnectivityService.debugForceOnline = false;

      await SessionService.saveSession(
        token: 't.ok',
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': true},
          'EMP_MGMT': {'users': true},
          'COMMERCE': {'purchases': true, 'sales': true},
          'FARM': {'cattle': true},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.massiveEvent), findsOneWidget);
      expect(find.text(l10n.dashboard_title), findsNothing);
      expect(find.text(l10n.users), findsNothing);
      expect(find.text(l10n.purchase), findsNothing);
      expect(find.text(l10n.sale), findsNothing);
      expect(find.text(l10n.masterListTitle), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'muestra Equipment and Resource con PROD_CENTER.devices',
    (tester) async {
      await SessionService.saveSession(
        token: 't.ok',
        permissions: {
          'PROD_CENTER': {'devices': '00001'},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.equipmentAndResource_title), findsOneWidget);
    },
  );

  testWidgets('sin permisos: no muestra tarjetas de módulo ni rompe', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {},
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.home_title), findsWidgets);
    expect(find.text(l10n.dashboard_title), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsNothing);
    expect(find.text(l10n.users), findsNothing);
    expect(find.text(l10n.purchase), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('solo MASSIVE_EVENTS: solo opción evento masivo', (tester) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.dashboard_title), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsOneWidget);
    expect(find.text(l10n.users), findsNothing);
  });

  testWidgets('solo EMP_MGMT.users: solo usuarios', (tester) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'EMP_MGMT': {'users': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.dashboard_title), findsOneWidget);
    expect(find.text(l10n.users), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsNothing);
  });

  testWidgets('MASSIVE_EVENTS con massive_events false: oculta opción', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': false},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.dashboard_title), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsNothing);
  });

  testWidgets('MASSIVE_EVENTS vacío: sin opción y sin excepción', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {'MASSIVE_EVENTS': <String, dynamic>{}},
      idTenant: 'tid',
      idUser: 'uid',
    );

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.dashboard_title), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tap evento masivo navega a MassiveEventListPage', (tester) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/home',
    );

    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);

    final l10n =
        AppLocalizations.of(
          tester.element(find.byKey(const ValueKey<String>('home-page'))),
        )!;

    await tester.tap(find.text(l10n.massiveEvent));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(MassiveEventListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tap usuarios navega a /users sin montar UsersListPage real', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'EMP_MGMT': {'users': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/users',
          builder:
              (_, _) => const Scaffold(
                body: KeyedSubtree(
                  key: ValueKey<String>('users-route-stub'),
                  child: Text('Users Stub'),
                ),
              ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);

    final l10n =
        AppLocalizations.of(
          tester.element(find.byKey(const ValueKey<String>('home-page'))),
        )!;

    await tester.tap(find.text(l10n.users));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('users-route-stub')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout ancho: muestra rail lateral y panel', (tester) async {
    await SessionService.saveSession(
      token: 't.ok',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
        'EMP_MGMT': {'users': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );
    BasicApiService.setBaseUrl('http://127.0.0.1:9');

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
    await tester.binding.setSurfaceSize(const Size(1100, 800));

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(home: const HomePage()),
    );
    await tester.pumpAndSettle();

    final l10nWide =
        AppLocalizations.of(
          tester.element(find.byKey(const ValueKey<String>('home-page'))),
        )!;
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text(l10nWide.dashboard_title),
      ),
      findsOneWidget,
    );

    expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('home-wide-side-menu')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('home-wide-panel-dashboard')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('dashboard-page')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout ancho nativo: hamburguesa colapsa el rail', (tester) async {
    await SessionService.saveSession(
      token: 't.ok',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );
    BasicApiService.setBaseUrl('http://127.0.0.1:9');

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
    await tester.binding.setSurfaceSize(const Size(1200, 800));

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(home: const HomePage()),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('home-wide-side-menu')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey<String>('home-rail-toggle')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('home-wide-side-menu-compact')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout ancho: al tocar evento masivo el panel muestra MassiveEventListPage', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't.ok',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
    await tester.binding.setSurfaceSize(const Size(1100, 800));

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            return const HomePage();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('home-side-item-massive_events')));
    await tester.pumpAndSettle();

    expect(find.byType(MassiveEventListPage), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('home-wide-panel-massive_events')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';

import '../../../../support/app_test_host.dart';

// Bajo prueba (Chrome / `flutter test -p chrome`):
// - lib/modules/shared/features/home/page/home_page.dart
//
// Comportamiento web relevante:
// - Siempre layout rail + panel (`home-wide-layout`), sin rejilla de tarjetas.
// - Panel inicial = Dashboard (`home-wide-panel-dashboard`, `dashboard-page`).
// - AppBar: título del módulo activo; icono de inicio solo si el panel ≠ Dashboard
//   (`onHomePressed` resetea `_wideSelectedId` a dashboard; `go('/home')` no basta).
// - `BasicApiService.setBaseUrl`: evita llamadas HTTP reales al cargar mapa del dashboard.
// - Permisos + `forWebOnly`: tarjetas solo-web visibles en el rail en entorno kIsWeb.

void main() {
  setUp(() {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  group('HomePage web — permisos y rail', () {
    testWidgets(
      'COMMERCE.purchases: ítem Compras en el menú lateral y layout ancho',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

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

        expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
        expect(find.text(l10n.purchase), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'COMMERCE.sales: ítem Ventas en el menú lateral',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'sales': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

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

        expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
        expect(find.text(l10n.sale), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'FARM.cattle: ítem Lista maestra / ganado en el menú lateral',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'FARM': {'cattle': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

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

        expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
        expect(find.text(l10n.masterListTitle), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );
  });

  group('HomePage web — panel por defecto y navegación shell', () {
    testWidgets(
      'al iniciar: panel Dashboard y título AppBar = Dashboard',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

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

        expect(find.byKey(const ValueKey<String>('home-wide-panel-dashboard')), findsOneWidget);
        expect(find.byKey(const ValueKey<String>('dashboard-page')), findsOneWidget);

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.dashboard_title),
          ),
          findsOneWidget,
        );

        // En Dashboard no debe mostrarse el icono de inicio del shell (no hay “sub-módulo”).
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byIcon(Icons.home),
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'tap Compras: cambia panel y muestra icono inicio; tap inicio vuelve a Dashboard',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

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

        await tester.tap(find.byKey(const ValueKey<String>('home-side-item-purchases')));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey<String>('home-wide-panel-purchases')), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.purchase),
          ),
          findsOneWidget,
        );

        final homeIcon = find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.home),
        );
        expect(homeIcon, findsOneWidget);

        await tester.tap(homeIcon);
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey<String>('home-wide-panel-dashboard')), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.dashboard_title),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'viewport estrecho: sigue siendo layout rail (web siempre ancho)',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
        });
        await tester.binding.setSurfaceSize(const Size(420, 700));

        await tester.pumpWidget(
          pumpLocalizedMaterialShell(home: const HomePage()),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'viewport estrecho: rail compacto (solo iconos) mantiene selección y tooltips',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
        });
        await tester.binding.setSurfaceSize(const Size(420, 700));

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

        expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
        expect(
          find.byKey(const ValueKey<String>('home-wide-side-menu-compact')),
          findsOneWidget,
        );

        // En modo compacto no renderizamos textos en el rail.
        expect(find.text(l10n.purchase), findsNothing);

        // Tap en el ítem compacto de compras debe cambiar el panel y el título del AppBar.
        await tester.tap(
          find.byKey(const ValueKey<String>('home-side-item-compact-purchases')),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey<String>('home-wide-panel-purchases')), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.purchase),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'hamburguesa: colapsa el rail en web cuando hay ancho suficiente',
      (tester) async {
        await SessionService.saveSession(
          token: 't',
          permissions: {
            'COMMERCE': {'purchases': true},
          },
          idTenant: 'tid',
          idUser: 'uid',
        );
        BasicApiService.setBaseUrl('http://127.0.0.1:9');

        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
        });
        await tester.binding.setSurfaceSize(const Size(1200, 800));

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

        // Arranca extendido.
        expect(find.byKey(const ValueKey<String>('home-wide-side-menu')), findsOneWidget);
        expect(find.text(l10n.purchase), findsOneWidget);

        // Toggle → compacto.
        await tester.tap(find.byKey(const ValueKey<String>('home-rail-toggle')));
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey<String>('home-wide-side-menu-compact')),
          findsOneWidget,
        );
        expect(find.text(l10n.purchase), findsNothing);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );
  });
}

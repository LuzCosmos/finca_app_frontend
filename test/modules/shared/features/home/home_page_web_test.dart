import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';

import '../../../../support/app_test_host.dart';

// Bajo prueba (Chrome / `flutter test --platform chrome`):
// - lib/modules/shared/features/home/page/home_page.dart
//
// Regla real de producción (no confundir con layout nativo):
// - En **web**, `_forceWideLayoutOnWeb` ⇒ siempre layout dashboard (`home-wide-layout`),
//   con rail compacto o extendido según ancho útil vs `kHomeWebRailExtendedBreakpoint`.
// - En viewport **estrecho web**, el rail pasa a compacto (solo iconos); sigue existiendo
//   `home-wide-layout`, **no** la rejilla `home-compact-layout` (esa es solo nativo angosto).
//
// Diagnóstico externo que pide rejilla en web angosto **no aplica** al código actual;
// los tests siguen esa regla de producto.
//
// `BasicApiService.setBaseUrl`: evita HTTP “exitoso” a backend real.
// Mapa del dashboard: placeholder en widget tests (ver `CattleLastLocationsMapWidget`).

/// Superficie grande para rail **extendido** (títulos visibles en el lateral).
/// El tamaño por defecto del tester (~800px lógicos) deja el rail en **compacto** en web.
Future<void> bindLargeViewportForExtendedWebRail(WidgetTester tester) async {
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });
  await tester.binding.setSurfaceSize(const Size(1200, 800));
}

void main() {
  setUp(() {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpWebFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));
  }

  group('HomePage web — permisos y rail', () {
    testWidgets(
      'COMMERCE.purchases: ítem Compras en el menú lateral y layout ancho',
      (tester) async {
        await bindLargeViewportForExtendedWebRail(tester);
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
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-layout')),
          findsOneWidget,
        );
        expect(find.text(l10n.purchase), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets('COMMERCE.sales: ítem Ventas en el menú lateral', (
      tester,
    ) async {
      await bindLargeViewportForExtendedWebRail(tester);
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
      await pumpWebFrames(tester);

      expect(
        find.byKey(const ValueKey<String>('home-wide-layout')),
        findsOneWidget,
      );
      expect(find.text(l10n.sale), findsOneWidget);
      expect(tester.takeException(), isNull);
    }, skip: !kIsWeb);

    testWidgets('FARM.cattle: ítem Lista maestra / ganado en el menú lateral', (
      tester,
    ) async {
      await bindLargeViewportForExtendedWebRail(tester);
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
      await pumpWebFrames(tester);

      expect(
        find.byKey(const ValueKey<String>('home-wide-layout')),
        findsOneWidget,
      );
      expect(find.text(l10n.masterListTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    }, skip: !kIsWeb);
  });

  group('HomePage web — panel por defecto y navegación shell', () {
    testWidgets('al iniciar: panel Dashboard y título AppBar = Dashboard', (
      tester,
    ) async {
      await bindLargeViewportForExtendedWebRail(tester);
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
      await pumpWebFrames(tester);

      expect(
        find.byKey(const ValueKey<String>('home-wide-panel-dashboard')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('dashboard-page')),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(l10n.dashboard_title),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.home),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    }, skip: !kIsWeb);

    testWidgets(
      'tap Compras: cambia panel y muestra icono inicio; tap inicio vuelve a Dashboard',
      (tester) async {
        await bindLargeViewportForExtendedWebRail(tester);
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
        await pumpWebFrames(tester);

        await tester.tap(
          find.byKey(const ValueKey<String>('home-side-item-purchases')),
        );
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-panel-purchases')),
          findsOneWidget,
        );
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
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-panel-dashboard')),
          findsOneWidget,
        );
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
      'viewport estrecho web: dashboard sigue en modo rail (compacto bajo breakpoint)',
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
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-layout')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('home-compact-layout')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
      skip: !kIsWeb,
    );

    testWidgets(
      'viewport estrecho web: rail compacto (solo iconos) mantiene selección al cambiar módulo',
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
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-layout')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('home-wide-side-menu-compact')),
          findsOneWidget,
        );

        expect(find.text(l10n.purchase), findsNothing);

        await tester.tap(
          find.byKey(
            const ValueKey<String>('home-side-item-compact-purchases'),
          ),
        );
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-panel-purchases')),
          findsOneWidget,
        );
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
        await pumpWebFrames(tester);

        expect(
          find.byKey(const ValueKey<String>('home-wide-side-menu')),
          findsOneWidget,
        );
        expect(find.text(l10n.purchase), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey<String>('home-rail-toggle')),
        );
        await pumpWebFrames(tester);

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

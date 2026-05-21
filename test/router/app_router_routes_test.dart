import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/pages/import_lw001_devices_page.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/shared/features/users/pages/users_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/pages/purchase_form_page.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/pages/purchases_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/pages/purchase_reception_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/create_sale_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../support/router_mock_http_client.dart';
import '../support/router_test_host.dart';
import '../support/test_l10n.dart';

// Bajo prueba: lib/router/router.dart y builders que enlazan a:
// - lib/modules/shared/features/massiveEvent/pages/massive_event_page.dart
// - lib/modules/shared/features/dashboard/page/dashboard_page.dart
// - lib/modules/shared/features/sales/pages/sale_dashboard_page_export.dart
// - lib/modules/shared/features/users/pages/users_list_page.dart
// - lib/modules/shared/features/cattle/pages/cattle_master_list_page.dart
// - lib/modules/shared/features/cattle_purchase/pages/purchase_form_page.dart
// - lib/modules/shared/features/cattle_purchase/pages/purchases_list_page.dart
// - lib/modules/shared/features/purchase_reception/pages/purchase_reception_page.dart
// - lib/modules/shared/features/sales/pages/create_sale_page.dart
// (y MassiveEventBloc en la ruta massive-events/create).

void main() {
  setUp(() async {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    BasicApiService.setBaseUrl('http://127.0.0.1:9');
    HomeConnectivityService.debugForceOnline = true;
    SharedPreferences.setMockInitialValues({});
    await SessionService.saveSession(
      token: 't',
      permissions: <String, dynamic>{
        'COMMERCE': <String, dynamic>{'purchases': true, 'sales': true},
        'FARM': <String, dynamic>{'cattle': true},
        'EMP_MGMT': <String, dynamic>{'users': true},
        'MASSIVE_EVENTS': <String, dynamic>{'massive_events': true},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );
  });

  tearDown(() {
    HomeConnectivityService.debugForceOnline = null;
    BasicApiService.resetForTesting();
  });

  /// Sesión con permisos completos (setUp) + token válido vía [hasValidToken].
  Future<void> pumpAuthenticated(WidgetTester tester, String location) async {
    await runWithRouterMockHttp(() async {
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: location,
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await pumpRouterFrames(tester);
    });
  }

  testWidgets('autenticado: /home construye HomePage', (tester) async {
    await pumpAuthenticated(tester, '/home');
    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autenticado: /loading redirige a home', (tester) async {
    await pumpAuthenticated(tester, '/loading');
    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
  });

  testWidgets('autenticado: /dashboard construye DashboardPage', (
    tester,
  ) async {
    await pumpAuthenticated(tester, '/dashboard');
    expect(find.byType(DashboardPage), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('dashboard-page')),
      findsOneWidget,
    );
  });

  testWidgets('sin conexión: /dashboard muestra aviso online', (tester) async {
    HomeConnectivityService.debugForceOnline = false;

    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/dashboard',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    await tester.pumpAndSettle();

    expect(find.byType(DashboardPage), findsNothing);
    final l10n = l10nFromTester(tester);
    expect(find.text(l10n.onlineFeatureRequiresConnection), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autenticado: /purchases/create', (tester) async {
    await pumpAuthenticated(tester, '/purchases/create');
    expect(find.byType(PurchaseFormPage), findsOneWidget);
  });

  testWidgets('autenticado: /purchases', (tester) async {
    await pumpAuthenticated(tester, '/purchases');
    expect(find.byType(PurchasesListPage), findsOneWidget);
  });

  testWidgets('sin conexión: /purchases muestra aviso online, no la lista', (
    tester,
  ) async {
    HomeConnectivityService.debugForceOnline = false;

    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/purchases',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    await tester.pumpAndSettle();

    expect(find.byType(PurchasesListPage), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    final l10n = l10nFromTester(tester);
    expect(find.text(l10n.onlineFeatureRequiresConnection), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autenticado: /purchases/pending', (tester) async {
    await pumpAuthenticated(tester, '/purchases/pending');
    expect(find.byType(PurchasesListPage), findsOneWidget);
  });

  testWidgets('autenticado: /sales', (tester) async {
    await pumpAuthenticated(tester, '/sales');
    expect(find.byType(SaleDashboardPage), findsOneWidget);
  });

  testWidgets('autenticado: /sales/create', (tester) async {
    await pumpAuthenticated(tester, '/sales/create');
    expect(find.byType(CreateSalePage), findsOneWidget);
  });

  testWidgets('autenticado: /sales/edit/:id', (tester) async {
    await pumpAuthenticated(tester, '/sales/edit/abc-sale-id');
    expect(find.byType(CreateSalePage), findsOneWidget);
  });

  testWidgets('autenticado: /massive-events muestra MassiveEventListPage', (
    tester,
  ) async {
    await pumpAuthenticated(tester, '/massive-events');
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MassiveEventListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autenticado: /massive-events/create expone MassiveEventBloc', (
    tester,
  ) async {
    await runWithRouterMockHttp(() async {
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/massive-events/create',
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await pumpRouterFrames(tester);
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(MassiveEventPage), findsOneWidget);
      final BuildContext ctx = tester.element(find.byType(MassiveEventPage));
      expect(ctx.read<MassiveEventBloc>(), isA<MassiveEventBloc>());
    });
  });

  testWidgets('autenticado: /users', (tester) async {
    await pumpAuthenticated(tester, '/users');
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(UsersListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autenticado: /purchase/reception/:purchaseId recibe el id', (
    tester,
  ) async {
    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/purchase/reception/test-purchase-id',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await tester.pump();

    final PurchaseReceptionPage page = tester.widget<PurchaseReceptionPage>(
      find.byType(PurchaseReceptionPage),
    );
    expect(page.purchaseId, 'test-purchase-id');
  });

  testWidgets('autenticado: /cattle', (tester) async {
    await pumpAuthenticated(tester, '/cattle');
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(CattleMasterListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'autenticado con create en devices: /equipment-resources/import (sin bloqueo móvil)',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});
      await SessionService.saveSession(
        token: 't',
        permissions: <String, dynamic>{
          'PROD_CENTER': <String, dynamic>{'devices': '10000'},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/equipment-resources/import',
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await pumpRouterFrames(tester);
      await tester.pump();

      expect(find.byType(ImportLw001DevicesPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('goNamed purchasesList abre PurchasesListPage', (tester) async {
    await runWithRouterMockHttp(() async {
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/home',
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await pumpRouterFrames(tester);
      router.goNamed('purchasesList');
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(PurchasesListPage), findsOneWidget);
    });
  });

  testWidgets('goNamed purchasesPending abre lista pendiente', (tester) async {
    await runWithRouterMockHttp(() async {
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/home',
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await pumpRouterFrames(tester);
      router.goNamed('purchasesPending');
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(PurchasesListPage), findsOneWidget);
      final page = tester.widget<PurchasesListPage>(
        find.byType(PurchasesListPage),
      );
      expect(page.initialStatusFilter, 'open');
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/shared/features/users/pages/users_list_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchases_list_page.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/pages/purchase_reception_page.dart';
import 'package:finca_app_frontend/modules/web/features/sales/pages/create_sale_page_web.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../support/router_test_host.dart';

// Bajo prueba: lib/router/router.dart y builders que enlazan a:
// - lib/modules/shared/features/massiveEvent/pages/massive_event_page.dart
// - lib/modules/shared/features/sales/pages/sale_dashboard_page_export.dart
// - lib/modules/shared/features/users/pages/users_list_page.dart
// - lib/modules/web/features/cattle/pages/cattle_master_list_page.dart
// - lib/modules/web/features/cattle_purchase/pages/purchase_form_page.dart
// - lib/modules/web/features/cattle_purchase/pages/purchases_list_page.dart
// - lib/modules/web/features/purchase_reception/pages/purchase_reception_page.dart
// - lib/modules/web/features/sales/pages/create_sale_page_web.dart
// (y MassiveEventBloc en la ruta massive-events/create).

void main() {
  Future<void> pumpAuthenticated(WidgetTester tester, String location) async {
    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: location,
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
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

  testWidgets('autenticado: /purchases/create', (tester) async {
    await pumpAuthenticated(tester, '/purchases/create');
    expect(find.byType(PurchaseFormPage), findsOneWidget);
  });

  testWidgets('autenticado: /purchases', (tester) async {
    await pumpAuthenticated(tester, '/purchases');
    expect(find.byType(PurchasesListPage), findsOneWidget);
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

  testWidgets(
    'autenticado: /massive-events/create expone MassiveEventBloc',
    (tester) async {
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
    },
  );

  testWidgets('autenticado: /users', (tester) async {
    await pumpAuthenticated(tester, '/users');
    expect(find.byType(UsersListPage), findsOneWidget);
  });

  testWidgets(
    'autenticado: /purchase/reception/:purchaseId recibe el id',
    (tester) async {
      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/purchase/reception/test-purchase-id',
      );
      await tester.pumpWidget(buildRouterTestHost(router));
      await tester.pump();

      final PurchaseReceptionPage page =
          tester.widget<PurchaseReceptionPage>(
            find.byType(PurchaseReceptionPage),
          );
      expect(page.purchaseId, 'test-purchase-id');
    },
  );

  testWidgets('autenticado: /cattle', (tester) async {
    await pumpAuthenticated(tester, '/cattle');
    expect(find.byType(CattleMasterListPage), findsOneWidget);
  });
}

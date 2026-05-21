import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/create_sale_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sales_dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';

import '../../../../support/router_test_host.dart';

class MockSalesDataSource extends Mock implements ISalesDataSource {}

void main() {
  late MockSalesDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(const SalesQuery());
  });

  setUp(() {
    dataSource = MockSalesDataSource();
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    HomeConnectivityService.debugForceOnline = true;
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    HomeConnectivityService.debugForceOnline = null;
  });

  testWidgets('con update muestra Editar y navega sin diálogo de solo notas', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await SessionService.saveSession(
      token: 't.ok',
      permissions: {
        'COMMERCE': {'sales': '11111'},
      },
      idTenant: 'tid',
      idUser: 'uid',
    );

    final sale = SaleModel(
      id: 'sale-dash-1',
      idTenant: 'tid',
      transactionDate: DateTime(2025, 2, 1),
      buyerId: 'buyer-1',
      minWeightConfig: 300,
      valuePerKgConfig: 5,
      totalAmount: 2000,
      totalWeight: 400,
      totalCount: 1,
      notes: 'nota original',
      buyerName: 'Buyer Test',
    );

    when(() => dataSource.getSales(any())).thenAnswer(
      (_) async => PaginatedSales(items: [sale], total: 1),
    );
    when(() => dataSource.getSaleById('sale-dash-1')).thenAnswer((_) async => sale);

    late AppLocalizations l10n;
    final router = GoRouter(
      initialLocation: '/sales',
      routes: [
        GoRoute(
          path: '/sales',
          builder: (_, _) => SaleDashboardPage(dataSource: dataSource),
        ),
        GoRoute(
          path: '/sales/edit/:id',
          builder:
              (_, state) => CreateSalePage(
                saleId: state.pathParameters['id'],
                dataSource: dataSource,
              ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    await tester.pump(const Duration(milliseconds: 500));

    l10n = AppLocalizations.of(tester.element(find.byType(SaleDashboardPage)))!;
    expect(find.byIcon(Icons.edit), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(AlertDialog), findsNothing);
    expect(router.state.uri.toString(), contains('/sales/edit/sale-dash-1'));
    expect(find.text(l10n.sale_editTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

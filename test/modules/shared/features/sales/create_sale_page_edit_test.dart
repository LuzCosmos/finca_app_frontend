import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/create_sale_page.dart';

import '../../../../support/app_test_host.dart';

class MockSalesDataSource extends Mock implements ISalesDataSource {}

void main() {
  late MockSalesDataSource dataSource;

  setUp(() {
    dataSource = MockSalesDataSource();
    when(() => dataSource.getBusinessPartners(any())).thenAnswer((_) async => []);
    when(() => dataSource.fetchCatalogs()).thenAnswer((_) async {});
  });

  testWidgets('modo edición muestra título y precarga datos', (tester) async {
    final sale = SaleModel(
      id: 'sale-edit-1',
      idTenant: 't1',
      transactionDate: DateTime(2025, 1, 10),
      buyerId: 'buyer-1',
      minWeightConfig: 350,
      valuePerKgConfig: 4.5,
      totalAmount: 1800,
      totalWeight: 400,
      totalCount: 1,
      buyerName: 'Comprador E2E',
      details: const [
        SaleDetailModel(
          id: 'd1',
          cattleId: 'c1',
          cattleNumber: '100',
          measuredWeight: 400,
          calculatedPrice: 1800,
          isApproved: true,
        ),
      ],
    );

    when(() => dataSource.getSaleById('sale-edit-1')).thenAnswer((_) async => sale);

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: CreateSalePage(
          saleId: 'sale-edit-1',
          dataSource: dataSource,
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    l10n = AppLocalizations.of(tester.element(find.byType(CreateSalePage)))!;
    expect(find.text(l10n.sale_editTitle), findsOneWidget);
    expect(find.text(l10n.sale_saveChanges), findsOneWidget);
    expect(find.text('Comprador E2E'), findsOneWidget);
    expect(find.textContaining('#100'), findsOneWidget);
    verify(() => dataSource.getSaleById('sale-edit-1')).called(1);
  });
}

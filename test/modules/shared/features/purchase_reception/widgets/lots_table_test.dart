import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/lots_table.dart';

import '../purchase_reception_list_table_test_support.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(height: 300, width: 400, child: child)),
  );
}

void main() {
  testWidgets('cabecera y filas con tipografía de tabla de recepción', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        LotsTable(
          lots: [
            {
              'id': 'lot-1',
              'lotNumber': 'L01',
              'purchasedCattleCount': 10,
              'receivedCattleCount': 2,
              'totalWeight': 3500,
              'receivedTotalWeight': 700,
            },
          ],
          onLotSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final table = find.byType(LotsTable);
    expectTableHeaderTypography(tester, table);
    expectTableRowTypography(tester, table);
    expect(find.text('L01'), findsOneWidget);
  });
}

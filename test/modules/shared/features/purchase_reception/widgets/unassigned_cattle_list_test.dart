import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/unassigned_cattle_list.dart';

import '../purchase_reception_list_table_test_support.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(height: 500, child: child)),
  );
}

void main() {
  testWidgets('sin permiso: no icono editar en reses sin lote', (tester) async {
    await tester.pumpWidget(
      _wrap(
        UnassignedCattleList(
          cattle: [
            {
              'id': 'c1',
              'number': '9',
              'receivedWeight': 280,
            },
          ],
          availableLots: [],
          canEditCattle: false,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit), findsNothing);
    expectNoActionsColumnHeaderLabel(tester);
  });

  testWidgets('con permiso: editar azul abre diálogo', (tester) async {
    await tester.pumpWidget(
      _wrap(
        UnassignedCattleList(
          cattle: [
            {
              'id': 'c1',
              'number': '9',
              'receivedWeight': 280,
              'color': 'BLACK',
            },
          ],
          availableLots: [
            {'id': 'lot-1', 'lotNumber': 3},
          ],
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectCompactEditIconButton(tester);
    expectNoActionsColumnHeaderLabel(tester);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(EditReceivedCattleDialog), findsOneWidget);
  });

  testWidgets('sin botón asignar lote', (tester) async {
    await tester.pumpWidget(
      _wrap(
        UnassignedCattleList(
          cattle: [
            {'id': 'c1', 'number': '9', 'receivedWeight': 280},
          ],
          availableLots: [],
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.playlist_add), findsNothing);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('cabecera sin etiqueta Acciones y botón editar compacto', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        UnassignedCattleList(
          cattle: [
            {'id': 'c1', 'number': '9', 'receivedWeight': 280},
          ],
          availableLots: [],
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectNoActionsColumnHeaderLabel(tester);
    expectCompactEditIconButton(tester);
    expectTableHeaderTypography(tester, find.byType(UnassignedCattleList));
    expectTableRowTypography(tester, find.byType(UnassignedCattleList));
  });
}

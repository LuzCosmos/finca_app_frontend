import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/cattle_list_with_events.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';

import '../purchase_reception_list_table_test_support.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(height: 600, child: child)),
  );
}

void main() {
  testWidgets('sin permiso no muestra icono editar', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CattleListWithEvents(
          cattle: [
            {
              'id': 'c1',
              'number': '1',
              'receivedWeight': 300,
              'appliedEvents': <dynamic>[],
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

  testWidgets('con permiso muestra editar azul y abre diálogo', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CattleListWithEvents(
          cattle: [
            {
              'id': 'c1',
              'number': '42',
              'receivedWeight': 300,
              'appliedEvents': <dynamic>[],
            },
          ],
          availableLots: [
            {'id': 'lot-1', 'lotNumber': 1},
          ],
          canEditCattle: true,
          currentLotId: 'lot-1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectCompactEditIconButton(tester);
    expectNoActionsColumnHeaderLabel(tester);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(EditReceivedCattleDialog), findsOneWidget);
    expect(find.textContaining('42'), findsWidgets);
  });

  testWidgets('sin botón asignar lote (solo editar)', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CattleListWithEvents(
          cattle: [
            {
              'id': 'c1',
              'number': '1',
              'receivedWeight': 300,
              'appliedEvents': <dynamic>[],
            },
          ],
          availableLots: [
            {'id': 'lot-1', 'lotNumber': 1},
          ],
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.playlist_add), findsNothing);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('evento castración muestra etiqueta localizada, no el id', (
    tester,
  ) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('es'));

    await tester.pumpWidget(
      _wrap(
        CattleListWithEvents(
          cattle: [
            {
              'id': 'c1',
              'number': '1',
              'receivedWeight': 300,
              'appliedEvents': [
                {
                  'id': 'ase-1',
                  'type': 'castration',
                  'data': null,
                  'appliedAt': '2025-06-01T10:00:00.000Z',
                },
              ],
            },
          ],
          availableLots: [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();

    expect(find.text(l10n.eventTypeCastration), findsOneWidget);
    expect(find.text('ase-1'), findsNothing);
  });

  testWidgets('cabecera sin etiqueta Acciones y filas con tipografía 14px', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CattleListWithEvents(
          cattle: [
            {
              'id': 'c1',
              'number': '7',
              'receivedWeight': 300,
              'appliedEvents': <dynamic>[],
            },
          ],
          availableLots: [],
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectNoActionsColumnHeaderLabel(tester);
    expectTableHeaderTypography(tester, find.byType(CattleListWithEvents));
    expectTableRowTypography(tester, find.byType(CattleListWithEvents));
  });
}

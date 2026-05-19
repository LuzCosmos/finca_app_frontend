import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/unassigned_cattle_list.dart';

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
          onAssignLot: (_, __) {},
          canEditCattle: false,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit), findsNothing);
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
          onAssignLot: (_, __) {},
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final edit = find.byIcon(Icons.edit);
    expect(edit, findsOneWidget);
    expect(tester.widget<Icon>(edit).color, Colors.blue);

    await tester.tap(edit);
    await tester.pumpAndSettle();
    expect(find.byType(EditReceivedCattleDialog), findsOneWidget);
  });
}

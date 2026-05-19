import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/cattle_list_with_events.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';

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
          onAssignLot: (_, __) {},
          canEditCattle: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.edit), findsNothing);
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
          onAssignLot: (_, __) {},
          canEditCattle: true,
          currentLotId: 'lot-1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final editIcon = find.byIcon(Icons.edit);
    expect(editIcon, findsOneWidget);
    final icon = tester.widget<Icon>(editIcon);
    expect(icon.color, Colors.blue);

    await tester.tap(editIcon);
    await tester.pumpAndSettle();

    expect(find.byType(EditReceivedCattleDialog), findsOneWidget);
    expect(find.textContaining('42'), findsWidgets);
  });

  testWidgets('muestra botón asignar lote junto a editar', (tester) async {
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
          onAssignLot: (_, __) {},
          canEditCattle: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.playlist_add), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}

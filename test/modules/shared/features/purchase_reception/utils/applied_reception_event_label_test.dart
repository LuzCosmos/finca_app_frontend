import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/applied_reception_event_label.dart';

void main() {
  testWidgets('muestra Castración cuando type es castration', (tester) async {
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            final title = appliedReceptionEventTitle(context, {
              'id': 'ase-uuid',
              'type': 'castration',
              'data': null,
            }, l10n);
            return Text(title);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.eventTypeCastration), findsOneWidget);
    expect(find.text('ase-uuid'), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_on_feed_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_on_feed_report_widget.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(body: child),
    );
  }

  testWidgets('modo embebido muestra métricas de cuido', (tester) async {
    const data = CattleOnFeedReportModel(
      onFeedCount: 3,
      activeCount: 10,
      soldCount: 5,
      activeAndSoldTotal: 15,
    );

    await tester.pumpWidget(
      wrap(
        const CattleOnFeedReportWidget(
          isLoading: false,
          hasError: false,
          data: data,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('En cuido: 3'), findsOneWidget);
    expect(find.textContaining('Activas: 10'), findsOneWidget);
    expect(find.textContaining('Total: 15'), findsOneWidget);
  });

  testWidgets('modo embebido con error muestra mensaje', (tester) async {
    await tester.pumpWidget(
      wrap(
        const CattleOnFeedReportWidget(
          isLoading: false,
          hasError: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No se pudieron cargar los reportes.'), findsOneWidget);
  });
}

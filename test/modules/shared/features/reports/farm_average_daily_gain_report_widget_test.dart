import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/farm_average_daily_gain_report_widget.dart';

import 'reports_test_helpers.dart';

void main() {
  setUp(() async {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    BasicApiService.setBaseUrl('http://test.api/api/v1');
    await saveReportsTestSession();
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(body: child),
    );
  }

  testWidgets('modo standalone sin datos muestra empty', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(wrap(const FarmAverageDailyGainReportWidget()));
      await pumpReportsWidget(tester);

      expect(
        find.text('No hay datos para calcular la ganancia diaria promedio.'),
        findsOneWidget,
      );
    }, () {
      return MockClient((request) async {
        expect(
          request.url.path.endsWith('/reports/general/farm-average-daily-gain'),
          isTrue,
        );
        return http.Response(
          jsonEncode({'farmAverageDailyGainKg': null, 'hasData': false}),
          200,
        );
      });
    });
  });

  testWidgets('modo standalone con datos muestra valor formateado', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(wrap(const FarmAverageDailyGainReportWidget()));
      await pumpReportsWidget(tester);

      expect(find.textContaining('0.733 kg/día'), findsOneWidget);
    }, () {
      return MockClient((request) async {
        return http.Response(
          jsonEncode({'farmAverageDailyGainKg': 0.733, 'hasData': true}),
          200,
        );
      });
    });
  });
}

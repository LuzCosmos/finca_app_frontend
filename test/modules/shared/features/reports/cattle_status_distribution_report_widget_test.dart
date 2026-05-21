import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_status_distribution_report_widget.dart';

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

  testWidgets('modo standalone llama solo cattle-by-status', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(wrap(const CattleStatusDistributionReportWidget()));
      await pumpReportsWidget(tester);

      expect(find.textContaining('Total: 18'), findsOneWidget);
      expect(find.textContaining('Activas: 10'), findsOneWidget);
    }, () {
      return MockClient((request) async {
        expect(request.url.path.endsWith('/reports/general/cattle-by-status'), isTrue);
        expect(request.url.path.contains('/summary'), isFalse);
        expect(request.url.path.contains('cattle-on-feed'), isFalse);
        return http.Response(
          jsonEncode({
            'totalCount': 18,
            'byStatus': {'ACTIVE': 10, 'SOLD': 5, 'DEAD': 2, 'LOST': 1},
          }),
          200,
        );
      });
    });
  });
}

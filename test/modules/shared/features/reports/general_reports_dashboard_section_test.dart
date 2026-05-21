import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/widgets/cattle_last_locations_map_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_on_feed_report_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_status_distribution_report_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/farm_average_daily_gain_report_widget.dart';

import '../../../../support/app_test_host.dart';
import 'reports_test_helpers.dart';

void main() {
  setUp(() async {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    BasicApiService.setBaseUrl('http://test.api/api/v1');
    CattleLastLocationsMapWidget.debugDisableTestPlaceholder = true;
    await saveReportsTestSession();
  });

  tearDown(() {
    CattleLastLocationsMapWidget.debugDisableTestPlaceholder = null;
  });

  const summaryBody = {
    'cattleOnFeed': {
      'onFeedCount': 2,
      'activeCount': 5,
      'soldCount': 1,
      'activeAndSoldTotal': 6,
    },
    'cattleByStatus': {
      'totalCount': 8,
      'byStatus': {'ACTIVE': 5, 'SOLD': 1, 'DEAD': 1, 'LOST': 1},
    },
    'farmAverageDailyGain': {
      'farmAverageDailyGainKg': 0.8,
      'hasData': true,
    },
  };

  testWidgets('DashboardPage: reportes generales cargan desde summary', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await http.runWithClient(() async {
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: const DashboardPage(),
          locale: const Locale('es'),
        ),
      );
      await pumpReportsWidget(tester);

      expect(find.byType(CattleOnFeedReportWidget), findsOneWidget);
      expect(find.byType(CattleStatusDistributionReportWidget), findsOneWidget);
      expect(find.byType(FarmAverageDailyGainReportWidget), findsOneWidget);

      expect(find.textContaining('En cuido: 2'), findsOneWidget);
      expect(find.textContaining('Total: 8'), findsOneWidget);
      expect(find.textContaining('0.800 kg/día'), findsOneWidget);
    }, () {
      return MockClient((request) async {
        if (request.url.path.endsWith('/reports/general/summary')) {
          return http.Response(jsonEncode(summaryBody), 200);
        }
        return http.Response('[]', 200);
      });
    });
  });

  testWidgets('DashboardPage: fallo de summary muestra error en los tres widgets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await http.runWithClient(() async {
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: const DashboardPage(),
          locale: const Locale('es'),
        ),
      );
      await pumpReportsWidget(tester);

      expect(find.text('No se pudieron cargar los reportes.'), findsNWidgets(3));
    }, () {
      return MockClient((request) async {
        if (request.url.path.endsWith('/reports/general/summary')) {
          return http.Response('error', 500);
        }
        return http.Response('[]', 200);
      });
    });
  });
}

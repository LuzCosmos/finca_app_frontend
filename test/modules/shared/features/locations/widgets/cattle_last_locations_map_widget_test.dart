import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/utils/location_time_formatter.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/widgets/cattle_last_locations_map_widget.dart';

import '../../../../../support/app_test_host.dart';

void main() {
  setUp(() {
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    BasicApiService.setBaseUrl('http://test.api/api/v1');
    SharedPreferences.setMockInitialValues({});
    CattleLastLocationsMapWidget.debugDisableTestPlaceholder = true;
  });

  tearDown(() {
    CattleLastLocationsMapWidget.debugDisableTestPlaceholder = null;
  });

  Future<void> saveTestSession() async {
    final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400;
    await SessionService.saveSession(
      token:
          'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.'
          '${base64Url.encode(utf8.encode(jsonEncode({'exp': exp})))}.'
          'sig',
      permissions: {'FARM': {'cattle': true, 'locations': true}},
      idTenant: 't-map',
      idUser: 'u-map',
      refreshToken: 'rt',
    );
    await SessionService.hydrateFromStorage();
  }

  testWidgets(
    'DashboardPage: mapa cargado y tap en marcador muestra número y time formateado',
    (tester) async {
      await saveTestSession();

      const cattleNumber = 'E2E-042';
      final timeUtc = DateTime.utc(2026, 5, 1, 12, 0);
      final expectedLabel =
          '$cattleNumber • ${formatLocationTime(timeUtc)}';

      await http.runWithClient(() async {
        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: const DashboardPage(),
            locale: const Locale('es'),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byIcon(Icons.location_on), findsOneWidget);

        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pumpAndSettle();

        expect(find.text(expectedLabel), findsOneWidget);
        expect(tester.takeException(), isNull);
      }, () {
        return MockClient((request) async {
          if (request.url.path.endsWith('/locations/latest/cattle')) {
            return http.Response(
              jsonEncode([
                {
                  'id_tenant': 't-map',
                  'id_device': 'd1',
                  'id_cattle': 'c1',
                  'latitude': '4.700200',
                  'longitude': '-74.100200',
                  'altitude': null,
                  'time': timeUtc.toIso8601String(),
                  'cattle_number': cattleNumber,
                },
              ]),
              200,
            );
          }
          return http.Response('[]', 200);
        });
      });
    },
  );

  testWidgets('estado empty cuando la API devuelve lista vacía', (tester) async {
    await saveTestSession();
    final l10n = await AppLocalizations.delegate.load(const Locale('es'));

    await http.runWithClient(() async {
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: const CattleLastLocationsMapWidget(height: 200),
          locale: const Locale('es'),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text(l10n.locations_map_empty), findsOneWidget);
      expect(find.byType(FlutterMap), findsNothing);
    }, () {
      return MockClient(
        (_) async => http.Response('[]', 200),
      );
    });
  });
}

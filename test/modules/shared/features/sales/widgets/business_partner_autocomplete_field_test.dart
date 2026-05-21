import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/widgets/business_partner_input.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/business_partner_autocomplete_field.dart';
import '../../../../../support/app_test_host.dart';

String _jwtWithExp(int offsetSeconds) {
  final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + offsetSeconds;
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': exp})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

Future<void> _hydrateAuth() async {
  await SessionService.saveSession(
    token: _jwtWithExp(7200),
    permissions: {},
    idTenant: 'tid',
    idUser: 'u',
    refreshToken: 'rt',
  );
  BasicApiService.setBaseUrl('https://api-bp-widget.test/api/v1');
}

List<Map<String, dynamic>> _mockSearchResults() => [
  {'id': 'bp-1', 'name': 'Ganadería Alpha', 'nit': '900111', 'type': 'PROVIDER'},
  {'id': 'bp-2', 'name': 'Ganadería Beta', 'nit': '900222', 'type': 'PROVIDER'},
];

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  group('BusinessPartnerAutocompleteField', () {
    testWidgets('búsqueda con debounce muestra resultados y selección dispara onChanged', (
      tester,
    ) async {
      await _hydrateAuth();
      String? selectedId;
      String? selectedName;
      Uri? searchUri;

      await http.runWithClient(() async {
        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: Scaffold(
              body: BusinessPartnerAutocompleteField(
                label: 'Proveedor test',
                businessPartnerRole: BusinessPartnerRole.PROVIDER.name,
                onChanged: (id, name, {buyerMinWeightKg}) {
                  selectedId = id;
                  selectedName = name;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'Gana');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();

        expect(find.text('Ganadería Alpha'), findsOneWidget);
        expect(find.text('Ganadería Beta'), findsOneWidget);

        await tester.tap(find.text('Ganadería Alpha'));
        await tester.pump();
      }, () {
        return MockClient((req) async {
          if (req.method == 'GET' && req.url.path.contains('/business-partners/search')) {
            searchUri = req.url;
            return http.Response(jsonEncode(_mockSearchResults()), 200);
          }
          return http.Response('not found', 404);
        });
      });

      expect(searchUri, isNotNull);
      expect(searchUri!.queryParameters['name'], 'Gana');
      expect(searchUri!.queryParameters['type'], 'PROVIDER');
      expect(selectedId, 'bp-1');
      expect(selectedName, 'Ganadería Alpha');
      expect(find.text('Ganadería Alpha'), findsWidgets);
    });

    testWidgets('sin resultados muestra opción de crear nuevo tercero', (tester) async {
      await _hydrateAuth();

      await http.runWithClient(() async {
        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: Scaffold(
              body: BusinessPartnerAutocompleteField(
                label: 'Comprador test',
                businessPartnerRole: BusinessPartnerRole.BUYER.name,
                onChanged: (_, __, {buyerMinWeightKg}) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'ZZZ');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();

        expect(find.byIcon(Icons.add_circle), findsOneWidget);
      }, () {
        return MockClient((req) async {
          if (req.method == 'GET' && req.url.path.contains('/business-partners/search')) {
            return http.Response(jsonEncode([]), 200);
          }
          return http.Response('not found', 404);
        });
      });
    });
  });

  group('BusinessPartnerInput', () {
    testWidgets('rol PROVIDER delega búsqueda a /business-partners/search', (tester) async {
      await _hydrateAuth();
      BusinessPartnerModel? selected;
      Uri? searchUri;

      await http.runWithClient(() async {
        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: Scaffold(
              body: BusinessPartnerInput(
                onBusinessPartnerSelected: (bp) => selected = bp,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'E2E');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();

        await tester.tap(find.text('E2E Provider Widget'));
        await tester.pump();
      }, () {
        return MockClient((req) async {
          if (req.method == 'GET' && req.url.path.contains('/business-partners/search')) {
            searchUri = req.url;
            return http.Response(
              jsonEncode([
                {
                  'id': 'bp-prov',
                  'name': 'E2E Provider Widget',
                  'nit': '900333',
                  'type': 'PROVIDER',
                },
              ]),
              200,
            );
          }
          return http.Response('not found', 404);
        });
      });

      expect(searchUri!.queryParameters['type'], 'PROVIDER');
      expect(selected?.id, 'bp-prov');
      expect(selected?.name, 'E2E Provider Widget');
      expect(selected?.role, BusinessPartnerRole.PROVIDER);
    });
  });
}

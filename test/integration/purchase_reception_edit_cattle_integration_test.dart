import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/cattle_list_with_events.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/unassigned_cattle_list.dart';

import '../modules/shared/features/purchase_reception/purchase_reception_list_table_test_support.dart';
import '../../integration_test/support/integration_test_session.dart';

String _jwtWithExp(int expUnix) {
  final header = base64Url.encode(
    utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})),
  );
  final payload = base64Url.encode(
    utf8.encode(jsonEncode({'exp': expUnix})),
  );
  return '$header.$payload.dummy';
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    integrationBindOnlineApiForTests();
  });

  tearDown(integrationResetOnlineApiForTests);

  testWidgets(
    'integración: ReceptionApiService.updateReceivedCattle con sesión y mock HTTP',
    (tester) async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'RECEPTION': {'receptions': true},
        },
        idTenant: 't-int',
        idUser: 'u-int',
        refreshToken: 'rt',
      );
      BasicApiService.setBaseUrl('https://api-int.test/api/v1');

      await http.runWithClient(() async {
        final api = ReceptionApiService();
        await api.updateReceivedCattle(
          cattleId: 'c-int',
          body: {
            'receivedWeight': 310,
            'color': 'BLACK',
            'idLot': 'lot-int',
          },
        );
      }, () {
        return MockClient((req) async {
          expect(req.method, 'PATCH');
          expect(req.url.path, contains('received-cattle/c-int'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['receivedWeight'], 310);
          return http.Response('{}', 200);
        });
      });
    },
  );

  testWidgets('integración: lista sin lote con permiso muestra editar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: UnassignedCattleList(
            cattle: [
              {'id': 'u1', 'number': '88', 'receivedWeight': 290},
            ],
            availableLots: [],
            canEditCattle: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expectCompactEditIconButton(tester);
    expectNoActionsColumnHeaderLabel(tester);
  });
}

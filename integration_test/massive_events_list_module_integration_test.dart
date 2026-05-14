import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/data/database/database_provider.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/router/router.dart';

// Integración (dispositivo / `flutter drive`): MainApp + GoRouter con sesión,
// ruta dedicada `/massive-events` y API inalcanzable → UI de error/reintento.

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await DatabaseProvider.close();
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  testWidgets(
    'ruta inicial /massive-events: lista a pantalla completa y reintento si API cae',
    (tester) async {
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({});
      BasicApiService.setBaseUrl('http://127.0.0.1:9');

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now + 86400),
        permissions: {
          'MASSIVE_EVENTS': {'massive_events': true},
        },
        idTenant: 't-integration-list',
        idUser: 'u-integration-list',
        refreshToken: 'rt',
      );
      await SessionService.hydrateFromStorage();

      final router = createAppRouter(
        hasValidToken: () => true,
        initialLocation: '/massive-events',
      );

      await tester.pumpWidget(MainApp(router: router));
      await tester.pumpAndSettle(const Duration(seconds: 20));

      expect(find.byType(MassiveEventListPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('massive-event-list-page')),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

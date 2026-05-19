import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/router/router.dart';

/// Permisos típicos de un usuario con acceso a todos los módulos del menú Home.
Map<String, dynamic> integrationFullHomePermissions() {
  return {
    'MASSIVE_EVENTS': {'massive_events': true},
    'COMMERCE': {'purchases': true, 'sales': true},
    'EMP_MGMT': {'users': true},
    'FARM': {'cattle': true},
    'PROD_CENTER': {'devices': true},
  };
}

void integrationBindApiForTests() {
  BasicApiService.resetForTesting();
  BasicApiService.setBaseUrl('http://127.0.0.1:9');
}

void integrationForceOnlineForTests() {
  HomeConnectivityService.debugForceOnline = true;
}

/// API inalcanzable + menú online forzado (mayoría de pruebas de integración).
void integrationBindOnlineApiForTests() {
  integrationBindApiForTests();
  integrationForceOnlineForTests();
}

void integrationResetOnlineApiForTests() {
  HomeConnectivityService.debugForceOnline = null;
  BasicApiService.resetForTesting();
}

void expectAllHomeMenuOptionsVisible(AppLocalizations l10n) {
  expect(find.text(l10n.dashboard_title), findsOneWidget);
  expect(find.text(l10n.purchase), findsOneWidget);
  expect(find.text(l10n.massiveEvent), findsOneWidget);
  expect(find.text(l10n.sale), findsOneWidget);
  expect(find.text(l10n.users), findsOneWidget);
  expect(find.text(l10n.masterListTitle), findsOneWidget);
  expect(find.text(l10n.equipmentAndResource_title), findsOneWidget);
}

Future<void> pumpIntegrationHomeWithFullPermissions(
  WidgetTester tester, {
  required String token,
}) async {
  SessionService.resetForTesting();
  SharedPreferences.setMockInitialValues({});
  integrationBindApiForTests();

  await SessionService.saveSession(
    token: token,
    permissions: integrationFullHomePermissions(),
    idTenant: 't-integration-home',
    idUser: 'u-integration-home',
    refreshToken: 'rt-home',
  );
  await SessionService.hydrateFromStorage();

  final router = createAppRouter(
    hasValidToken: () => true,
    initialLocation: '/home',
  );
  await tester.pumpWidget(MainApp(router: router));
  await tester.pumpAndSettle(const Duration(seconds: 8));
}

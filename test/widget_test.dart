import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/router/router.dart';

// Bajo prueba: lib/main.dart (MainApp), lib/router/router.dart, lib/core/services/session_service.dart.

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MainApp: without session redirects to login', (
    WidgetTester tester,
  ) async {
    await SessionService.hydrateFromStorage();

    await tester.pumpWidget(
      MainApp(router: createAppRouter(hasValidToken: () => false)),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('login-username-field')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

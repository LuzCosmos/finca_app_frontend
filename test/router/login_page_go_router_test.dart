import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../support/auth_test_doubles.dart';
import '../support/router_test_host.dart';

// Bajo prueba:
// - lib/modules/shared/features/auth/page/login_page.dart (context.go tras login)
// - lib/router/router.dart (redirect + ruta /login con auth inyectable)
// - lib/core/services/session_service.dart

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LoginPage + GoRouter: fake login navega a /home', (
    tester,
  ) async {
    final router = createAppRouter(
      hasValidToken: SessionService.hasValidTokenSync,
      initialLocation: '/login',
      loginAuthService: FakeAuthService(success: loginSuccessPayload()),
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);

    expect(find.byKey(const ValueKey<String>('login-page')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login-username-field')),
      'alice',
    );
    await tester.enterText(find.byKey(const Key('login-password-field')), 'secret');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
    expect(SessionService.hasValidTokenSync(), isTrue);
    expect(tester.takeException(), isNull);
  });
}

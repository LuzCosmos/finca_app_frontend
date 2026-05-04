import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/auth_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/page/login_page.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/widgets/login_form.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/router/router.dart';

import '../../../../../support/app_test_host.dart';
import '../../../../../support/auth_test_doubles.dart';
import '../../../../../support/router_test_host.dart';

// Bajo prueba:
// - lib/modules/shared/features/auth/page/login_page.dart
// - lib/modules/shared/widgets/finca_scaffold.dart
// - lib/router/router.dart (fallo sin navegar)

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ValueKey login-page, LoginForm y FincaScaffold con title', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const LoginPage(title: 'Título Login');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('login-page')), findsOneWidget);
    expect(find.byType(LoginForm), findsOneWidget);
    expect(find.byType(FincaScaffold), findsOneWidget);
    expect(find.text('Título Login'), findsOneWidget);
    expect(find.text(l10n.username), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ancho > 600: ConstrainedBox maxWidth 400', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: pumpLocalizedMaterialShell(
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final box = tester.widget<ConstrainedBox>(
      find.ancestor(
        of: find.byType(LoginForm),
        matching: find.byType(ConstrainedBox),
      ),
    );
    expect(box.constraints.maxWidth, 400);
  });

  testWidgets('ancho <= 600: sin tope 400 en ConstrainedBox', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(560, 600)),
        child: pumpLocalizedMaterialShell(
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final box = tester.widget<ConstrainedBox>(
      find.ancestor(
        of: find.byType(LoginForm),
        matching: find.byType(ConstrainedBox),
      ),
    );
    expect(box.constraints.maxWidth, double.infinity);
  });

  testWidgets('authService de LoginPage lo usa LoginForm (Recording)', (
    tester,
  ) async {
    final auth = RecordingAuthService(response: loginSuccessPayload());
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: LoginPage(authService: auth),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login-username-field')),
      'bob',
    );
    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'pw',
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(auth.loginCallCount, 1);
    expect(auth.lastUsername, 'bob');
  });

  testWidgets('fallo login con router: no navega a home', (tester) async {
    final router = createAppRouter(
      hasValidToken: SessionService.hasValidTokenSync,
      initialLocation: '/login',
      loginAuthService: ThrowingAuthService(
        AuthException('invalidCredentials'),
      ),
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);

    expect(find.byKey(const ValueKey<String>('login-page')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login-username-field')),
      'u',
    );
    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'p',
    );
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('login-page')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('home-page')), findsNothing);
    expect(SessionService.hasValidTokenSync(), isFalse);
  });
}

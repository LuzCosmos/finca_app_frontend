import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/models/user_model.dart';
import 'package:finca_app_frontend/core/services/auth_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/widgets/login_form.dart';

import '../../../../../support/auth_test_doubles.dart';
import '../../../../../support/session_test_utils.dart';

// Bajo prueba:
// - lib/modules/shared/features/auth/widgets/login_form.dart
// - lib/core/services/session_service.dart

Future<void> pumpLoginForm(
  WidgetTester tester, {
  required LoginForm child,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: Language.spanish.localeValue,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  group('UI / L10n', () {
    testWidgets('cada etiqueta L10n (es) aparece una vez en decoraciones', (
      tester,
    ) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayload()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;
      expect(find.text(l10n.username), findsOneWidget);
      expect(find.text(l10n.password), findsOneWidget);
      expect(find.text(l10n.company), findsOneWidget);
      expect(find.text(l10n.login), findsOneWidget);
    });

    testWidgets('campo usuario: AutofillHints.username', (tester) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayload()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key('login-username-field')),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.autofillHints, contains(AutofillHints.username));
    });

    testWidgets('campo contraseña: obscureText y AutofillHints.password', (
      tester,
    ) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayload()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key('login-password-field')),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, isTrue);
      expect(textField.autofillHints, contains(AutofillHints.password));
    });

    testWidgets('campo empresa: valor inicial GPCB', (tester) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayload()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final field =
          tester.widget<TextFormField>(
            find.byKey(const Key('login-company-field')),
          );
      expect(field.initialValue, 'GPCB');
      expect(find.text('GPCB'), findsWidgets);
    });
  });

  group('RecordingAuthService.login', () {
    testWidgets('envía username, password y company por defecto GPCB', (
      tester,
    ) async {
      final auth = RecordingAuthService(response: loginSuccessPayload());
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'alice',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'secret',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(auth.loginCallCount, 1);
      expect(auth.lastUsername, 'alice');
      expect(auth.lastPassword, 'secret');
      expect(auth.lastCompanyUsername, 'GPCB');
    });

    testWidgets('envía companyUsername tras editar campo empresa', (
      tester,
    ) async {
      final auth = RecordingAuthService(response: loginSuccessPayload());
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'alice',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'secret',
      );
      await tester.enterText(
        find.byKey(const Key('login-company-field')),
        'ACME',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(auth.loginCallCount, 1);
      expect(auth.lastCompanyUsername, 'ACME');
    });
  });

  group('validación', () {
    testWidgets('vacío: mensajes L10n, sin login, sin éxito, sin sesión', (
      tester,
    ) async {
      final auth = RecordingAuthService(response: loginSuccessPayload());
      var successCalls = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (_) => successCalls++,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_usernameRequired), findsOneWidget);
      expect(find.text(l10n.login_passwordRequired), findsOneWidget);
      expect(auth.loginCallCount, 0);
      expect(successCalls, 0);
      await expectEmptySession();
    });

    testWidgets('solo espacios en usuario/contraseña: validación L10n', (
      tester,
    ) async {
      final auth = RecordingAuthService(response: loginSuccessPayload());
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        '   ',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        ' \t ',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_usernameRequired), findsOneWidget);
      expect(find.text(l10n.login_passwordRequired), findsOneWidget);
      expect(auth.loginCallCount, 0);
    });

    testWidgets(
      'empresa solo espacios: aún envía companyUsername con trim del campo',
      (tester) async {
        final auth = RecordingAuthService(response: loginSuccessPayload());
        await pumpLoginForm(
          tester,
          child: LoginForm(
            authService: auth,
            onLoginSuccess: (_) {},
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('login-username-field')),
          'u',
        );
        await tester.enterText(
          find.byKey(const Key('login-password-field')),
          'p',
        );
        await tester.enterText(
          find.byKey(const Key('login-company-field')),
          '   ',
        );
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(auth.loginCallCount, 1);
        expect(auth.lastCompanyUsername, '   ');
      },
    );
  });

  group('estado de carga', () {
    testWidgets('muestra CircularProgressIndicator y oculta botón; tras éxito revierte', (
      tester,
    ) async {
      final completer = Completer<Map<String, dynamic>>();
      final auth = CompleterAuthService(completer);
      Map<String, dynamic>? received;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (m) => received = m,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'alice',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'secret',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);

      completer.complete(loginSuccessPayload());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(received, isNotNull);
    });

    testWidgets('durante loading no hay ElevatedButton (no doble submit)', (
      tester,
    ) async {
      final completer = Completer<Map<String, dynamic>>();
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: CompleterAuthService(completer),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'u',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'p',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsNothing);

      completer.complete(loginSuccessPayload());
      await tester.pumpAndSettle();
    });

    testWidgets('doble tap rápido: login cuenta una sola vez', (tester) async {
      final completer = Completer<Map<String, dynamic>>();
      final auth = RecordingCompleterAuthService(completer);
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: auth,
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(auth.loginCallCount, 1);

      completer.complete(loginSuccessPayload());
      await tester.pumpAndSettle();
    });
  });

  group('login exitoso', () {
    testWidgets('callback, token, refresh, permisos, idTenant, idUser', (
      tester,
    ) async {
      Map<String, dynamic>? received;
      final payload = loginSuccessPayload(idTenant: 't-99', idUser: 'user-42');
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: payload),
          onLoginSuccess: (m) => received = m,
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'alice',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'secret',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(received, isNotNull);
      expect(received!['user'], isA<User>());
      expect(await SessionService.getToken(), 'access-token-test');
      expect(await SessionService.getRefreshToken(), 'refresh-test');
      expect(await SessionService.getIdTenant(), 't-99');
      expect(await SessionService.getIdUser(), 'user-42');
      final perms = await SessionService.getPermissions();
      expect(perms['MASSIVE_EVENTS'], isA<Map>());
      expect(
        (perms['MASSIVE_EVENTS'] as Map)['massive_events'],
        isNotNull,
      );
    });

    testWidgets('sin refreshToken en mapa: sesión sin refresh', (tester) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayloadNoRefreshKey()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(await SessionService.getToken(), 'access-token-test');
      expect(await SessionService.getRefreshToken(), isNull);
    });

    testWidgets('refreshToken null: no persiste refresh', (tester) async {
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(success: loginSuccessPayloadRefreshNull()),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(await SessionService.getRefreshToken(), isNull);
    });
  });

  group('errores', () {
    testWidgets('AuthException invalidCredentials → SnackBar', (tester) async {
      var successCalls = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: ThrowingAuthService(AuthException('invalidCredentials')),
          onLoginSuccess: (_) => successCalls++,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'uu',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')), // password key
        'pp',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_invalidCredentials), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(successCalls, 0);
      await expectEmptySession();
    });

    testWidgets('AuthException otro código → login_unexpectedError', (
      tester,
    ) async {
      var successCalls = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: ThrowingAuthService(AuthException('someOtherError')),
          onLoginSuccess: (_) => successCalls++,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'u',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'p',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(successCalls, 0);
      expect(await SessionService.getToken(), isNull);
      expect(await SessionService.getRefreshToken(), isNull);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Exception genérica → login_unexpectedError y sesión vacía', (
      tester,
    ) async {
      var successCalls = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: ThrowingAuthService(Exception('network')),
          onLoginSuccess: (_) => successCalls++,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'u',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'p',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(successCalls, 0);
      expect(await SessionService.getToken(), isNull);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('payload malformado', () {
    testWidgets('sin user: SnackBar inesperado y sin sesión', (tester) async {
      var ok = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(
            success: {
              'token': 't',
              'permissions': <String, dynamic>{},
              'refreshToken': 'r',
            },
          ),
          onLoginSuccess: (_) => ok++,
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(ok, 0);
      await expectEmptySession();
    });

    testWidgets('user con tipo incorrecto → error', (tester) async {
      var ok = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(
            success: {
              'user': 'nope',
              'token': 't',
              'permissions': <String, dynamic>{},
            },
          ),
          onLoginSuccess: (_) => ok++,
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(ok, 0);
      await expectEmptySession();
    });

    testWidgets('sin token: error al guardar sesión', (tester) async {
      final u = User(
        id: '1',
        username: 'a',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e',
        idTenant: 't',
        roles: const [],
      );
      var ok = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(
            success: {
              'user': u,
              'permissions': <String, dynamic>{},
            },
          ),
          onLoginSuccess: (_) => ok++,
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(ok, 0);
      await expectEmptySession();
    });

    testWidgets('sin permissions: error', (tester) async {
      final u = User(
        id: '1',
        username: 'a',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e',
        idTenant: 't',
        roles: const [],
      );
      var ok = 0;
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: FakeAuthService(
            success: {
              'user': u,
              'token': 'tok',
            },
          ),
          onLoginSuccess: (_) => ok++,
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginForm)))!;

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.login_unexpectedError), findsOneWidget);
      expect(ok, 0);
      await expectEmptySession();
    });
  });

  group('ciclo de vida', () {
    testWidgets('login pendiente y desmontaje: completar future no lanza', (
      tester,
    ) async {
      final completer = Completer<Map<String, dynamic>>();
      await pumpLoginForm(
        tester,
        child: LoginForm(
          authService: CompleterAuthService(completer),
          onLoginSuccess: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-username-field')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'b',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox.shrink()),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);

      completer.complete(loginSuccessPayload());
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(await SessionService.getToken(), isNull);
    });
  });
}

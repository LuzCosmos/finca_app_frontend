import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/router/router.dart';
import '../support/router_test_host.dart';

// Bajo prueba: lib/router/router.dart (GoRouter: redirecciones según sesión y rutas públicas).

void main() {
  testWidgets('desde /loading sin sesión → login', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => false,
      initialLocation: '/loading',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ruta protegida /home sin sesión → login', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => false,
      initialLocation: '/home',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
  });

  testWidgets('/login sin sesión permanece en login', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => false,
      initialLocation: '/login',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
  });

  testWidgets('desde /loading con sesión → home', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/loading',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('home-page')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('/login con sesión activa → home', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/login',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('home-page')),
      findsOneWidget,
    );
  });

  testWidgets('/home con sesión permanece en home', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => true,
      initialLocation: '/home',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('home-page')),
      findsOneWidget,
    );
  });

  testWidgets('/users sin sesión → login', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => false,
      initialLocation: '/users',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
  });

  testWidgets('/massive-events/create sin sesión → login', (tester) async {
    final router = createAppRouter(
      hasValidToken: () => false,
      initialLocation: '/massive-events/create',
    );
    await tester.pumpWidget(buildRouterTestHost(router));
    await pumpRouterFrames(tester);
    expect(
      find.byKey(const ValueKey<String>('login-page')),
      findsOneWidget,
    );
  });
}

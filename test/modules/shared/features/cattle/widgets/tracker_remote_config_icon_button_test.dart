import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/widgets/tracker_remote_config_icon_button.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget materialRouter(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  testWidgets(
    'sin permiso no muestra el icono de configuración remota',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: TrackerRemoteConfigIconButton(
                deveui: '1122334455667788',
                hasRemoteConfigAccess: false,
              ),
            ),
          ),
        ],
      );
      await tester.pumpWidget(materialRouter(router));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings_remote), findsNothing);
    },
  );

  testWidgets('deveui vacío no muestra el icono', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: TrackerRemoteConfigIconButton(
              deveui: '',
              hasRemoteConfigAccess: true,
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(materialRouter(router));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.settings_remote), findsNothing);
  });

  testWidgets('con permiso y deveui navega a remote-config', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: TrackerRemoteConfigIconButton(
              deveui: 'AABBCCDDEEFF0011',
              deviceDisplayName: 'MiCollar',
              hasRemoteConfigAccess: true,
            ),
          ),
        ),
        GoRoute(
          path: '/devices/:deveui/remote-config',
          name: 'deviceRemoteConfig',
          builder: (context, state) {
            final deveui = state.pathParameters['deveui']!;
            final name = state.uri.queryParameters['name'];
            return Scaffold(body: Text('ok:$deveui:${name ?? ''}'));
          },
        ),
      ],
    );
    await tester.pumpWidget(materialRouter(router));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_remote));
    await tester.pumpAndSettle();

    expect(find.text('ok:AABBCCDDEEFF0011:MiCollar'), findsOneWidget);
  });

  testWidgets('onOpenRemoteConfig sustituye el push por defecto', (
    tester,
  ) async {
    var called = false;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TrackerRemoteConfigIconButton(
              deveui: 'AA',
              hasRemoteConfigAccess: true,
              onOpenRemoteConfig: () {
                called = true;
              },
            ),
          ),
        ),
        GoRoute(
          path: '/devices/:deveui/remote-config',
          name: 'deviceRemoteConfig',
          builder: (context, state) => const Scaffold(body: Text('wrong')),
        ),
      ],
    );
    await tester.pumpWidget(materialRouter(router));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_remote));
    await tester.pumpAndSettle();
    expect(called, isTrue);
    expect(find.text('wrong'), findsNothing);
  });
}

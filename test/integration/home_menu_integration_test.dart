import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';

import '../../integration_test/support/integration_test_session.dart';
import '../support/test_l10n.dart';

// Misma lógica que integration_test/all_integration_tests.dart (menú Home),
// ejecutable con `flutter test` sin dispositivo físico.

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
  setUp(integrationBindOnlineApiForTests);

  tearDown(integrationResetOnlineApiForTests);

  testWidgets(
    'home online: permisos completos muestran todas las opciones (rejilla)',
    (tester) async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await pumpIntegrationHomeWithFullPermissions(
        tester,
        token: _jwtWithExp(now + 86400),
      );

      expect(find.byKey(const ValueKey<String>('home-page')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('home-compact-layout')), findsOneWidget);

      final l10n = l10nFromTester(tester);
      expectAllHomeMenuOptionsVisible(l10n);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('home online ancho: rail con todas las opciones', (tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
    await tester.binding.setSurfaceSize(const Size(1280, 900));

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await pumpIntegrationHomeWithFullPermissions(
      tester,
      token: _jwtWithExp(now + 86400),
    );

    expect(find.byKey(const ValueKey<String>('home-wide-layout')), findsOneWidget);
    final l10n = l10nFromTester(tester);
    expect(find.text(l10n.purchase), findsOneWidget);
    expect(find.text(l10n.massiveEvent), findsOneWidget);
    expect(find.text(l10n.sale), findsOneWidget);
    expect(find.text(l10n.users), findsOneWidget);
    expect(find.text(l10n.masterListTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'home offline: solo evento masivo',
    (tester) async {
      HomeConnectivityService.debugForceOnline = false;
      integrationBindApiForTests();

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await pumpIntegrationHomeWithFullPermissions(
        tester,
        token: _jwtWithExp(now + 86400),
      );

      final l10n = l10nFromTester(tester);
      expect(find.text(l10n.massiveEvent), findsOneWidget);
      expect(find.text(l10n.dashboard_title), findsNothing);
      expect(find.text(l10n.purchase), findsNothing);
      expect(find.text(l10n.sale), findsNothing);
      expect(find.text(l10n.users), findsNothing);
      expect(find.text(l10n.masterListTitle), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';

import '../../../../support/app_test_host.dart';

// Bajo prueba (Chrome / web):
// - lib/modules/shared/features/home/page/home_page.dart (forWebOnly + permisos)

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'solo COMMERCE.purchases: muestra tarjeta compras en web',
    (tester) async {
      await SessionService.saveSession(
        token: 't',
        permissions: {
          'COMMERCE': {'purchases': true},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.purchase), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
    skip: !kIsWeb,
  );

  testWidgets(
    'solo COMMERCE.sales: muestra ventas en web',
    (tester) async {
      await SessionService.saveSession(
        token: 't',
        permissions: {
          'COMMERCE': {'sales': true},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.sale), findsOneWidget);
    },
    skip: !kIsWeb,
  );

  testWidgets(
    'solo FARM.cattle: muestra ganado en web',
    (tester) async {
      await SessionService.saveSession(
        token: 't',
        permissions: {
          'FARM': {'cattle': true},
        },
        idTenant: 'tid',
        idUser: 'uid',
      );

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const HomePage();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.masterListTitle), findsOneWidget);
    },
    skip: !kIsWeb,
  );
}

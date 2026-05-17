import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/online_feature_gate.dart';

import '../../../support/app_test_host.dart';

// Bajo prueba: lib/modules/shared/widgets/online_feature_gate.dart

void main() {
  setUp(() {
    HomeConnectivityService.debugForceOnline = null;
  });

  tearDown(() {
    HomeConnectivityService.debugForceOnline = null;
  });

  testWidgets('online: muestra el child', (tester) async {
    HomeConnectivityService.debugForceOnline = true;

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: const OnlineFeatureGate(
          child: Text('contenido-online'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('contenido-online'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('offline: muestra mensaje L10n y no el child', (tester) async {
    HomeConnectivityService.debugForceOnline = false;

    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const OnlineFeatureGate(
              child: Text('contenido-online'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('contenido-online'), findsNothing);
    expect(find.text(l10n.onlineFeatureRequiresConnection), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

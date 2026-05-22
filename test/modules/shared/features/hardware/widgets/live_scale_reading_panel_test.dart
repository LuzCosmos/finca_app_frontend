import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/models/scale_reading_model.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/services/scale_reading_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/widgets/live_scale_reading_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/app_test_host.dart';

ScaleReadingModel _reading({
  required double weight,
  required bool isStable,
}) {
  return ScaleReadingModel(
    deviceId: 'default-scale',
    tenantId: 't1',
    weight: weight,
    unit: 'kg',
    isStable: isStable,
    observedAt: DateTime(2026, 1, 1),
    sequence: 1,
  );
}

void main() {
  tearDown(ScaleReadingService.resetDebugState);

  testWidgets('desconectada: muestra mensaje y botón deshabilitado', (tester) async {
    ScaleReadingService.debugState = ScaleReadingState.empty;

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: const Scaffold(body: LiveScaleReadingPanel()),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(
      tester.element(find.byType(LiveScaleReadingPanel)),
    )!;
    expect(find.text(l10n.scale_disconnected), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('estable: habilita botón y aplica peso al callback', (tester) async {
    ScaleReadingService.debugState = ScaleReadingState(
      status: ScaleConnectionStatus.connected,
      latestReading: _reading(weight: 412.5, isStable: true),
      latestStableReading: _reading(weight: 412.5, isStable: true),
    );

    double? appliedWeight;
    String? appliedFormatted;

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Scaffold(
          body: LiveScaleReadingPanel(
            onApplyStableWeight: (w, f) {
              appliedWeight = w;
              appliedFormatted = f;
            },
          ),
        ),
      ),
    );
    await tester.pump();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(appliedWeight, 412.5);
    expect(appliedFormatted, '412.50');
  });

  testWidgets('inestable: botón deshabilitado', (tester) async {
    ScaleReadingService.debugState = ScaleReadingState(
      status: ScaleConnectionStatus.connected,
      latestReading: _reading(weight: 400, isStable: false),
      latestStableReading: _reading(weight: 400, isStable: false),
    );

    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: const Scaffold(body: LiveScaleReadingPanel()),
      ),
    );
    await tester.pump();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/models/scale_reading_model.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/services/scale_reading_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/widgets/live_scale_reading_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ScaleReadingModel scaleTestReading({
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

void setConnectedStableScale({double weightKg = 412.5}) {
  ScaleReadingService.debugState = ScaleReadingState(
    status: ScaleConnectionStatus.connected,
    latestReading: scaleTestReading(weight: weightKg, isStable: true),
    latestStableReading: scaleTestReading(weight: weightKg, isStable: true),
  );
}

Finder get scalePanelFinder => find.byType(LiveScaleReadingPanel);

Future<void> tapUseStableWeight(WidgetTester tester) async {
  final button = find.descendant(
    of: scalePanelFinder,
    matching: find.byType(FilledButton),
  );
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
}

Future<void> tapUseStableWeightSettle(WidgetTester tester) async {
  await tapUseStableWeight(tester);
  await tester.pumpAndSettle();
}

String useStableWeightLabel(AppLocalizations l10n) => l10n.scale_useStableWeight;

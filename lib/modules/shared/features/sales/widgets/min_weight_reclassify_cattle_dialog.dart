import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

enum MinWeightReclassifyChoice { reclassify, keepClassification }

/// Asks whether to move approved/rejected cattle according to a new sale min weight.
Future<MinWeightReclassifyChoice?> showMinWeightReclassifyCattleDialog({
  required BuildContext context,
  required double previousMinWeightKg,
  required double newMinWeightKg,
  required int approvedCount,
  required int rejectedCount,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<MinWeightReclassifyChoice>(
    context: context,
    barrierDismissible: true,
    builder:
        (ctx) => AlertDialog(
          title: Text(l10n.sale_minWeight_reclassifyTitle),
          content: Text(
            l10n.sale_minWeight_reclassifyMessage(
              _formatKg(previousMinWeightKg),
              _formatKg(newMinWeightKg),
              approvedCount,
              rejectedCount,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(MinWeightReclassifyChoice.keepClassification),
              child: Text(l10n.sale_minWeight_reclassifyNo),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(MinWeightReclassifyChoice.reclassify),
              child: Text(l10n.sale_minWeight_reclassifyYes),
            ),
          ],
        ),
  );
}

String _formatKg(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}

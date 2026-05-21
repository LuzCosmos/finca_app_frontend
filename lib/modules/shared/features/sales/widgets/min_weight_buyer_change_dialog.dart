import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// User choice when changing buyer while sale min weight is already set.
enum MinWeightBuyerChangeChoice { useBuyerDefault, keepCurrent }

/// Confirms whether to replace the current sale min weight with the buyer default.
Future<MinWeightBuyerChangeChoice?> showMinWeightBuyerChangeDialog({
  required BuildContext context,
  required String buyerName,
  required double currentMinWeightKg,
  required double buyerDefaultMinWeightKg,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<MinWeightBuyerChangeChoice>(
    context: context,
    barrierDismissible: true,
    builder:
        (ctx) => AlertDialog(
          title: Text(l10n.sale_minWeight_changeTitle),
          content: Text(
            l10n.sale_minWeight_changeMessage(
              buyerName,
              _formatKg(currentMinWeightKg),
              _formatKg(buyerDefaultMinWeightKg),
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.of(ctx).pop(MinWeightBuyerChangeChoice.keepCurrent),
              child: Text(
                l10n.sale_minWeight_keepCurrent(_formatKg(currentMinWeightKg)),
              ),
            ),
            ElevatedButton(
              onPressed:
                  () =>
                      Navigator.of(ctx).pop(MinWeightBuyerChangeChoice.useBuyerDefault),
              child: Text(
                l10n.sale_minWeight_useBuyerDefault(_formatKg(buyerDefaultMinWeightKg)),
              ),
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

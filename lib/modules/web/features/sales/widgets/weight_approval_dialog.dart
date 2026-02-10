import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Weight Approval Dialog
///
/// Shown when cattle weight is below minimum weight config
/// Allows user to Approve (use for sale) or Reject (exclude from sale)
class WeightApprovalDialog extends StatelessWidget {
  final String cattleNumber;
  final double measuredWeight;
  final double minWeight;

  const WeightApprovalDialog({
    super.key,
    required this.cattleNumber,
    required this.measuredWeight,
    required this.minWeight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Text(l10n!.cattle_weightUnderMin),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (l10n?.cattle_weightUnderMinMessage(
              measuredWeight,
              minWeight,
            )).toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.cattleNumber}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(cattleNumber),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.label_measuredWeight}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${measuredWeight.toStringAsFixed(2)} kg',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.label_minimumWeight}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${minWeight.toStringAsFixed(2)} kg'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n!.cattle_approveQuestion,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(false), // Reject
          icon: const Icon(Icons.cancel, color: Colors.red),
          label: Text(l10n!.cattle_reject),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(true), // Approve
          icon: const Icon(Icons.check_circle),
          label: Text(l10n!.cattle_approve),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Validation Error Dialog
///
/// Shows when cattle validation fails (not found, not ACTIVE, etc.)
class CattleValidationErrorDialog extends StatelessWidget {
  final String cattleNumber;
  final String errorMessage;

  const CattleValidationErrorDialog({
    super.key,
    required this.cattleNumber,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Icon(Icons.error, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Text(l10n!.cattle_validation_invalid),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.cattleNumber} #$cattleNumber',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(errorMessage, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n!.sales_cancel),
        ),
      ],
    );
  }
}

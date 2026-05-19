import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

const _kTableHeaderFontSize = 15.0;
const _kTableRowFontSize = 14.0;
const _kTableHeaderPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 2);
const _kTableRowPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 2);

class LotsTable extends StatelessWidget {
  final List<Map<String, dynamic>> lots;
  final String? selectedLotId;
  final Function(String?) onLotSelected;

  const LotsTable({
    super.key,
    required this.lots,
    this.selectedLotId,
    required this.onLotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              l10n.purchaseBatchesTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          // Table Header
          Container(
            color: Colors.grey.shade200,
            padding: _kTableHeaderPadding,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.lot,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _kTableHeaderFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.purchasedCount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _kTableHeaderFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.receivedCount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _kTableHeaderFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.purchasedAvgWeight,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _kTableHeaderFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.receivedAvgWeight,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _kTableHeaderFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Table rows
          Expanded(
            child: ListView.builder(
              itemCount: lots.length,
              itemBuilder: (context, index) {
                final lot = lots[index];
                final lotId = lot['id'] as String;
                final lotNumber = lot['lotNumber'] ?? '—';
                final purchasedCount = lot['purchasedCattleCount'] ?? 0;
                final receivedCount = lot['receivedCattleCount'] ?? 0;
                final avgPurchasedWeight =
                    lot['totalWeight'] != null && purchasedCount > 0
                        ? (double.tryParse(lot['totalWeight'].toString()) ??
                                0) /
                            purchasedCount
                        : 0.0;
                final avgReceivedWeight =
                    lot['receivedTotalWeight'] != null && receivedCount > 0
                        ? (double.tryParse(
                                  lot['receivedTotalWeight'].toString(),
                                ) ??
                                0) /
                            receivedCount
                        : 0.0;

                final isSelected = selectedLotId == lotId;

                return InkWell(
                  onTap: () => onLotSelected(lotId),
                  child: Container(
                    color:
                        isSelected
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1)
                            : null,
                    padding: _kTableRowPadding,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            lotNumber.toString(),
                            style: const TextStyle(
                              fontSize: _kTableRowFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            purchasedCount.toString(),
                            style: const TextStyle(
                              fontSize: _kTableRowFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            receivedCount.toString(),
                            style: TextStyle(
                              fontSize: _kTableRowFontSize,
                              color:
                                  receivedCount > purchasedCount
                                      ? Colors.red
                                      : null,
                              fontWeight:
                                  receivedCount > purchasedCount
                                      ? FontWeight.bold
                                      : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${avgPurchasedWeight.toStringAsFixed(1)} kg',
                            style: const TextStyle(
                              fontSize: _kTableRowFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            receivedCount > 0
                                ? '${avgReceivedWeight.toStringAsFixed(1)} kg'
                                : '—',
                            style: const TextStyle(
                              fontSize: _kTableRowFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

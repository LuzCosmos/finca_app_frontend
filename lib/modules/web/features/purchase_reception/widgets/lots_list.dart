import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class LotsList extends StatelessWidget {
  final List<Map<String, dynamic>> lots;
  final String? selectedLotId;
  final Function(String?) onLotSelected;

  const LotsList({
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

          // Lots list
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

                return ListTile(
                  selected: selectedLotId == lotId,
                  dense: true,
                  title: Text(
                    '${l10n.lot} $lotNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${l10n.purchasedCount}: $purchasedCount | ',
                            ),
                            TextSpan(
                              text: '${l10n.receivedCount}: $receivedCount',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    receivedCount > purchasedCount
                                        ? Colors.red
                                        : null,
                                fontWeight:
                                    receivedCount > purchasedCount
                                        ? FontWeight.bold
                                        : null,
                              ),
                            ),
                          ],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '${l10n.purchasedAvgWeight}: ${avgPurchasedWeight.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      if (receivedCount > 0)
                        Text(
                          '${l10n.receivedAvgWeight}: ${avgReceivedWeight.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                    ],
                  ),
                  onTap: () => onLotSelected(lotId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

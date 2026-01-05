import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PurchaseInfoDisplay extends StatelessWidget {
  final String providerName;
  final String purchaseDate;
  final DateTime? receptionDate;
  final String? initialCattleNumber;
  final Function(DateTime) onReceptionDateChanged;
  final Function(String) onInitialNumberChanged;

  const PurchaseInfoDisplay({
    super.key,
    required this.providerName,
    required this.purchaseDate,
    this.receptionDate,
    this.initialCattleNumber,
    required this.onReceptionDateChanged,
    required this.onInitialNumberChanged,
  });

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: receptionDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != receptionDate) {
      onReceptionDateChanged(picked);
      /*setState(() {
        _selectedDate = picked;
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*Text(
              l10n.purchaseReceptionTitle.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),*/
            
            // Provider name (read-only)
            Row(
              children: [
                Text(
                  '${l10n.providerName}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                ),
                Expanded(
                  child: Text(providerName,
                  style: const TextStyle(fontSize: 14),),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Purchase date (read-only)
            Row(
              children: [
                Text(
                  '${l10n.purchase_date}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(purchaseDate),
              ],
            ),
            const SizedBox(height: 1),
            const Divider(),
            const SizedBox(height: 1),
            
            // Reception date (editable with date picker)
            Row(
              children: [
                Text('${l10n.receptionDate}: '),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('yyyy-MM-dd').format(receptionDate ?? DateTime.now())),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 2),
            
            // Initial cattle number (editable)
            Row(
              children: [
                Text(
                  l10n.initialCattleNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: initialCattleNumber,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                      //hintText: '10001',
                    ),
                    onChanged: onInitialNumberChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

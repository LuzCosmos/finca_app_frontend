import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/add_medication_dialog.dart';

class WeightHistoryDialog extends StatelessWidget {
  final List<dynamic> history;
  final String cattleNumber;

  const WeightHistoryDialog({super.key, required this.history, required this.cattleNumber});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text('#$cattleNumber - ${l10n.colWeightHistory}'),
      content: SizedBox(
        width: 400,
        height: 400,
        child: history.isEmpty 
          ? Center(child: Text(l10n.noData)) 
          : ListView.separated(
              itemCount: history.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, i) {
                final item = history[i];
                final dateStr = item['date'] != null 
                    ? DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date']))
                    : '-';
                final weight = item['weight']?.toString() ?? '-';
                
                return ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(Icons.scale),
                  title: Text('$weight kg \t-\t $dateStr'),
                  //subtitle: Text('$dateStr\n${l10n.recordedBy}: $recordedBy'),
                  //isThreeLine: true,
                );
              },
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}



class MedicationHistoryDialog extends StatefulWidget {
  final String cattleId;
  final String cattleNumber;
  final List<dynamic> history;
  final CattleMasterService service;

  const MedicationHistoryDialog({
    super.key,
    required this.cattleId,
    required this.cattleNumber,
    required this.history,
    required this.service,
    this.onAdded,
  });
  
  final Function(Map<String, dynamic>)? onAdded;

  @override
  State<MedicationHistoryDialog> createState() => _MedicationHistoryDialogState();
}

class _MedicationHistoryDialogState extends State<MedicationHistoryDialog> {
  late List<dynamic> _history;

  @override
  void initState() {
    super.initState();
    _history = List.from(widget.history);
  }

  Future<void> _addMedication() async {
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AddMedicationDialog(
        onSave: (data) async {
          final newRecord = await widget.service.addMedication(widget.cattleId, data);
          if (newRecord != null) {
            widget.onAdded?.call(newRecord);
            setState(() {
              _history.insert(0, newRecord);
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('#${widget.cattleNumber} - ${l10n.colMedicationHistory}'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addMedication,
            onPressed: _addMedication,
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: _history.isEmpty 
          ? Center(child: Text(l10n.noData)) 
          : ListView.separated(
              itemCount: _history.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, i) {
                final item = _history[i];
                final dateStr = item['appliedAt'] != null 
                    ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(item['appliedAt']))
                    : '-';
                final product = item['medicationName'] ?? '-';
                final dosage = item['dosage'] ?? '-';
                final route = item['route'] ?? '-';
                
                return ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(Icons.vaccines_outlined),
                  title: Text('$dateStr: $product'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.dosage}: $dosage - ${l10n.route}: $route'),
                      //Text('$dateStr - ${l10n.appliedBy}: $appliedBy'),
                    ],
                  ),
                );
              },
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_history),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

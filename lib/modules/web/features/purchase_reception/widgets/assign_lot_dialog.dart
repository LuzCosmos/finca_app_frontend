import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class AssignLotDialog extends StatefulWidget {
  final List<Map<String, dynamic>> availableLots;
  final Function(String) onAssign;

  const AssignLotDialog({
    super.key,
    required this.availableLots,
    required this.onAssign,
  });

  @override
  State<AssignLotDialog> createState() => _AssignLotDialogState();
}

class _AssignLotDialogState extends State<AssignLotDialog> {
  String? selectedLotId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.assignLotTitle),
      content: SizedBox(
        width: 300,
        child: DropdownButtonFormField<String>(
          value: selectedLotId,
          decoration: InputDecoration(
            labelText: l10n.selectLot,
            border: const OutlineInputBorder(),
          ),
          items: widget.availableLots.map((lot) {
            return DropdownMenuItem<String>(
              value: lot['id'] as String,
              child: Text('${l10n.lot} ${lot['lotNumber']}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedLotId = value;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: selectedLotId != null
              ? () {
                  widget.onAssign(selectedLotId!);
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(l10n.assignLot),
        ),
      ],
    );
  }
}

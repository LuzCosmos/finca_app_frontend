import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';

class CharacteristicsEditDialog extends StatefulWidget {
  final List<String> availableCharacteristics;
  final List<String> selectedIds;

  const CharacteristicsEditDialog({
    super.key,
    required this.availableCharacteristics,
    required this.selectedIds,
  });

  @override
  State<CharacteristicsEditDialog> createState() => _CharacteristicsEditDialogState();
}

class _CharacteristicsEditDialogState extends State<CharacteristicsEditDialog> {
  late List<String> _tempSelectedIds;

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = List.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.characteristics),
      content: SizedBox(
        width: 300,
        height: 400,
        child: ListView(
          shrinkWrap: true,
          children: widget.availableCharacteristics.map((char) {
            final id = char;
            final enumVal = CattleCharacteristic.fromString(id);
            final name = enumVal?.localizedName(context) ?? char;
            final isSelected = _tempSelectedIds.contains(id);

            return CheckboxListTile(
              value: isSelected,
              title: Text(name),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _tempSelectedIds.add(id);
                  } else {
                    _tempSelectedIds.remove(id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            // Map IDs back to names for display
            final names = _tempSelectedIds.map((id) {
               final enumVal = CattleCharacteristic.fromString(id);
               return enumVal?.localizedName(context) ?? id;
            }).toList();

            Navigator.of(context).pop({
              'ids': _tempSelectedIds,
              'names': names,
            });
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

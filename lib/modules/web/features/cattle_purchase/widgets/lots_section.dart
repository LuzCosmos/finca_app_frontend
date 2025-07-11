import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'lot_input.dart';
import '../models/lot.dart';

class LotsSection extends StatefulWidget {
  final void Function(List<LotModel>) onLotsChanged;

  const LotsSection({super.key, required this.onLotsChanged});

  @override
  State<LotsSection> createState() => _LotsSectionState();
}

class _LotsSectionState extends State<LotsSection> {
  final List<LotInput> _lotInputs = [];

  @override
  void initState() {
    super.initState();
    _addLot(); // inicia con uno por defecto
  }

  void _addLot() {
    setState(() {
      _lotInputs.add(
        LotInput(
          key: UniqueKey(),
          onChanged: (_) => _onAnyLotChanged(),
          onRemove:
              _lotInputs.length > 0
                  ? () => _removeLot(_lotInputs.length - 1)
                  : null,
        ),
      );
    });
  }

  void _removeLot(int index) {
    setState(() {
      _lotInputs.removeAt(index);
      _onAnyLotChanged();
    });
  }

  void _onAnyLotChanged() {
    final lots =
        _lotInputs
            .map((input) => input.getLotOrNull())
            .whereType<LotModel>()
            .toList();
    widget.onLotsChanged(lots);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.lotsTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ..._lotInputs.map(
          (input) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: input,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _addLot,
            icon: const Icon(Icons.add),
            label: Text(l10n.addLot),
          ),
        ),
      ],
    );
  }
}

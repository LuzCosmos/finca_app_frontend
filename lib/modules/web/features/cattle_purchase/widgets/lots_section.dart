import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../models/lot.dart';
import 'lot_input.dart';

class LotsSection extends StatefulWidget {
  final void Function(List<LotModel>) onLotsChanged;

  const LotsSection({super.key, required this.onLotsChanged});

  @override
  State<LotsSection> createState() => _LotsSectionState();
}

class _LotsSectionState extends State<LotsSection> {
  final List<GlobalKey<LotInputState>> _lotKeys = [];

  void _addLot() {
    setState(() {
      _lotKeys.add(GlobalKey<LotInputState>());
    });
  }

  void _removeLot(int index) {
    setState(() {
      _lotKeys.removeAt(index);
    });
    _notifyChange();
  }

  void _notifyChange() {
    final lots =
        _lotKeys
            .map((key) => key.currentState?.getLotOrNull())
            .whereType<LotModel>()
            .toList();

    widget.onLotsChanged(lots);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lots =
        _lotKeys
            .map((key) => key.currentState?.getLotOrNull())
            .whereType<LotModel>()
            .toList();

    final totalCattle = lots.fold<int>(0, (sum, l) => sum + l.cattleCount);
    final totalWeight = lots.fold<double>(0, (sum, l) => sum + l.totalWeight);
    final totalValue = lots.fold<double>(0, (sum, l) => sum + l.totalValue);

    final avgWeight = lots.isEmpty ? 0 : totalWeight / totalCattle;
    final avgPrice =
        lots.isEmpty
            ? 0
            : lots.fold(0.0, (sum, l) => sum + l.pricePerKg) / lots.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.lot, style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton.icon(
              onPressed: _addLot,
              icon: const Icon(Icons.add),
              label: Text(l10n.addLot),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildHeaderRow(l10n),
        const SizedBox(height: 8),
        ..._lotKeys.asMap().entries.map((entry) {
          final index = entry.key;
          final key = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: LotInput(
              key: key,
              onChanged: (_) => _notifyChange(),
              onRemove: () => _removeLot(index),
            ),
          );
        }),
        const SizedBox(height: 16),
        const Divider(),
        _buildSummaryRow(
          l10n,
          avgWeight.toDouble(),
          avgPrice.toDouble(),
          totalCattle,
          totalWeight,
          totalValue,
        ),
      ],
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _HeaderCell(label: l10n.lot, width: 80),
        _HeaderCell(label: l10n.lot_origin, width: 120),
        _HeaderCell(label: l10n.lot_age, width: 80),
        _HeaderCell(label: l10n.lot_gender, width: 80),
        _HeaderCell(label: l10n.lot_avgWeight, width: 110),
        _HeaderCell(label: l10n.lot_pricePerKg, width: 100),
        _HeaderCell(label: l10n.lot_cattleCount, width: 80),
        _HeaderCell(label: l10n.lot_totalWeight, width: 90),
        _HeaderCell(label: l10n.lot_totalValue, width: 120),
        SizedBox(width: 23), // Para el botón de eliminar
      ],
    );
  }

  Widget _buildSummaryRow(
    AppLocalizations l10n,
    double avgWeight,
    double avgPrice,
    int totalCattle,
    double totalWeight,
    double totalValue,
  ) {
    return Column(
      children: [
        Row(
          children: [
            const _HeaderCell(label: 'Promedio', width: 374),
            _ValueCell(value: avgWeight.toStringAsFixed(0), width: 110),
            _ValueCell(value: avgPrice.toStringAsFixed(0), width: 100),
            const _HeaderCell(label: '', width: 80),
            const _HeaderCell(label: '', width: 90),
            const _HeaderCell(label: '', width: 120),
            const SizedBox(width: 23),
          ],
        ),
        Row(
          children: [
            const _HeaderCell(label: 'Total', width: 374),
            const _HeaderCell(label: '', width: 110),
            const _HeaderCell(label: '', width: 100),
            _ValueCell(value: totalCattle.toString(), width: 80),
            _ValueCell(value: totalWeight.toStringAsFixed(0), width: 90),
            //_ValueCell(value: totalValue.toStringAsFixed(0), width: 120),
            const _HeaderCell(label: '', width: 120),
            const SizedBox(width: 23),
          ],
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;

  const _HeaderCell({required this.label, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String value;
  final double width;

  const _ValueCell({required this.value, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      //padding: const EdgeInsets.symmetric(vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(value),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/lot.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/widgets/lot_input.dart';
import 'package:intl/intl.dart';

class LotsSection extends StatefulWidget {
  final void Function(List<LotModel>) onLotsChanged;

  const LotsSection({super.key, required this.onLotsChanged});

  @override
  State<LotsSection> createState() => LotsSectionState();
}

class LotsSectionState extends State<LotsSection> {
  final List<GlobalKey<LotInputState>> _lotKeys = [];
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

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

  bool validateDuplicatedLotNumbers(BuildContext context) {
    final seenLotNumbers = <String>{};
    for (final key in _lotKeys) {
      final lot = key.currentState?.getLotOrNull();
      if (lot == null) continue;
      if (seenLotNumbers.contains(lot.lotNumber)) {
        return false;
      }
      seenLotNumbers.add(lot.lotNumber);
    }
    return true;
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
    final rawTotalWeight = lots.fold<double>(
      0,
      (sum, l) => sum + l.totalWeight,
    );
    final rawTotalValue = lots.fold<double>(0, (sum, l) => sum + l.totalValue);
    final totalWeight = double.parse(rawTotalWeight.toStringAsFixed(2));
    final totalValue = double.parse(rawTotalValue.toStringAsFixed(2));
    final avgWeight = lots.isEmpty ? 0 : totalWeight / totalCattle;
    double avgPrice = 0;
    if (totalWeight > 0) {
      avgPrice = totalValue / totalWeight;
    }
    /*lots.isEmpty
            ? 0
            : lots.fold(0.0, (sum, l) => sum + l.pricePerKg) / lots.length;*/

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.lotsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _addLot,
              icon: const Icon(Icons.add),
              label: Text(l10n.addLot),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Scrollbar(
          //thumbVisibility: true,
          trackVisibility: true,
          controller: _horizontalScrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(l10n),
                const SizedBox(height: 5),
                ..._lotKeys.asMap().entries.map((entry) {
                  final index = entry.key;
                  final key = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: LotInput(
                      key: key,
                      onChanged: (_) => _notifyChange(),
                      onRemove: () => _removeLot(index),
                    ),
                  );
                }),
                const SizedBox(height: 2),
                _buildSummaryRow(
                  l10n,
                  avgWeight.toDouble(),
                  avgPrice.toDouble(),
                  totalCattle,
                  totalWeight,
                  totalValue,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _HeaderCell(label: l10n.lot, width: 60),
        _HeaderCell(label: l10n.lot_origin, width: 120),
        _HeaderCell(label: l10n.lot_age, width: 60),
        _HeaderCell(label: l10n.lot_gender, width: 70),
        _HeaderCell(label: l10n.lot_cattleCount, width: 40),
        _HeaderCell(label: l10n.lot_avgWeight, width: 70),
        _HeaderCell(label: l10n.lot_totalWeight, width: 60),
        _HeaderCell(label: l10n.lot_pricePerKg, width: 70),
        _HeaderCell(label: l10n.lot_pricePerHead, width: 90),
        _HeaderCell(label: l10n.lot_totalValue, width: 90),
        SizedBox(width: 22), // Para el botón de eliminar
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
    final l10n = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat(
      l10n.numberFormat,
      l10n.numberFormat_country,
    );
    final summaryAverageTitle = l10n.lots_summaryAverageTitle;
    final summaryTotalTitle = l10n.lots_summaryTotalTitle;
    return Column(
      children: [
        Row(
          children: [
            const _HeaderCell(label: '', width: 248),
            _HeaderCell(label: summaryAverageTitle, width: 70),
            const _HeaderCell(label: '', width: 40),
            _ValueCell(value: numberFormat.format(avgWeight), width: 70),
            const _HeaderCell(label: '', width: 60),
            _ValueCell(value: numberFormat.format(avgPrice), width: 70),
            const _HeaderCell(label: '', width: 90),
            const _HeaderCell(label: '', width: 90),
            const SizedBox(width: 22),
          ],
        ),
        Row(
          children: [
            const _HeaderCell(label: '', width: 248),
            _HeaderCell(label: summaryTotalTitle, width: 70),
            _ValueCell(value: numberFormat.format(totalCattle), width: 40),
            const _HeaderCell(label: '', width: 70),
            _ValueCell(value: numberFormat.format(totalWeight), width: 60),
            const _HeaderCell(label: '', width: 70),
            const _HeaderCell(label: '', width: 90),
            //_ValueCell(value: numberFormat.format(totalValue), width: 90),
            const _HeaderCell(label: '', width: 90),
            const SizedBox(width: 22),
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
        style: Theme.of(context).textTheme.labelMedium,
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
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      //padding: const EdgeInsets.symmetric(vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(value, style: const TextStyle(fontSize: 11.5)),
    );
  }
}

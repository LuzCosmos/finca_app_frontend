import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/lot.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:finca_app_frontend/core/utils/regex_patterns.dart';
import 'package:finca_app_frontend/modules/shared/validator/validator.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';

class LotInput extends StatefulWidget {
  final void Function(LotModel) onChanged;
  final VoidCallback? onRemove;
  final LotModel? initialLot;

  const LotInput({
    super.key,
    required this.onChanged,
    this.onRemove,
    this.initialLot,
  });

  @override
  State<LotInput> createState() => LotInputState();
}

enum PriceInputMode { perKg, perHead }

class LotInputState extends State<LotInput> {
  final _lotNumberController = TextEditingController();
  final _originController = TextEditingController();
  CattleGender _selectedGender = CattleGender.MALE;
  final _cattleCountController = TextEditingController();
  final _avgWeightController = TextEditingController();
  final _totalWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _pricePerHeadController = TextEditingController();
  final _totalValueController = TextEditingController();
// ... (keeping other methods same but updating _notifyLotChanged and _onFieldChanged)

  PriceInputMode? _lastEditedPriceMode;

  @override
  void initState() {
    super.initState();
    if (widget.initialLot != null) {
      applyInitialLot(widget.initialLot!);
    }
  }

  void applyInitialLot(LotModel lot) {
    _lotNumberController.text = lot.lotNumber;
    _originController.text = lot.origin;
    _selectedGender = lot.gender;
    _cattleCountController.text = '${lot.purchasedCattleCount}';
    _avgWeightController.text = lot.avgWeight.toStringAsFixed(2);
    _totalWeightController.text = lot.totalWeight.toStringAsFixed(2);
    _pricePerKgController.text = lot.pricePerKg.toStringAsFixed(2);
    _totalValueController.text = lot.totalValue.toStringAsFixed(2);
    final pricePerHead = lot.avgWeight * lot.pricePerKg;
    _pricePerHeadController.text = pricePerHead.toStringAsFixed(2);
    _notifyLotChanged();
  }

  void _onPricePerKgChanged() {
    _lastEditedPriceMode = PriceInputMode.perKg;
    _updateWithPricePerKg();
    _notifyLotChanged();
  }

  void _updateWithPricePerKg() {
    final l10n = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat(
      l10n.numberFormat,
      l10n.numberFormat_country,
    );
    final avgWeight =
        double.tryParse(_avgWeightController.text.replaceAll(',', '')) ?? 0;
    final pricePerKg =
        double.tryParse(_pricePerKgController.text.replaceAll(',', '')) ?? 0;
    final pricePerHead = double.parse(
      (pricePerKg * avgWeight).toStringAsFixed(2),
    );
    final totalWeight =
        double.tryParse(_totalWeightController.text.replaceAll(',', '')) ?? 0;
    final totalValue = double.parse(
      (pricePerKg * totalWeight).toStringAsFixed(2),
    );
    _pricePerHeadController.text = pricePerHead.toString();
    _totalValueController.text = numberFormat.format(totalValue);
  }

  void _onPricePerHeadChanged() {
    _lastEditedPriceMode = PriceInputMode.perHead;
    _updateWithPricePerHead();
    _notifyLotChanged();
  }

  void _updateWithPricePerHead() {
    final l10n = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat(
      l10n.numberFormat,
      l10n.numberFormat_country,
    );
    final cattleCount = int.tryParse(_cattleCountController.text) ?? 0;
    final avgWeight =
        double.tryParse(_avgWeightController.text.replaceAll(',', '')) ?? 0;
    final pricePerHead =
        double.tryParse(_pricePerHeadController.text.replaceAll(',', '')) ?? 0;
    double pricePerKg = 0;
    if (avgWeight > 0) {
      pricePerKg = double.parse((pricePerHead / avgWeight).toStringAsFixed(2));
    }
    _pricePerKgController.text = pricePerKg.toString();
    _totalValueController.text = numberFormat.format(
      pricePerHead * cattleCount,
    );
  }

  void _notifyLotChanged() {
    final cattleCount =
        int.tryParse(_cattleCountController.text.replaceAll(',', '')) ?? 0;
    final totalWeight =
        double.tryParse(_totalWeightController.text.replaceAll(',', '')) ?? 0;
    final pricePerKg =
        double.tryParse(_pricePerKgController.text.replaceAll(',', '')) ?? 0;
    final totalValue =
        double.tryParse(_totalValueController.text.replaceAll(',', '')) ?? 0;
    final lot = LotModel(
      lotNumber: _lotNumberController.text,
      origin: _originController.text,
      gender: _selectedGender,
      avgWeight: (cattleCount > 0) ? totalWeight / cattleCount : 0,
      pricePerKg: pricePerKg,
      purchasedCattleCount: cattleCount,
      totalWeight: totalWeight,
      totalValue: totalValue,
    );
    widget.onChanged(lot);
  }

  void _onFieldChanged() {
    try {
      final l10n = AppLocalizations.of(context)!;
      final numberFormat = NumberFormat(
        l10n.numberFormat,
        l10n.numberFormat_country,
      );
      final cattleCount =
          int.tryParse(_cattleCountController.text.replaceAll(',', '')) ?? 0;
      final totalWeight =
          double.tryParse(_totalWeightController.text.replaceAll(',', '')) ?? 0;
      double avgWeight = 0;
      if (cattleCount > 0) {
        avgWeight = double.parse(
          (totalWeight / cattleCount).toStringAsFixed(2),
        );
      } else {
        avgWeight = 0;
      }
      _avgWeightController.text = numberFormat.format(avgWeight);
      if (cattleCount > 0 && _lastEditedPriceMode != null) {
        if (_lastEditedPriceMode == PriceInputMode.perKg) {
          _updateWithPricePerKg();
        } else if (avgWeight > 0) {
          _updateWithPricePerHead();
        }
      }
      final pricePerKg =
          double.tryParse(_pricePerKgController.text.replaceAll(',', '')) ?? 0;
      final totalValue =
          double.tryParse(_totalValueController.text.replaceAll(',', '')) ?? 0;
      final lot = LotModel(
        lotNumber: _lotNumberController.text,
        origin: _originController.text,
        gender: _selectedGender,
        avgWeight: avgWeight,
        pricePerKg: pricePerKg,
        purchasedCattleCount: cattleCount,
        totalWeight: totalWeight,
        totalValue: totalValue,
      );
      widget.onChanged(lot);
    } catch (_) {}
  }

  @override
  void dispose() {
    _lotNumberController.dispose();
    _originController.dispose();
    _avgWeightController.dispose();
    _pricePerKgController.dispose();
    _cattleCountController.dispose();
    _totalWeightController.dispose();
    _totalValueController.dispose();
    _pricePerHeadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell(
          _lotNumberController,
          '',
          width: 60,
          validator: Validator.validateNotEmpty(
            l10n.lot_numberRequired,
            RegexPatterns.positiveIntegerNoZero,
          ),
          customRegex: RegexPatterns.permissivePositiveInteger,
        ),
        _buildCell(_originController, '', width: 120),
        _buildDropdownCell(
          width: 70,
          value: _selectedGender,
          items: CattleGender.values,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
              _onFieldChanged();
            }
          },
          itemLabelBuilder: (item) => item.localizedName(context),
        ),
        _buildCell(
          _cattleCountController,
          '',
          width: 40,
          isNumeric: true,
          validator: Validator.validateNumericMandatory(
            l10n.lot_cattleCountRequired,
            l10n.lot_cattleCountInvalid,
            RegexPatterns.positiveIntegerNoZero,
          ),
          customRegex: RegexPatterns.permissivePositiveInteger,
        ),
        _buildCell(
          _totalWeightController,
          '',
          width: 60,
          isNumeric: true,
          validator: Validator.validateNumericMandatory(
            l10n.lot_totalWeightRequired,
            l10n.lot_totalWeightInvalid,
            RegexPatterns.positiveDecimalTwoDigitsNoZero,
          ),
          customRegex: RegexPatterns.permissivePositiveDecimalTwoDigits,
        ),
        _buildReadOnlyCell(_avgWeightController, '', width: 70),
        _buildCell(
          _pricePerKgController,
          '',
          width: 70,
          isNumeric: true,
          validator: Validator.validateNumericMandatory(
            l10n.lot_pricePerKgRequired,
            l10n.lot_pricePerKgInvalid,
            RegexPatterns.positiveDecimalTwoDigitsNoZero,
          ),
          onChangedCustom: (value) => _onPricePerKgChanged(),
          customRegex: RegexPatterns.permissivePositiveDecimalTwoDigits,
        ),
        _buildCell(
          _pricePerHeadController,
          '', //l10n.pricePerHead, // agrega esta key a tu .arb
          width: 90,
          isNumeric: true,
          validator: Validator.validateNumericMandatory(
            l10n.lot_pricePerHeadRequired,
            l10n.lot_pricePerHeadInvalid,
            RegexPatterns.positiveDecimalTwoDigitsNoZero,
          ),
          onChangedCustom: (value) => _onPricePerHeadChanged(),
          customRegex: RegexPatterns.permissivePositiveDecimalTwoDigits,
        ),
        _buildReadOnlyCell(_totalValueController, r'$', width: 90),
        // Delete button
        SizedBox(
          width: 22,
          height: 22,
          child: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: widget.onRemove,
            tooltip: l10n.delete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownCell<T>({
    required double width,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemLabelBuilder,
  }) {
    return Container(
      width: width,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 16),
          style: const TextStyle(fontSize: 11.5, color: Colors.black),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  itemLabelBuilder(item),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCell(
    TextEditingController controller,
    String label, {
    double width = 100,
    bool isNumeric = false,
    FormFieldValidator<String>? validator,
    void Function(String)? onChangedCustom,
    RegExp? customRegex,
  }) {
    return Container(
      width: width,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.right,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          if (isNumeric && customRegex == null)
            FilteringTextInputFormatter.allow(
              RegExp(RegexPatterns.positiveDecimalTwoDigits.pattern),
            ),
          if (customRegex != null)
            FilteringTextInputFormatter.allow(RegExp(customRegex.pattern)),
        ],
        style: const TextStyle(fontSize: 11.5),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 11.5),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 6,
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
        ),
        onChanged: onChangedCustom ?? (value) => _onFieldChanged(),
      ),
    );
  }

  Widget _buildReadOnlyCell(
    TextEditingController controller,
    String label, {
    double width = 100,
  }) {
    return Container(
      width: width,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(fontSize: 11.5),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          //labelText: label,
          labelStyle: const TextStyle(fontSize: 11.5),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 6,
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
        ),
      ),
    );
  }

  LotModel? getLotOrNull() {
    final purchasedCattleCount = int.tryParse(
      _cattleCountController.text.replaceAll(',', ''),
    );
    if (purchasedCattleCount == null || purchasedCattleCount == 0) return null;
    final avgWeight =
        double.tryParse(_avgWeightController.text.replaceAll(',', '')) ?? 0;
    final pricePerKg =
        double.tryParse(_pricePerKgController.text.replaceAll(',', '')) ?? 0;
    final totalWeight =
        double.tryParse(_totalWeightController.text.replaceAll(',', '')) ?? 0;
    final totalValue =
        double.tryParse(_totalValueController.text.replaceAll(',', '')) ?? 0;
    return LotModel(
      lotNumber: _lotNumberController.text,
      origin: _originController.text,
      gender: _selectedGender,
      avgWeight: avgWeight,
      pricePerKg: pricePerKg,
      purchasedCattleCount: purchasedCattleCount,
      totalWeight: totalWeight,
      totalValue: totalValue,
    );
  }
}

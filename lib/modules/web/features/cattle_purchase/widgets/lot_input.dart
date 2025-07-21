import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../models/lot.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LotInput extends StatefulWidget {
  final void Function(LotModel) onChanged;
  final VoidCallback? onRemove;

  const LotInput({super.key, required this.onChanged, this.onRemove});

  @override
  State<LotInput> createState() => LotInputState();
}

enum PriceInputMode { perKg, perHead }

class LotInputState extends State<LotInput> {
  final _lotNumberController = TextEditingController();
  final _originController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _cattleCountController = TextEditingController();
  final _avgWeightController = TextEditingController();
  final _totalWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _pricePerHeadController = TextEditingController();
  final _totalValueController = TextEditingController();

  PriceInputMode? _lastEditedPriceMode;

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
      age: _ageController.text,
      gender: _genderController.text,
      avgWeight: (cattleCount > 0) ? totalWeight / cattleCount : 0,
      pricePerKg: pricePerKg,
      cattleCount: cattleCount,
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
        age: _ageController.text,
        gender: _genderController.text,
        avgWeight: avgWeight,
        pricePerKg: pricePerKg,
        cattleCount: cattleCount,
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
    _ageController.dispose();
    _genderController.dispose();
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
          validator: _validateNotEmpty(l10n.lot_numberRequired),
        ),
        _buildCell(_originController, '', width: 120),
        _buildCell(
          _ageController,
          '',
          width: 60,
          validator: _validateNotEmpty(l10n.fieldRequired),
        ),
        _buildCell(
          _genderController,
          '',
          width: 70,
          validator: _validateNotEmpty(l10n.fieldRequired),
        ),
        _buildCell(
          _cattleCountController,
          '',
          width: 40,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_cattleCountRequired,
            l10n.lot_cattleCountInvalid,
          ),
        ),
        _buildReadOnlyCell(_avgWeightController, '', width: 70),
        _buildCell(
          _totalWeightController,
          '',
          width: 60,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_totalWeightRequired,
            l10n.lot_totalWeightInvalid,
          ),
        ),
        _buildCell(
          _pricePerKgController,
          '',
          width: 70,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_pricePerKgRequired,
            l10n.lot_pricePerKgInvalid,
          ),
          onChangedCustom: (value) => _onPricePerKgChanged(),
        ),
        _buildCell(
          _pricePerHeadController,
          '', //l10n.lot_pricePerHead, // agrega esta key a tu .arb
          width: 90,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_pricePerHeadRequired,
            l10n.lot_pricePerHeadInvalid,
          ),
          onChangedCustom: (value) => _onPricePerHeadChanged(),
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

  FormFieldValidator<String> _validateNotEmpty(String errorMessage) {
    return (String? value) {
      if (value == null || value.isEmpty) return errorMessage;
      return null;
    };
  }

  FormFieldValidator<String> _validateNumericMandatory(
    String requiredMessage,
    String invalidMessage,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) return requiredMessage;
      final parsed = double.tryParse(value);
      if (parsed == null || parsed <= 0) return invalidMessage;
      return null;
    };
  }

  Widget _buildCell(
    TextEditingController controller,
    String label, {
    double width = 100,
    bool isNumeric = false,
    FormFieldValidator<String>? validator,
    void Function(String)? onChangedCustom, // 👈 nuevo
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
        inputFormatters:
            isNumeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
                : null,
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
    final cattleCount = int.tryParse(
      _cattleCountController.text.replaceAll(',', ''),
    );
    if (cattleCount == null || cattleCount == 0) return null;
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
      age: _ageController.text,
      gender: _genderController.text,
      avgWeight: avgWeight,
      pricePerKg: pricePerKg,
      cattleCount: cattleCount,
      totalWeight: totalWeight,
      totalValue: totalValue,
    );
  }
}

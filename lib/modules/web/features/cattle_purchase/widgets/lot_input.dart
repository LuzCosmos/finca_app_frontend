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

class LotInputState extends State<LotInput> {
  final _lotNumberController = TextEditingController();
  final _originController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _avgWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _cattleCountController = TextEditingController();
  final _totalWeightController = TextEditingController();
  final _totalValueController = TextEditingController();

  void _onFieldChanged() {
    try {
      final l10n = AppLocalizations.of(context)!;
      final numberFormat = NumberFormat(
        l10n.numberFormat,
        l10n.numberFormat_country,
      );
      final cattleCount = int.tryParse(_cattleCountController.text) ?? 0;
      final avgWeight = double.tryParse(_avgWeightController.text) ?? 0;
      final pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;
      final totalWeight = double.parse(
        (cattleCount * avgWeight).toStringAsFixed(2),
      );
      final totalValue = double.parse(
        (totalWeight * pricePerKg).toStringAsFixed(2),
      );
      _totalWeightController.text = numberFormat.format(totalWeight);
      _totalValueController.text = numberFormat.format(totalValue);
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
          width: 80,
          validator: _validateNotEmpty(l10n.lot_numberRequired),
        ),
        _buildCell(_originController, '', width: 120),
        _buildCell(
          _ageController,
          '',
          width: 80,
          validator: _validateNotEmpty(l10n.fieldRequired),
        ),
        _buildCell(
          _genderController,
          '',
          width: 80,
          validator: _validateNotEmpty(l10n.fieldRequired),
        ),
        _buildCell(
          _avgWeightController,
          '',
          width: 110,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_avgWeightRequired,
            l10n.lot_avgWeightInvalid,
          ),
        ),
        _buildCell(
          _pricePerKgController,
          '',
          width: 100,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_pricePerKgRequired,
            l10n.lot_pricePerKgInvalid,
          ),
        ),
        _buildCell(
          _cattleCountController,
          '',
          width: 80,
          isNumeric: true,
          validator: _validateNumericMandatory(
            l10n.lot_cattleCountRequired,
            l10n.lot_cattleCountInvalid,
          ),
        ),
        _buildReadOnlyCell(
          label: 'kg',
          width: 90,
          controller: _totalWeightController,
        ),
        _buildReadOnlyCell(
          label: r'$',
          width: 120,
          controller: _totalValueController,
        ),
        // Delete button
        SizedBox(
          width: 28,
          height: 28,
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
  }) {
    return Container(
      width: width,
      height: 28,
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
          labelStyle: const TextStyle(fontSize: 11),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
        ),
        onChanged: (value) => _onFieldChanged(),
      ),
    );
  }

  Widget _buildReadOnlyCell({
    required String label,
    double width = 100,
    required TextEditingController controller,
  }) {
    return Container(
      width: width,
      height: 28,
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
            horizontal: 8,
            vertical: 10,
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
        ),
      ),
    );
  }

  LotModel? getLotOrNull() {
    final cattleCount = int.tryParse(_cattleCountController.text);
    if (cattleCount == null || cattleCount == 0) return null;
    final avgWeight = double.tryParse(_avgWeightController.text) ?? 0;
    final pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;
    final totalWeight = cattleCount * avgWeight;
    final totalValue = totalWeight * pricePerKg;
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

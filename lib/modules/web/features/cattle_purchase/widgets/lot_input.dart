import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../models/lot.dart';

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

  void _onFieldChanged() {
    try {
      final cattleCount = int.tryParse(_cattleCountController.text) ?? 0;
      final avgWeight = double.tryParse(_avgWeightController.text) ?? 0;
      final pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;

      final totalWeight = cattleCount * avgWeight;
      final totalValue = totalWeight * pricePerKg;

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
    } catch (_) {
      // No enviar cambios si hay error en parsing
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell(_lotNumberController, '', width: 80),
        _buildCell(_originController, '', width: 120),
        _buildCell(_ageController, '', width: 80),
        _buildCell(_genderController, '', width: 80),
        _buildCell(_avgWeightController, '', width: 110, isNumeric: true),
        _buildCell(_pricePerKgController, '', width: 100, isNumeric: true),
        _buildCell(_cattleCountController, '', width: 80, isNumeric: true),
        // Celdas calculadas: total peso y valor
        _buildReadOnlyCell(label: 'kg', width: 90),
        _buildReadOnlyCell(label: r'$', width: 120),
        // Botón eliminar
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            icon: const Icon(Icons.delete, size: 24),
            onPressed: widget.onRemove,
            tooltip: l10n.delete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildCell(
    TextEditingController controller,
    String label, {
    double width = 100,
    bool isNumeric = false,
  }) {
    return Container(
      width: width,
      height: 25,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) => _onFieldChanged(),
      ),
    );
  }

  Widget _buildReadOnlyCell({required String label, double width = 100}) {
    return Container(
      width: width,
      height: 25,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
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

import 'package:flutter/material.dart';
import '../models/lot.dart';
import '/l10n/app_localizations.dart';

class LotInput extends StatefulWidget {
  final void Function(LotModel) onChanged;
  final VoidCallback? onRemove;

  LotInput({super.key, required this.onChanged, this.onRemove});

  // Permitir acceso externo al lot construido
  LotModel? getLotOrNull() => _state?._buildLotOrNull();
  LotInputState? _state;

  @override
  State<LotInput> createState() => LotInputState();
}

class LotInputState extends State<LotInput> {
  final _formKey = GlobalKey<FormState>();

  final _lotNumberController = TextEditingController();
  final _originController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _avgWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _cattleCountController = TextEditingController();
  final _totalWeightController = TextEditingController();
  final _totalValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget._state = this;

    void setupListener(TextEditingController controller) {
      controller.addListener(() => _onChanged());
    }

    [
      _lotNumberController,
      _originController,
      _ageController,
      _genderController,
      _avgWeightController,
      _pricePerKgController,
      _cattleCountController,
      _totalWeightController,
      _totalValueController,
    ].forEach(setupListener);
  }

  LotModel? _buildLotOrNull() {
    try {
      return LotModel(
        lotNumber: _lotNumberController.text.trim(),
        origin: _originController.text.trim(),
        age: _ageController.text.trim(),
        gender: _genderController.text.trim(),
        avgWeight: double.parse(_avgWeightController.text),
        pricePerKg: double.parse(_pricePerKgController.text),
        cattleCount: int.parse(_cattleCountController.text),
        totalWeight: double.parse(_totalWeightController.text),
        totalValue: double.parse(_totalValueController.text),
      );
    } catch (_) {
      return null;
    }
  }

  LotModel? getLotIfValid() {
    if (_formKey.currentState?.validate() != true) return null;
    final lot = getLotOrNull();
    if (lot == null || lot.cattleCount <= 0) {
      return null;
    }
    return lot;
  }

  LotModel? getLotOrNull() {
    if (_lotNumberController.text.isEmpty ||
        _originController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _avgWeightController.text.isEmpty ||
        _pricePerKgController.text.isEmpty ||
        int.parse(_cattleCountController.text) <= 0) {
      return null;
    }
    final avgWeight = double.tryParse(_avgWeightController.text) ?? 0;
    final pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;
    final totalWeight = int.parse(_cattleCountController.text) * avgWeight;
    final totalValue = totalWeight * pricePerKg;

    return LotModel(
      lotNumber: _lotNumberController.text,
      origin: _originController.text,
      cattleCount: int.parse(_cattleCountController.text),
      age: _ageController.text,
      gender: _genderController.text,
      avgWeight: avgWeight,
      totalWeight: totalWeight,
      pricePerKg: pricePerKg,
      totalValue: totalValue,
    );
  }

  void _onChanged() {
    final lot = _buildLotOrNull();
    if (lot != null) widget.onChanged(lot);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _lotNumberController,
                  decoration: InputDecoration(labelText: l10n.lot_lotNumber),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _originController,
                  decoration: InputDecoration(labelText: l10n.lot_origin),
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: l10n.lot_age),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: l10n.lot_gender),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _avgWeightController,
                  decoration: InputDecoration(labelText: l10n.lot_avgWeight),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _pricePerKgController,
                  decoration: InputDecoration(labelText: l10n.lot_pricePerKg),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cattleCountController,
                  decoration: InputDecoration(labelText: l10n.lot_cattleCount),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _totalWeightController,
                  decoration: InputDecoration(labelText: l10n.lot_totalWeight),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _totalValueController,
                  decoration: InputDecoration(labelText: l10n.lot_totalValue),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class CattleData {
  final String number;
  final double? weightKg;
  final String? lotId;
  final String? colorId;
  final List<String> characteristicsIds;
  final String? eartag;
  final String? trackerId;

  CattleData({
    required this.number,
    this.weightKg,
    this.lotId,
    this.colorId,
    this.characteristicsIds = const [],
    this.eartag,
    this.trackerId,
  });
}

class RecieveCattleForm extends StatefulWidget {
  final List<Map<String, dynamic>> lots;
  final Future<void> Function(CattleData) onSubmit;

  const RecieveCattleForm({super.key, required this.lots, required this.onSubmit});

  @override
  State<RecieveCattleForm> createState() => _RecieveCattleFormState();
}

class _RecieveCattleFormState extends State<RecieveCattleForm> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _weight = TextEditingController();
  final _eartag = TextEditingController();
  final _tracker = TextEditingController();

  String? lotId;
  String? colorId;
  final List<String> selectedCharacteristics = [];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: TextFormField(
                  controller: _number,
                  decoration: InputDecoration(labelText: t.cattleNumber),
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? t.fieldRequired
                              : null,
                ),
              ),
              SizedBox(
                width: 140,
                child: TextFormField(
                  controller: _weight,
                  decoration: InputDecoration(labelText: t.weightKg),
                  keyboardType: TextInputType.number,
                ),
              ),
              // Lote dropdown
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: lotId,
                  decoration: InputDecoration(labelText: t.lot),
                  items:
                      [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(t.withoutLot),
                        ),
                        ...widget.lots.map(
                          (l) => DropdownMenuItem<String>(
                            value: l['id'] as String,
                            child: Text('${t.lot} ${l['lotNumber']}'),
                          ),
                        ),
                      ].cast<DropdownMenuItem<String>>(),
                  onChanged: (v) => setState(() => lotId = v),
                ),
              ),
              // Color dropdown (puedes poblar desde algún catálogo; placeholder aquí)
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: colorId,
                  decoration: InputDecoration(labelText: t.color),
                  items: const [
                    DropdownMenuItem<String>(value: null, child: Text('—')),
                  ],
                  onChanged: (v) => setState(() => colorId = v),
                ),
              ),
              // Características (multi-select sencilla con diálogo)
              ElevatedButton.icon(
                onPressed: () async {
                  // TODO: abre diálogo con checklist de características
                },
                icon: const Icon(Icons.list),
                label: Text(t.characteristics),
              ),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: _eartag,
                  decoration: InputDecoration(labelText: t.eartag),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _tracker,
                  decoration: InputDecoration(labelText: t.trackerId),
                ),
              ),
              FilledButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  await widget.onSubmit(
                    CattleData(
                      number: _number.text.trim(),
                      weightKg:
                          _weight.text.isEmpty
                              ? null
                              : double.tryParse(_weight.text),
                      lotId: lotId,
                      colorId: colorId,
                      characteristicsIds: selectedCharacteristics,
                      eartag:
                          _eartag.text.trim().isEmpty
                              ? null
                              : _eartag.text.trim(),
                      trackerId:
                          _tracker.text.trim().isEmpty
                              ? null
                              : _tracker.text.trim(),
                    ),
                  );
                  _number.clear();
                  _weight.clear();
                  _eartag.clear();
                  _tracker.clear();
                  setState(() {
                    lotId = null;
                    colorId = null;
                    selectedCharacteristics.clear();
                  });
                },
                icon: const Icon(Icons.add),
                label: Text(t.addCattle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

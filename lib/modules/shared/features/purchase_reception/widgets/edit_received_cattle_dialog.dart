import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';

class EditReceivedCattleDialog extends StatefulWidget {
  final Map<String, dynamic> cattle;
  final List<Map<String, dynamic>> availableLots;
  final ReceptionApiService? receptionApi;

  const EditReceivedCattleDialog({
    super.key,
    required this.cattle,
    required this.availableLots,
    this.receptionApi,
  });

  @override
  State<EditReceivedCattleDialog> createState() =>
      _EditReceivedCattleDialogState();
}

class _EditReceivedCattleDialogState extends State<EditReceivedCattleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightCtrl;
  late final TextEditingController _eartagLeftCtrl;
  late final TextEditingController _eartagRightCtrl;
  late final TextEditingController _commentsCtrl;
  String? _selectedLotId;
  String? _selectedColor;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(
      text: '${widget.cattle['receivedWeight'] ?? ''}',
    );
    _eartagLeftCtrl = TextEditingController(
      text: '${widget.cattle['eartagLeft'] ?? ''}',
    );
    _eartagRightCtrl = TextEditingController(
      text: '${widget.cattle['eartagRight'] ?? ''}',
    );
    _commentsCtrl = TextEditingController(
      text: '${widget.cattle['comments'] ?? ''}',
    );
    _selectedLotId = widget.cattle['idLot'] as String?;
    _selectedColor = widget.cattle['color'] as String?;
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _eartagLeftCtrl.dispose();
    _eartagRightCtrl.dispose();
    _commentsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    try {
      await (widget.receptionApi ?? ReceptionApiService()).updateReceivedCattle(
        cattleId: widget.cattle['id'] as String,
        receivedWeight: weight,
        eartagLeft: _eartagLeftCtrl.text.trim(),
        eartagRight: _eartagRightCtrl.text.trim(),
        idLot: _selectedLotId,
        color: _selectedColor,
        comments: _commentsCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = CattleColor.values.map((e) => e.name).toList();

    return AlertDialog(
      title: Text('${l10n.edit} — ${widget.cattle['number']}'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _weightCtrl,
                  decoration: InputDecoration(labelText: l10n.weightKg),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    final n = double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (n == null || n <= 0) return l10n.fieldRequired;
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eartagLeftCtrl,
                  decoration: InputDecoration(labelText: l10n.eartagLeft),
                ),
                TextFormField(
                  controller: _eartagRightCtrl,
                  decoration: InputDecoration(labelText: l10n.eartagRight),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedLotId,
                  decoration: InputDecoration(labelText: l10n.lot),
                  items:
                      widget.availableLots
                          .map(
                            (lot) => DropdownMenuItem<String>(
                              value: lot['id'] as String?,
                              child: Text('${lot['lotNumber'] ?? lot['id']}'),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _selectedLotId = v),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedColor,
                  decoration: InputDecoration(labelText: l10n.color),
                  items:
                      colors
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _selectedColor = v),
                ),
                TextFormField(
                  controller: _commentsCtrl,
                  decoration: InputDecoration(labelText: l10n.comments),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child:
              _saving
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(l10n.save),
        ),
      ],
    );
  }
}

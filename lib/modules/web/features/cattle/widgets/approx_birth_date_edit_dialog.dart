import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/utils/dentition_receive_fields.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/teeth_wear_dropdown_items.dart';

/// Resultado: mapa listo para `PATCH /cattle/:id` (fecha manual o campos de dentición).
class ApproxBirthDateEditDialog extends StatefulWidget {
  const ApproxBirthDateEditDialog({
    super.key,
    this.initialBirthDateAprxDisplay,
    this.milkTeethCount,
    this.permanentTeethCount,
    this.milkTeethWear,
    this.permanentTeethWear,
    this.dentalEvaluationDateRaw,
  });

  final String? initialBirthDateAprxDisplay;
  final int? milkTeethCount;
  final int? permanentTeethCount;
  final int? milkTeethWear;
  final int? permanentTeethWear;
  final String? dentalEvaluationDateRaw;

  @override
  State<ApproxBirthDateEditDialog> createState() =>
      _ApproxBirthDateEditDialogState();
}

class _ApproxBirthDateEditDialogState extends State<ApproxBirthDateEditDialog> {
  bool _manual = true;
  String? _manualDateYmd;
  final _milkCount = TextEditingController();
  final _permCount = TextEditingController();
  int? _milkWearValue;
  int? _permWearValue;
  String? _dentalEvalYmd;
  String? _error;

  @override
  void initState() {
    super.initState();
    _manualDateYmd = widget.initialBirthDateAprxDisplay;
    if (widget.milkTeethCount != null) {
      _milkCount.text = '${widget.milkTeethCount}';
    }
    if (widget.permanentTeethCount != null) {
      _permCount.text = '${widget.permanentTeethCount}';
    }
    _milkWearValue = widget.milkTeethWear;
    _permWearValue = widget.permanentTeethWear;
    if (widget.dentalEvaluationDateRaw != null &&
        widget.dentalEvaluationDateRaw!.isNotEmpty) {
      var formatted = DateTimeHelper.formatLocalDate(
        widget.dentalEvaluationDateRaw,
        fallback: '',
      );
      if (formatted.isEmpty) {
        final p = DateTime.tryParse(widget.dentalEvaluationDateRaw!);
        if (p != null) {
          formatted =
              '${p.year.toString().padLeft(4, '0')}-${p.month.toString().padLeft(2, '0')}-${p.day.toString().padLeft(2, '0')}';
        }
      }
      _dentalEvalYmd = formatted.isEmpty ? null : formatted;
    }

    final hasFullDentition =
        widget.milkTeethCount != null &&
        widget.permanentTeethCount != null &&
        widget.milkTeethWear != null &&
        widget.permanentTeethWear != null &&
        widget.dentalEvaluationDateRaw != null &&
        widget.dentalEvaluationDateRaw.toString().isNotEmpty;
    _manual = !hasFullDentition;
  }

  @override
  void dispose() {
    _milkCount.dispose();
    _permCount.dispose();
    super.dispose();
  }

  Future<void> _pickManualDate() async {
    DateTime? initial = DateTime.tryParse(_manualDateYmd ?? '');
    initial ??= DateTime.now().subtract(const Duration(days: 365));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      useRootNavigator: true,
    );
    if (picked == null) return;
    setState(() {
      _manualDateYmd =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _error = null;
    });
  }

  Future<void> _pickDentalEval() async {
    DateTime? initial = DateTime.tryParse(_dentalEvalYmd ?? '');
    initial ??= DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      useRootNavigator: true,
    );
    if (picked == null) return;
    setState(() {
      _dentalEvalYmd =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _error = null;
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_manual) {
      if (_manualDateYmd == null || _manualDateYmd!.isEmpty) {
        setState(() => _error = l10n.fieldRequired);
        return;
      }
      Navigator.of(context).pop(<String, dynamic>{
        'birthDateAprx': _manualDateYmd,
      });
      return;
    }

    final mc = int.tryParse(_milkCount.text.trim());
    final pc = int.tryParse(_permCount.text.trim());
    final mw = _milkWearValue;
    final pw = _permWearValue;

    final parts = [
      _milkCount.text.trim(),
      _permCount.text.trim(),
      mw != null ? '$mw' : '',
      pw != null ? '$pw' : '',
      _dentalEvalYmd ?? '',
    ];
    if (dentitionHasPartialError(parts)) {
      setState(() => _error = l10n.dentitionCompleteAllOrNone);
      return;
    }
    if (dentitionFilledCount(parts) == 0) {
      setState(() => _error = l10n.fieldRequired);
      return;
    }

    if (mc == null ||
        pc == null ||
        mw == null ||
        pw == null ||
        _dentalEvalYmd == null ||
        _dentalEvalYmd!.isEmpty) {
      setState(() => _error = l10n.invalidValue);
      return;
    }

    Navigator.of(context).pop(<String, dynamic>{
      'milkTeethCount': mc,
      'permanentTeethCount': pc,
      'milkTeethWear': mw,
      'permanentTeethWear': pw,
      'dentalEvaluationDate': _dentalEvalYmd,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.approxBirthEditTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(l10n.birthAprxModeManual),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(l10n.birthAprxModeDentition),
                  ),
                ],
                selected: {_manual},
                onSelectionChanged: (s) {
                  setState(() {
                    _manual = s.first;
                    _error = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_manual) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.approxBirthDate),
                  subtitle: Text(_manualDateYmd ?? '—'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickManualDate,
                  ),
                ),
              ] else ...[
                Text(
                  l10n.dentitionCompleteAllOrNone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _milkCount,
                        decoration: InputDecoration(
                          labelText: l10n.milkTeethCountShort,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _permCount,
                        decoration: InputDecoration(
                          labelText: l10n.permanentTeethCountShort,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 280,
                      child: DropdownButtonFormField<int?>(
                        initialValue: _milkWearValue,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.milkTeethWearShort,
                          border: const OutlineInputBorder(),
                        ),
                        items: teethWearDropdownItems(l10n),
                        onChanged: (v) {
                          setState(() => _milkWearValue = v);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 280,
                      child: DropdownButtonFormField<int?>(
                        initialValue: _permWearValue,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.permanentTeethWearShort,
                          border: const OutlineInputBorder(),
                        ),
                        items: teethWearDropdownItems(l10n),
                        onChanged: (v) {
                          setState(() => _permWearValue = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.dentalEvaluationDateShort),
                  subtitle: Text(_dentalEvalYmd ?? '—'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDentalEval,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.accept)),
      ],
    );
  }
}

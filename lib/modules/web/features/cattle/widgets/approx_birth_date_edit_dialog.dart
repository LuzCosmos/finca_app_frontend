import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/utils/dentition_receive_fields.dart';
// Grados desgaste permitidos según tabla SAPA2014 — ver dentition_table_sapa2014.dart.
import 'package:finca_app_frontend/modules/web/features/cattle/constants/dentition_table_sapa2014.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/teeth_wear_dropdown_items.dart';

/// Resultado: mapa listo para `PATCH /cattle/:id` (fecha manual o campos de dentición).
///
/// En modo dentición, antes de cerrar se llama [previewBirthFromDentition] contra
/// el backend para obtener la fecha estimada (`birthDateAprxPreview` en el mapa).
class ApproxBirthDateEditDialog extends StatefulWidget {
  const ApproxBirthDateEditDialog({
    super.key,
    this.initialBirthDateAprxDisplay,
    this.milkTeethCount,
    this.permanentTeethCount,
    this.milkTeethWear,
    this.permanentTeethWear,
    this.dentalEvaluationDateRaw,
    this.preferDentitionTab = false,
    required this.previewBirthFromDentition,
  });

  final String? initialBirthDateAprxDisplay;
  final int? milkTeethCount;
  final int? permanentTeethCount;
  final int? milkTeethWear;
  final int? permanentTeethWear;
  final String? dentalEvaluationDateRaw;

  /// Si es true y no hay dentición ya completa, el diálogo abre en modo dentición.
  final bool preferDentitionTab;

  /// Consulta servidor: mismos insumos que guardado; respuesta incluye `birthDateAprx`.
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> body)
      previewBirthFromDentition;

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
  /// Último par (leche, permanente) ya normalizado; sirve para detectar cambios de conteos.
  int? _lastNormalizedMc;
  int? _lastNormalizedPc;
  String? _dentalEvalYmd;
  String? _error;
  bool _consultingBirth = false;

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
    if (hasFullDentition) {
      _manual = false;
    } else if (widget.preferDentitionTab) {
      _manual = false;
    } else {
      _manual = true;
    }

    if (!_manual && (_dentalEvalYmd == null || _dentalEvalYmd!.isEmpty)) {
      final n = DateTime.now();
      _dentalEvalYmd =
          '${n.year.toString().padLeft(4, '0')}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
    }

    _milkCount.addListener(_onDentitionCountsChanged);
    _permCount.addListener(_onDentitionCountsChanged);
    _normalizeWearSelectionsForCounts();
  }

  void _normalizeWearSelectionsForCounts() {
    final mc = int.tryParse(_milkCount.text.trim());
    final pc = int.tryParse(_permCount.text.trim());
    if (mc == null || pc == null) return;
    final milkAllowed = allowedMilkWearGradesForSapCounts(mc, pc);
    final permAllowed = allowedPermanentWearGradesForSapCounts(mc, pc);
    var milkV = _milkWearValue;
    var permV = _permWearValue;

    final hadPreviousPair =
        _lastNormalizedMc != null && _lastNormalizedPc != null;
    final countsChanged =
        hadPreviousPair &&
        (_lastNormalizedMc != mc || _lastNormalizedPc != pc);

    if (mc == 0 && milkV != 0) milkV = 0;
    if (pc == 0 && permV != 0) permV = 0;
    if (mc > 0 && milkV == 0) milkV = null;
    if (pc > 0 && permV == 0) permV = null;

    /// Si cambió el par de conteos y hay más de un grado SAPA posible, no conservar
    /// un desgaste previo como «preseleccionado»: el usuario debe elegir de nuevo.
    if (countsChanged) {
      if (milkAllowed.length > 1) milkV = null;
      if (permAllowed.length > 1) permV = null;
    }

    if (milkV != null && !milkAllowed.contains(milkV)) milkV = null;
    if (permV != null && !permAllowed.contains(permV)) permV = null;
    if (milkV == null && milkAllowed.length == 1) milkV = milkAllowed.single;
    if (permV == null && permAllowed.length == 1) permV = permAllowed.single;
    _milkWearValue = milkV;
    _permWearValue = permV;
    _lastNormalizedMc = mc;
    _lastNormalizedPc = pc;
  }

  void _onDentitionCountsChanged() {
    if (!mounted || _manual) return;
    setState(_normalizeWearSelectionsForCounts);
  }

  @override
  void dispose() {
    _milkCount.removeListener(_onDentitionCountsChanged);
    _permCount.removeListener(_onDentitionCountsChanged);
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

  Future<void> _submit() async {
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

    final wearIssue = dentitionWearVsCountIssue(
      milkTeethCount: mc,
      permanentTeethCount: pc,
      milkTeethWear: mw,
      permanentTeethWear: pw,
    );
    if (wearIssue != null) {
      setState(() {
        _error =
            wearIssue == DentitionWearVsCountIssue.milkWearNaWithTeeth
                ? l10n.dentitionWearCannotBeNaWhenMilkTeethPositive
                : l10n.dentitionWearCannotBeNaWhenPermanentTeethPositive;
      });
      return;
    }

    if (!dentitionWearGradesAllowedForSapCounts(
      milkTeethCount: mc,
      permanentTeethCount: pc,
      milkTeethWear: mw,
      permanentTeethWear: pw,
    )) {
      setState(() => _error = l10n.dentitionWearGradeInvalidForTeethCounts);
      return;
    }

    setState(() {
      _consultingBirth = true;
      _error = null;
    });
    try {
      final previewRes = await widget.previewBirthFromDentition({
        'milkTeethCount': mc,
        'permanentTeethCount': pc,
        'milkTeethWear': mw,
        'permanentTeethWear': pw,
        'dentalEvaluationDate': _dentalEvalYmd,
      });
      if (!mounted) return;
      final previewYmd = previewRes['birthDateAprx'] as String?;
      Navigator.of(context).pop(<String, dynamic>{
        'milkTeethCount': mc,
        'permanentTeethCount': pc,
        'milkTeethWear': mw,
        'permanentTeethWear': pw,
        'dentalEvaluationDate': _dentalEvalYmd,
        if (previewYmd != null && previewYmd.isNotEmpty)
          'birthDateAprxPreview': previewYmd,
      });
    } catch (e) {
      if (!mounted) return;
      final msg =
          e is ApiException && e.message.isNotEmpty
              ? e.message
              : e.toString();
      setState(() {
        _consultingBirth = false;
        _error = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mcParsed = int.tryParse(_milkCount.text.trim());
    final pcParsed = int.tryParse(_permCount.text.trim());
    final milkAllowed =
        mcParsed != null && pcParsed != null
            ? allowedMilkWearGradesForSapCounts(mcParsed, pcParsed)
            : null;
    final permAllowed =
        mcParsed != null && pcParsed != null
            ? allowedPermanentWearGradesForSapCounts(mcParsed, pcParsed)
            : null;
    String sapKey(Set<int>? s) =>
        s == null ? '' : (s.toList()..sort()).join(',');
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
                  if (_consultingBirth) return;
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
                        key: ValueKey<String>(
                          'dlg_milkWear_${mcParsed}_${pcParsed}_${sapKey(milkAllowed)}_$_milkWearValue',
                        ),
                        initialValue: _milkWearValue,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.milkTeethWearShort,
                          border: const OutlineInputBorder(),
                        ),
                        items: teethWearDropdownItems(
                          l10n,
                          allowedGrades: milkAllowed,
                        ),
                        onChanged: (v) {
                          setState(() => _milkWearValue = v);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 280,
                      child: DropdownButtonFormField<int?>(
                        key: ValueKey<String>(
                          'dlg_permWear_${mcParsed}_${pcParsed}_${sapKey(permAllowed)}_$_permWearValue',
                        ),
                        initialValue: _permWearValue,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.permanentTeethWearShort,
                          border: const OutlineInputBorder(),
                        ),
                        items: teethWearDropdownItems(
                          l10n,
                          allowedGrades: permAllowed,
                        ),
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
          onPressed:
              _consultingBirth ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _consultingBirth ? null : () => _submit(),
          child:
              _consultingBirth
                  ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(l10n.accept),
        ),
      ],
    );
  }
}

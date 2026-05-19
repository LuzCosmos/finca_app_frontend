import 'dart:async';

import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/constants/dentition_table_sapa2014.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/widgets/approx_birth_date_edit_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/widgets/teeth_wear_dropdown_items.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/dentition_receive_fields.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_birth_date_usage_metrics.dart';

class EditReceivedCattleDialog extends StatefulWidget {
  final Map<String, dynamic> cattle;
  final List<Map<String, dynamic>> availableLots;
  final ReceptionApiService? receptionApi;
  final String? initialLotId;

  const EditReceivedCattleDialog({
    super.key,
    required this.cattle,
    required this.availableLots,
    this.receptionApi,
    this.initialLotId,
  });

  @override
  State<EditReceivedCattleDialog> createState() =>
      _EditReceivedCattleDialogState();
}

String _localDateYmd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String? _ymdFromDynamic(dynamic raw) {
  if (raw == null) return null;
  final s = raw.toString().trim();
  if (s.isEmpty) return null;
  return s.length >= 10 ? s.substring(0, 10) : s;
}

class _EditReceivedCattleDialogState extends State<EditReceivedCattleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final ReceptionApiService _api;
  final CattleMasterService _cattleMasterService = CattleMasterService();

  late final TextEditingController _weightCtrl;
  late final TextEditingController _eartagLeftCtrl;
  late final TextEditingController _eartagRightCtrl;
  late final TextEditingController _commentsCtrl;
  late final TextEditingController _trackerCtrl;
  late final TextEditingController _birthDateAprxCtrl;
  late final TextEditingController _milkTeethCountCtrl;
  late final TextEditingController _permanentTeethCountCtrl;
  late final TextEditingController _dentalEvaluationDateCtrl;
  final _trackerFocusNode = FocusNode();

  final List<String> _colors =
      CattleColor.values.map((e) => e.name).toList();
  final List<String> _characteristicOptions =
      CattleCharacteristic.values.map((e) => e.name).toList();

  String? _selectedLotId;
  String? _selectedColor;
  List<String> _selectedCharacteristicIds = [];
  bool _hasHorns = false;
  bool _isCastrated = false;
  CattleGender _selectedGender = CattleGender.MALE;
  int? _milkTeethWearValue;
  int? _permanentTeethWearValue;
  bool _showQuickDentitionFields = false;

  String? _selectedDeviceId;
  String? _lastSelectedDeviceName;
  List<DeviceModel> _deviceOptions = [];
  bool _deviceLoading = false;
  Completer<List<DeviceModel>>? _lastCompleter;
  Timer? _debounce;
  Timer? _eartagLeftDebounce;
  Timer? _eartagRightDebounce;
  String? _eartagLeftExternalError;
  String? _eartagRightExternalError;
  bool _isValidatingEartagLeft = false;
  bool _isValidatingEartagRight = false;

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = widget.receptionApi ?? ReceptionApiService();
    final c = widget.cattle;

    _weightCtrl = TextEditingController(text: '${c['receivedWeight'] ?? ''}');
    _eartagLeftCtrl = TextEditingController(text: '${c['eartagLeft'] ?? ''}');
    _eartagRightCtrl = TextEditingController(text: '${c['eartagRight'] ?? ''}');
    _commentsCtrl = TextEditingController(text: '${c['comments'] ?? ''}');
    _birthDateAprxCtrl = TextEditingController(
      text: _ymdFromDynamic(c['birthDateAprx']) ?? '',
    );
    _milkTeethCountCtrl = TextEditingController(
      text: c['milkTeethCount'] != null ? '${c['milkTeethCount']}' : '',
    );
    _permanentTeethCountCtrl = TextEditingController(
      text:
          c['permanentTeethCount'] != null
              ? '${c['permanentTeethCount']}'
              : '',
    );
    _dentalEvaluationDateCtrl = TextEditingController(
      text:
          _ymdFromDynamic(c['dentalEvaluationDate']) ??
          _localDateYmd(DateTime.now()),
    );
    _trackerCtrl = TextEditingController(
      text: '${c['deviceName'] == '-' ? '' : c['deviceName'] ?? ''}',
    );

    _selectedLotId = _resolveInitialLotId();
    _selectedColor = c['color'] as String?;
    _hasHorns = c['hasHorn'] == true || c['hasHorns'] == true;
    _isCastrated = c['castrated'] == true || c['isCastrated'] == true;
    _milkTeethWearValue = c['milkTeethWear'] as int?;
    _permanentTeethWearValue = c['permanentTeethWear'] as int?;
    _selectedCharacteristicIds = List<String>.from(
      (c['characteristics'] as List<dynamic>?)?.map((e) => e.toString()) ??
          [],
    );
    final deviceId = c['idDevice']?.toString();
    _selectedDeviceId =
        deviceId != null && deviceId.isNotEmpty ? deviceId : null;
    _lastSelectedDeviceName = _trackerCtrl.text.trim().isEmpty
        ? null
        : _trackerCtrl.text.trim();

    final genderRaw = c['gender']?.toString();
    if (genderRaw != null) {
      _selectedGender = CattleGender.values.firstWhere(
        (g) => g.name == genderRaw,
        orElse: () => CattleGender.MALE,
      );
    }

    _milkTeethCountCtrl.addListener(_onQuickDentitionCountsChanged);
    _permanentTeethCountCtrl.addListener(_onQuickDentitionCountsChanged);
    _trackerCtrl.addListener(() {
      if (_selectedDeviceId != null &&
          _trackerCtrl.text != _lastSelectedDeviceName) {
        setState(() => _selectedDeviceId = null);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshQuickDentitionVisibility();
    });
  }

  String? _resolveInitialLotId() {
    final raw = widget.cattle['idLot'] ?? widget.initialLotId;
    if (raw == null) return null;
    final id = raw.toString();
    final exists = widget.availableLots.any(
      (lot) => lot['id']?.toString() == id,
    );
    return exists ? id : null;
  }

  Future<void> _refreshQuickDentitionVisibility() async {
    final v =
        await ReceptionBirthDateUsageMetrics.shouldShowQuickDentitionFields();
    if (mounted) setState(() => _showQuickDentitionFields = v);
  }

  void _onQuickDentitionCountsChanged() {
    if (!mounted) return;
    _syncWearFromTeethCounts();
    setState(() {});
  }

  void _syncWearFromTeethCounts() {
    final milk = int.tryParse(_milkTeethCountCtrl.text.trim());
    final perm = int.tryParse(_permanentTeethCountCtrl.text.trim());
    if (milk == 0 && _milkTeethWearValue != 0) {
      _milkTeethWearValue = 0;
    }
    if (perm == 0 && _permanentTeethWearValue != 0) {
      _permanentTeethWearValue = 0;
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _eartagLeftCtrl.dispose();
    _eartagRightCtrl.dispose();
    _commentsCtrl.dispose();
    _trackerCtrl.dispose();
    _birthDateAprxCtrl.dispose();
    _milkTeethCountCtrl.dispose();
    _permanentTeethCountCtrl.dispose();
    _dentalEvaluationDateCtrl.dispose();
    _trackerFocusNode.dispose();
    _debounce?.cancel();
    _eartagLeftDebounce?.cancel();
    _eartagRightDebounce?.cancel();
    super.dispose();
  }

  Future<void> _openApproxBirthEditDialog({bool preferDentition = false}) async {
    final mc = int.tryParse(_milkTeethCountCtrl.text.trim());
    final pc = int.tryParse(_permanentTeethCountCtrl.text.trim());
    final birthText = _birthDateAprxCtrl.text.trim();
    final dentalRaw = _dentalEvaluationDateCtrl.text.trim();
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder:
          (ctx) => ApproxBirthDateEditDialog(
            initialBirthDateAprxDisplay:
                birthText.isEmpty ? null : birthText,
            milkTeethCount: mc,
            permanentTeethCount: pc,
            milkTeethWear: _milkTeethWearValue,
            permanentTeethWear: _permanentTeethWearValue,
            dentalEvaluationDateRaw: dentalRaw.isEmpty ? null : dentalRaw,
            preferDentitionTab: preferDentition,
            previewBirthFromDentition:
                _cattleMasterService.previewBirthFromDentition,
          ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (result.containsKey('birthDateAprx')) {
        final ymd = result['birthDateAprx'] as String? ?? '';
        _birthDateAprxCtrl.text = ymd;
        _milkTeethCountCtrl.clear();
        _permanentTeethCountCtrl.clear();
        _milkTeethWearValue = null;
        _permanentTeethWearValue = null;
        _dentalEvaluationDateCtrl.clear();
      } else {
        final preview =
            result['birthDateAprxPreview'] as String? ??
            result['birthDateAprx'] as String?;
        _birthDateAprxCtrl.text = preview ?? '';
        _milkTeethCountCtrl.text = '${result['milkTeethCount']}';
        _permanentTeethCountCtrl.text = '${result['permanentTeethCount']}';
        _milkTeethWearValue = result['milkTeethWear'] as int?;
        _permanentTeethWearValue = result['permanentTeethWear'] as int?;
        _dentalEvaluationDateCtrl.text =
            result['dentalEvaluationDate'] as String? ?? '';
      }
    });
  }

  Future<void> _pickDentalEvaluationDate() async {
    final now = DateTime.now();
    final initial =
        DateTime.tryParse(_dentalEvaluationDateCtrl.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      _dentalEvaluationDateCtrl.text = _localDateYmd(picked);
    });
  }

  Future<void> _checkEartagExists(String val, {required bool isLeft}) async {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = val.trim();
    final original =
        isLeft
            ? (widget.cattle['eartagLeft']?.toString().trim() ?? '')
            : (widget.cattle['eartagRight']?.toString().trim() ?? '');
    if (trimmed.isEmpty || trimmed == original) {
      setState(() {
        if (isLeft) {
          _eartagLeftExternalError = null;
        } else {
          _eartagRightExternalError = null;
        }
      });
      return;
    }
    setState(() {
      if (isLeft) {
        _isValidatingEartagLeft = true;
      } else {
        _isValidatingEartagRight = true;
      }
    });
    try {
      final exists = await _api.checkEartagExists(trimmed);
      if (!mounted) return;
      setState(() {
        if (exists) {
          if (isLeft) {
            _eartagLeftExternalError = l10n.eartag_exists_error;
          } else {
            _eartagRightExternalError = l10n.eartag_exists_error;
          }
        } else {
          if (isLeft) {
            _eartagLeftExternalError = null;
          } else {
            _eartagRightExternalError = null;
          }
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          if (isLeft) {
            _isValidatingEartagLeft = false;
          } else {
            _isValidatingEartagRight = false;
          }
        });
      }
    }
  }

  Future<void> _showCharacteristicsDialog(AppLocalizations l10n) async {
    final tempSelected = List<String>.from(_selectedCharacteristicIds);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.characteristics),
              content: SizedBox(
                width: 400,
                height: 400,
                child: ListView(
                  children:
                      _characteristicOptions.map((char) {
                        final isSelected = tempSelected.contains(char);
                        final enumVal = CattleCharacteristic.fromString(char);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                final category =
                                    enumVal?.getCategory() ?? 'OTHER';
                                if ([
                                  'HEAD',
                                  'BELLY',
                                  'LEGS',
                                  'FEET',
                                  'SPOTS',
                                  'PATTERN',
                                ].contains(category)) {
                                  tempSelected.removeWhere(
                                    (id) =>
                                        CattleCharacteristic.fromString(
                                          id,
                                        )?.getCategory() ==
                                        category,
                                  );
                                } else if (category == 'HALF_HEAD') {
                                  final currentHalfHeads =
                                      tempSelected
                                          .where(
                                            (id) =>
                                                CattleCharacteristic.fromString(
                                                  id,
                                                )?.getCategory() ==
                                                'HALF_HEAD',
                                          )
                                          .toList();
                                  if (currentHalfHeads.length >= 2) {
                                    tempSelected.remove(currentHalfHeads.first);
                                  }
                                }
                                tempSelected.add(char);
                              } else {
                                tempSelected.remove(char);
                              }
                            });
                          },
                          title: Text(enumVal?.localizedName(context) ?? char),
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedCharacteristicIds = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final dentParts = [
      _milkTeethCountCtrl.text.trim(),
      _permanentTeethCountCtrl.text.trim(),
      _milkTeethWearValue != null ? '$_milkTeethWearValue' : '',
      _permanentTeethWearValue != null ? '$_permanentTeethWearValue' : '',
      _dentalEvaluationDateCtrl.text.trim(),
    ];
    if (dentitionHasPartialError(dentParts)) {
      setState(() => _error = l10n.dentitionCompleteAllOrNone);
      return;
    }

    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    if (weight == null || weight <= 0) {
      setState(() => _error = l10n.fieldRequired);
      return;
    }

    int? milkC;
    int? permC;
    int? milkW;
    int? permW;
    String? dentalEval;
    String? birthAprx;

    if (dentitionIsCompleteFive(dentParts)) {
      milkC = int.tryParse(_milkTeethCountCtrl.text.trim());
      permC = int.tryParse(_permanentTeethCountCtrl.text.trim());
      milkW = _milkTeethWearValue;
      permW = _permanentTeethWearValue;
      dentalEval = _dentalEvaluationDateCtrl.text.trim();
      if (milkC == null ||
          permC == null ||
          milkW == null ||
          permW == null ||
          dentalEval.isEmpty) {
        setState(() => _error = l10n.invalidValue);
        return;
      }
      final wearIssue = dentitionWearVsCountIssue(
        milkTeethCount: milkC,
        permanentTeethCount: permC,
        milkTeethWear: milkW,
        permanentTeethWear: permW,
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
        milkTeethCount: milkC,
        permanentTeethCount: permC,
        milkTeethWear: milkW,
        permanentTeethWear: permW,
      )) {
        setState(() => _error = l10n.dentitionWearGradeInvalidForTeethCounts);
        return;
      }
    } else {
      final birthText = _birthDateAprxCtrl.text.trim();
      birthAprx = birthText.isEmpty ? null : birthText;
    }

    final body = <String, dynamic>{
      'receivedWeight': weight,
      'eartagLeft': _eartagLeftCtrl.text.trim(),
      'eartagRight': _eartagRightCtrl.text.trim(),
      'idLot': _selectedLotId,
      'hasHorn': _hasHorns,
      'castrated': _isCastrated,
      'gender': _selectedGender.name,
      'color': _selectedColor,
      'characteristics': _selectedCharacteristicIds,
      'comments': _commentsCtrl.text.trim(),
      'idDevice': _selectedDeviceId,
    };

    if (dentitionIsCompleteFive(dentParts)) {
      body['milkTeethCount'] = milkC;
      body['permanentTeethCount'] = permC;
      body['milkTeethWear'] = milkW;
      body['permanentTeethWear'] = permW;
      body['dentalEvaluationDate'] = dentalEval;
      body['birthDateAprx'] = null;
    } else {
      body['birthDateAprx'] = birthAprx;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _api.updateReceivedCattle(
        cattleId: widget.cattle['id'] as String,
        body: body,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _saving = false;
      });
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

    return AlertDialog(
      title: Text('${l10n.edit} — ${widget.cattle['number']}'),
      content: SizedBox(
        width: 920,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 145,
                      child: DropdownButtonFormField<String>(
                        value: _selectedLotId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.lot,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(l10n.withoutLot),
                          ),
                          ...widget.availableLots.map(
                            (lot) => DropdownMenuItem<String>(
                              value: lot['id'] as String?,
                              child: Text(
                                '${l10n.lot} ${lot['lotNumber'] ?? lot['id']}',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedLotId = v),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        key: const ValueKey('edit_cattle_weight'),
                        controller: _weightCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.weightKg,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          final n = double.tryParse(
                            v?.replaceAll(',', '.') ?? '',
                          );
                          if (n == null || n <= 0) return l10n.fieldRequired;
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: CheckboxListTile(
                        value: _hasHorns,
                        onChanged:
                            (v) => setState(() => _hasHorns = v ?? false),
                        title: Text(
                          l10n.hasHorns,
                          style: const TextStyle(fontSize: 14),
                        ),
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(
                      width: 125,
                      child: CheckboxListTile(
                        value: _isCastrated,
                        onChanged:
                            (v) => setState(() => _isCastrated = v ?? false),
                        title: Text(
                          l10n.isCastrated,
                          style: const TextStyle(fontSize: 14),
                        ),
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(
                      width: 420,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _birthDateAprxCtrl,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: l10n.approxBirthDate,
                                border: const OutlineInputBorder(),
                                suffixIcon: const Icon(Icons.edit_calendar),
                              ),
                              onTap: () => _openApproxBirthEditDialog(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: TextButton(
                              onPressed:
                                  () => _openApproxBirthEditDialog(
                                    preferDentition: true,
                                  ),
                              child: Text(l10n.calculateBirthByDentition),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<CattleGender>(
                        value: _selectedGender,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.gender,
                          border: const OutlineInputBorder(),
                        ),
                        items:
                            CattleGender.values
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g.localizedName(context)),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (v) => setState(
                              () => _selectedGender = v ?? _selectedGender,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: DropdownButtonFormField<String>(
                        value: _selectedColor,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: l10n.color),
                        validator:
                            (v) => v == null ? l10n.fieldRequired : null,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('—'),
                          ),
                          ..._colors.map((color) {
                            final enumVal = CattleColor.fromString(color);
                            return DropdownMenuItem(
                              value: color,
                              child: Text(enumVal.localizedName(context)),
                            );
                          }),
                        ],
                        onChanged: (v) => setState(() => _selectedColor = v),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showCharacteristicsDialog(l10n),
                      icon: const Icon(Icons.list),
                      label: Text(
                        '${l10n.characteristics} (${_selectedCharacteristicIds.length})',
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        controller: _eartagRightCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.eartagRight,
                          border: const OutlineInputBorder(),
                          errorText: _eartagRightExternalError,
                          suffixIcon:
                              _isValidatingEartagRight
                                  ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        validator: (v) => _eartagRightExternalError,
                        onChanged: (value) {
                          if (_eartagRightDebounce?.isActive ?? false) {
                            _eartagRightDebounce!.cancel();
                          }
                          _eartagRightDebounce = Timer(
                            const Duration(milliseconds: 500),
                            () => _checkEartagExists(value, isLeft: false),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        controller: _eartagLeftCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.eartagLeft,
                          border: const OutlineInputBorder(),
                          errorText: _eartagLeftExternalError,
                          suffixIcon:
                              _isValidatingEartagLeft
                                  ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        validator: (v) => _eartagLeftExternalError,
                        onChanged: (value) {
                          if (_eartagLeftDebounce?.isActive ?? false) {
                            _eartagLeftDebounce!.cancel();
                          }
                          _eartagLeftDebounce = Timer(
                            const Duration(milliseconds: 500),
                            () => _checkEartagExists(value, isLeft: true),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: RawAutocomplete<DeviceModel>(
                        textEditingController: _trackerCtrl,
                        focusNode: _trackerFocusNode,
                        optionsBuilder: (textEditingValue) {
                          if (_lastCompleter != null &&
                              !_lastCompleter!.isCompleted) {
                            _lastCompleter!.complete(
                              const Iterable<DeviceModel>.empty().toList(),
                            );
                          }
                          final completer = Completer<List<DeviceModel>>();
                          _lastCompleter = completer;
                          if (textEditingValue.text.length < 3) {
                            completer.complete(
                              const Iterable<DeviceModel>.empty().toList(),
                            );
                            return completer.future;
                          }
                          if (_debounce?.isActive ?? false) {
                            _debounce!.cancel();
                          }
                          _debounce = Timer(
                            const Duration(milliseconds: 500),
                            () async {
                              if (!mounted) return;
                              setState(() => _deviceLoading = true);
                              try {
                                final results =
                                    await DeviceApiService.searchDevices(
                                      textEditingValue.text,
                                    );
                                if (mounted) {
                                  setState(() => _deviceOptions = results);
                                }
                                if (!completer.isCompleted) {
                                  completer.complete(results);
                                }
                              } catch (_) {
                                if (!completer.isCompleted) {
                                  completer.complete(
                                    const Iterable<DeviceModel>.empty()
                                        .toList(),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _deviceLoading = false);
                                }
                              }
                            },
                          );
                          return completer.future;
                        },
                        displayStringForOption: (o) => o.name,
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) =>
                                TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        _selectedDeviceId == null) {
                                      if (_deviceOptions.isEmpty) {
                                        return l10n.trackerNotFound;
                                      }
                                      return l10n.trackerNotSelected;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: l10n.tracker,
                                    border: const OutlineInputBorder(),
                                    suffixIcon:
                                        _deviceLoading
                                            ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 300,
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option.name),
                                      subtitle: Text(option.deveui),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        onSelected: (selection) {
                          setState(() {
                            _selectedDeviceId = selection.id;
                            _lastSelectedDeviceName = selection.name;
                            _trackerCtrl.text = selection.name;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _commentsCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.comments,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                if (_showQuickDentitionFields)
                  ExpansionTile(
                    title: Text(l10n.dentitionQuickFieldsSection),
                    childrenPadding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 12,
                    ),
                    children: [
                      Text(
                        l10n.dentitionCompleteAllOrNone,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final mcParsed = int.tryParse(
                            _milkTeethCountCtrl.text.trim(),
                          );
                          final pcParsed = int.tryParse(
                            _permanentTeethCountCtrl.text.trim(),
                          );
                          final milkAllowed =
                              mcParsed != null && pcParsed != null
                                  ? allowedMilkWearGradesForSapCounts(
                                    mcParsed,
                                    pcParsed,
                                  )
                                  : null;
                          final permAllowed =
                              mcParsed != null && pcParsed != null
                                  ? allowedPermanentWearGradesForSapCounts(
                                    mcParsed,
                                    pcParsed,
                                  )
                                  : null;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: 110,
                                child: TextFormField(
                                  controller: _milkTeethCountCtrl,
                                  decoration: InputDecoration(
                                    labelText: l10n.milkTeethCountShort,
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: 280,
                                child: DropdownButtonFormField<int?>(
                                  value: _milkTeethWearValue,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: l10n.milkTeethWearShort,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: teethWearDropdownItems(
                                    l10n,
                                    allowedGrades: milkAllowed,
                                  ),
                                  onChanged:
                                      (v) => setState(
                                        () => _milkTeethWearValue = v,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: TextFormField(
                                  controller: _permanentTeethCountCtrl,
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
                                  value: _permanentTeethWearValue,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: l10n.permanentTeethWearShort,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: teethWearDropdownItems(
                                    l10n,
                                    allowedGrades: permAllowed,
                                  ),
                                  onChanged:
                                      (v) => setState(
                                        () => _permanentTeethWearValue = v,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: TextFormField(
                                  controller: _dentalEvaluationDateCtrl,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: l10n.dentalEvaluationDateShort,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  onTap: _pickDentalEvaluationDate,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
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
          key: const ValueKey('edit_cattle_save'),
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

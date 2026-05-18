import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/dentition_receive_fields.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_birth_date_usage_metrics.dart';
// Grados desgaste permitidos según tabla SAPA2014 — ver dentition_table_sapa2014.dart.
import 'package:finca_app_frontend/modules/shared/features/cattle/constants/dentition_table_sapa2014.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/widgets/teeth_wear_dropdown_items.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/widgets/approx_birth_date_edit_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/widgets/live_scale_reading_panel.dart';

class ReceiveCattleForm extends StatefulWidget {
  final String? currentNumber;
  final List<Map<String, dynamic>> availableLots;
  final List<SimpleEventModel> activeEvents;
  final Function(Map<String, dynamic> cattleData) onSubmit;
  final Function(String number) onNumberChanged;
  final Function(String error)? onError;

  /// Inyección opcional para tests widget (evita HTTP en validación de número/arete/búsqueda).
  final ReceptionApiService? receptionApiService;

  const ReceiveCattleForm({
    super.key,
    this.currentNumber,
    required this.availableLots,
    required this.activeEvents,
    required this.onSubmit,
    required this.onNumberChanged,
    this.onError,
    this.receptionApiService,
  });

  @override
  State<ReceiveCattleForm> createState() => _ReceiveCattleFormState();
}

String _localDateYmd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _dentitionSapAllowedKey(Set<int>? s) =>
    s == null ? '' : (s.toList()..sort()).join(',');

class _ReceiveCattleFormState extends State<ReceiveCattleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberController;
  final _weightController = TextEditingController();
  final _commentsController = TextEditingController();
  final _eartagLeftController = TextEditingController();
  final _eartagRightController = TextEditingController();
  final _trackerController = TextEditingController();
  final FocusNode _trackerFocusNode = FocusNode();
  final List<String> colors = CattleColor.values.map((e) => e.name).toList();
  final List<String> characteristics =
      CattleCharacteristic.values.map((e) => e.name).toList();

  Timer? _debounce;
  Timer? _numberDebounce;
  Timer? _eartagLeftDebounce;
  Timer? _eartagRightDebounce;
  String? _numberExternalError;
  String? _eartagLeftExternalError;
  String? _eartagRightExternalError;
  bool _isValidatingNumber = false;
  bool _isValidatingEartagLeft = false;
  bool _isValidatingEartagRight = false;

  List<DeviceModel> _deviceOptions = [];
  bool _deviceLoading = false;
  Completer<List<DeviceModel>>?
  _lastCompleter; // Track last completer to prevent hangs
  late ReceptionApiService _apiService;
  final CattleMasterService _cattleMasterService = CattleMasterService();
  String? _selectedDeviceId; // Store the selected device ID
  String? _lastSelectedName; // To track if text matches selection

  String? selectedLotId;
  String? selectedColorId;
  List<String> selectedCharacteristicIds = [];
  bool hasHorns = false;
  bool isCastrated = false;
  final _birthDateAprxController = TextEditingController();
  final _milkTeethCountController = TextEditingController();
  final _permanentTeethCountController = TextEditingController();
  final _dentalEvaluationDateController = TextEditingController();
  /// Desgaste escala 0–5 (SAPA); null = no seleccionado.
  int? _milkTeethWearValue;
  int? _permanentTeethWearValue;
  /// Último par (leche, permanente) tras sincronizar desgastes (bloque rápido).
  int? _lastQuickDentitionMc;
  int? _lastQuickDentitionPc;
  CattleGender _selectedGender = CattleGender.MALE;

  /// Bloque inline de dentición solo si las métricas locales indican uso mayoritario.
  bool _showQuickDentitionFields = false;

  @override
  void initState() {
    super.initState();
    _apiService = widget.receptionApiService ?? ReceptionApiService();
    _dentalEvaluationDateController.text = _localDateYmd(DateTime.now());
    _milkTeethCountController.addListener(_onQuickDentitionCountsChanged);
    _permanentTeethCountController.addListener(_onQuickDentitionCountsChanged);
    _numberController = TextEditingController(text: widget.currentNumber);
    _trackerController.addListener(() {
      if (_selectedDeviceId != null &&
          _trackerController.text != _lastSelectedName) {
        setState(() {
          _selectedDeviceId = null;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshQuickDentitionVisibility();
    });
  }

  Future<void> _refreshQuickDentitionVisibility() async {
    final v =
        await ReceptionBirthDateUsageMetrics.shouldShowQuickDentitionFields();
    if (mounted) setState(() => _showQuickDentitionFields = v);
  }

  Future<void> _openApproxBirthEditDialog({bool preferDentition = false}) async {
    final mc = int.tryParse(_milkTeethCountController.text.trim());
    final pc = int.tryParse(_permanentTeethCountController.text.trim());
    final birthText = _birthDateAprxController.text.trim();
    final dentalRaw = _dentalEvaluationDateController.text.trim();
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
        _birthDateAprxController.text = ymd;
        _milkTeethCountController.clear();
        _permanentTeethCountController.clear();
        _milkTeethWearValue = null;
        _permanentTeethWearValue = null;
        _dentalEvaluationDateController.clear();
      } else {
        final preview =
            result['birthDateAprxPreview'] as String? ??
                result['birthDateAprx'] as String?;
        _birthDateAprxController.text = preview ?? '';
        _milkTeethCountController.text = '${result['milkTeethCount']}';
        _permanentTeethCountController.text =
            '${result['permanentTeethCount']}';
        _milkTeethWearValue = result['milkTeethWear'] as int?;
        _permanentTeethWearValue = result['permanentTeethWear'] as int?;
        _dentalEvaluationDateController.text =
            result['dentalEvaluationDate'] as String? ?? '';
      }
    });
  }

  @override
  void didUpdateWidget(ReceiveCattleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentNumber != oldWidget.currentNumber) {
      if (_numberController.text != widget.currentNumber) {
        _numberController.text = widget.currentNumber ?? '';
        _checkNumberExists(widget.currentNumber ?? '');
      }
    }
  }

  void _onQuickDentitionCountsChanged() {
    if (!mounted) return;
    _syncWearFromTeethCounts();
    setState(() {});
  }

  void _syncWearFromTeethCounts() {
    final milk = int.tryParse(_milkTeethCountController.text.trim());
    final perm = int.tryParse(_permanentTeethCountController.text.trim());
    if (milk == 0 && _milkTeethWearValue != 0) {
      _milkTeethWearValue = 0;
    }
    if (perm == 0 && _permanentTeethWearValue != 0) {
      _permanentTeethWearValue = 0;
    }
    if (milk != null && milk > 0 && _milkTeethWearValue == 0) {
      _milkTeethWearValue = null;
    }
    if (perm != null && perm > 0 && _permanentTeethWearValue == 0) {
      _permanentTeethWearValue = null;
    }
    if (milk != null && perm != null) {
      final milkAllowed = allowedMilkWearGradesForSapCounts(milk, perm);
      final permAllowed = allowedPermanentWearGradesForSapCounts(milk, perm);
      final hadPrev =
          _lastQuickDentitionMc != null && _lastQuickDentitionPc != null;
      final countsChanged =
          hadPrev &&
          (_lastQuickDentitionMc != milk || _lastQuickDentitionPc != perm);

      if (countsChanged) {
        if (milkAllowed.length > 1) _milkTeethWearValue = null;
        if (permAllowed.length > 1) _permanentTeethWearValue = null;
      }

      if (_milkTeethWearValue != null &&
          !milkAllowed.contains(_milkTeethWearValue)) {
        _milkTeethWearValue = null;
      }
      if (_permanentTeethWearValue != null &&
          !permAllowed.contains(_permanentTeethWearValue)) {
        _permanentTeethWearValue = null;
      }
      if (_milkTeethWearValue == null && milkAllowed.length == 1) {
        _milkTeethWearValue = milkAllowed.single;
      }
      if (_permanentTeethWearValue == null && permAllowed.length == 1) {
        _permanentTeethWearValue = permAllowed.single;
      }

      _lastQuickDentitionMc = milk;
      _lastQuickDentitionPc = perm;
    }
  }

  @override
  void dispose() {
    _milkTeethCountController.removeListener(_onQuickDentitionCountsChanged);
    _permanentTeethCountController.removeListener(_onQuickDentitionCountsChanged);
    _numberController.dispose();
    _weightController.dispose();
    _commentsController.dispose();
    _eartagLeftController.dispose();
    _eartagRightController.dispose();
    _trackerController.dispose();
    _trackerFocusNode.dispose();
    _birthDateAprxController.dispose();
    _milkTeethCountController.dispose();
    _permanentTeethCountController.dispose();
    _dentalEvaluationDateController.dispose();
    _debounce?.cancel();
    _numberDebounce?.cancel();
    _eartagLeftDebounce?.cancel();
    _eartagRightDebounce?.cancel();
    super.dispose();
  }

  /*void _resetForm() {
    _weightController.clear();
    _ageController.clear();
    _commentsController.clear();
    _eartagController.clear();
    _trackerController.clear();
    setState(() {
      selectedLotId = null;
      selectedColorId = null;
      selectedCharacteristicIds = [];
      hasHorns = false;
      isCastrated = false;
      _selectedGender = CattleGender.MALE;
      _selectedDeviceId = null; // Clear selected device
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.receiveCattle.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 1),
              LiveScaleReadingPanel(
                onApplyStableWeight: (_, formatted) {
                  _weightController.text = formatted;
                  setState(() {});
                },
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Cattle Number
                  SizedBox(
                    width: 125,
                    child: TextFormField(
                      key: const ValueKey('receive_form_number'),
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: l10n.cattleNumber,
                        border: const OutlineInputBorder(),
                        errorText: _numberExternalError,
                        suffixIcon:
                            _isValidatingNumber
                                ? const Padding(
                                  padding: EdgeInsets.all(12.0),
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
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.fieldRequired;
                        }
                        if (_numberExternalError != null) {
                          return _numberExternalError;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.onNumberChanged(value);
                        if (_numberDebounce?.isActive ?? false) {
                          _numberDebounce!.cancel();
                        }
                        _numberDebounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            _checkNumberExists(value);
                          },
                        );
                      },
                    ),
                  ),

                  // Lot Selection
                  SizedBox(
                    width: 145,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedLotId,
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
                            value: lot['id'] as String,
                            child: Text('${l10n.lot} ${lot['lotNumber']}'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => selectedLotId = value);
                      },
                    ),
                  ),

                  // Weight
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      key: const ValueKey('receive_form_weight'),
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: l10n.weightKg,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.fieldRequired;
                        }
                        if (double.tryParse(v) == null) {
                          return l10n.invalidValue;
                        }
                        return null;
                      },
                    ),
                  ),

                  // Has Horns Checkbox
                  SizedBox(
                    width: 120,
                    child: CheckboxListTile(
                      value: hasHorns,
                      onChanged: (value) {
                        setState(() => hasHorns = value ?? false);
                      },
                      title: Text(
                        l10n.hasHorns,
                        style: const TextStyle(fontSize: 14),
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  // Is Castrated Checkbox
                  SizedBox(
                    width: 125,
                    child: CheckboxListTile(
                      value: isCastrated,
                      onChanged: (value) {
                        setState(() => isCastrated = value ?? false);
                      },
                      title: Text(
                        l10n.isCastrated,
                        style: const TextStyle(fontSize: 14),
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  // Fecha aprox. — diálogo compartido con lista maestra (+ dentición)
                  SizedBox(
                    width: 420,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _birthDateAprxController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: l10n.approxBirthDate,
                              hintText:
                                  dentitionIsCompleteFive([
                                        _milkTeethCountController.text.trim(),
                                        _permanentTeethCountController.text
                                            .trim(),
                                        _milkTeethWearValue != null
                                            ? '$_milkTeethWearValue'
                                            : '',
                                        _permanentTeethWearValue != null
                                            ? '$_permanentTeethWearValue'
                                            : '',
                                        _dentalEvaluationDateController.text
                                            .trim(),
                                      ])
                                      ? l10n.approxBirthFilledViaDentitionHint
                                      : null,
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

                  // Gender
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<CattleGender>(
                      initialValue: _selectedGender,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.gender,
                        border: const OutlineInputBorder(),
                      ),
                      items:
                          CattleGender.values.map((gender) {
                            return DropdownMenuItem<CattleGender>(
                              value: gender,
                              child: Text(gender.localizedName(context)),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                  ),

                  // Color Dropdown
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedColorId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.color),
                      validator:
                          (value) => value == null ? l10n.fieldRequired : null,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: const Text('—'),
                        ),
                        ...colors.map((color) {
                          final enumVal = CattleColor.fromString(color);
                          return DropdownMenuItem<String>(
                            value: color,
                            child: Text(enumVal.localizedName(context)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() => selectedColorId = value);
                      },
                    ),
                  ),

                  // Characteristics Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _showCharacteristicsDialog(l10n);
                    },
                    icon: const Icon(Icons.list),
                    label: Text(
                      '${l10n.characteristics} (${selectedCharacteristicIds.length})',
                    ),
                  ),

                  // Eartag left
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _eartagRightController,
                      decoration: InputDecoration(
                        labelText: l10n.eartagRight,
                        border: const OutlineInputBorder(),
                        errorText: _eartagRightExternalError,
                        suffixIcon:
                            _isValidatingEartagRight
                                ? const Padding(
                                  padding: EdgeInsets.all(12.0),
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
                      validator: (v) {
                        if (_eartagRightExternalError != null) {
                          return _eartagRightExternalError;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (_eartagRightDebounce?.isActive ?? false) {
                          _eartagRightDebounce!.cancel();
                        }
                        _eartagRightDebounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            _checkEartagExists(value, isLeft: false);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _eartagLeftController,
                      decoration: InputDecoration(
                        labelText: l10n.eartagLeft,
                        border: const OutlineInputBorder(),
                        errorText: _eartagLeftExternalError,
                        suffixIcon:
                            _isValidatingEartagLeft
                                ? const Padding(
                                  padding: EdgeInsets.all(12.0),
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
                      validator: (v) {
                        if (_eartagLeftExternalError != null) {
                          return _eartagLeftExternalError;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (_eartagLeftDebounce?.isActive ?? false) {
                          _eartagLeftDebounce!.cancel();
                        }
                        _eartagLeftDebounce = Timer(
                          const Duration(milliseconds: 500),
                          () {
                            _checkEartagExists(value, isLeft: true);
                          },
                        );
                      },
                    ),
                  ),

                  // Tracker Autocomplete
                  SizedBox(
                    width: 200,
                    child: RawAutocomplete<DeviceModel>(
                      textEditingController: _trackerController,
                      focusNode: _trackerFocusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Cancel previous completer if it exists and hasn't completed
                        if (_lastCompleter != null &&
                            !_lastCompleter!.isCompleted) {
                          _lastCompleter!.complete(
                            const Iterable<DeviceModel>.empty().toList(),
                          );
                        }

                        final Completer<List<DeviceModel>> completer =
                            Completer();
                        _lastCompleter = completer;

                        if (textEditingValue.text.length < 3) {
                          if (_deviceOptions.isNotEmpty) {
                            setState(() => _deviceOptions = []);
                          }
                          completer.complete(
                            const Iterable<DeviceModel>.empty().toList(),
                          );
                          return completer.future;
                        }

                        // Debounce search
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

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
                              setState(() => _deviceOptions = results);
                              if (!completer.isCompleted) {
                                completer.complete(results);
                              }
                            } catch (e) {
                              debugPrint('DEBUG: API error: $e');
                              setState(() => _deviceOptions = []);
                              if (!completer.isCompleted) {
                                completer.complete(
                                  const Iterable<DeviceModel>.empty().toList(),
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
                      displayStringForOption:
                          (DeviceModel option) => option.name,
                      fieldViewBuilder: (
                        context,
                        controller,
                        focusNode,
                        onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            labelText:
                                l10n.tracker, // using existing label key or new one
                            hintText:
                                l10n.searchTracker, // We'll try to use the key if it exists
                            border: const OutlineInputBorder(),
                            suffixIcon:
                                _deviceLoading
                                    ? const Padding(
                                      padding: EdgeInsets.all(12.0),
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
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 200,
                                maxWidth: 300,
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final DeviceModel option = options.elementAt(
                                    index,
                                  );
                                  return Builder(
                                    builder: (BuildContext context) {
                                      final bool highlight =
                                          AutocompleteHighlightedOption.of(
                                            context,
                                          ) ==
                                          index;
                                      if (highlight) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback((
                                              Duration timeStamp,
                                            ) {
                                              Scrollable.ensureVisible(
                                                context,
                                                alignment: 0.5,
                                              );
                                            });
                                      }
                                      return Container(
                                        color:
                                            highlight ? Colors.grey[300] : null,
                                        child: ListTile(
                                          title: Text(option.name),
                                          subtitle: Text(option.deveui),
                                          onTap: () => onSelected(option),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      onSelected: (DeviceModel selection) {
                        setState(() {
                          _selectedDeviceId = selection.id;
                          _lastSelectedName = selection.name;
                          _trackerController.text = selection.name;
                          // Clear suggestions if needed or handle focus
                        });
                        // Close the options view typically handled by the widget
                      },
                    ),
                  ),

                  // Comments
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _commentsController,
                      decoration: InputDecoration(
                        labelText: l10n.comments,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ),

                  // Submit Button
                  FilledButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.receiveCattle),
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
                          _milkTeethCountController.text.trim(),
                        );
                        final pcParsed = int.tryParse(
                          _permanentTeethCountController.text.trim(),
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
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: 110,
                              child: TextFormField(
                                key: const ValueKey(
                                  'receive_quick_dentition_milk_count',
                                ),
                                controller: _milkTeethCountController,
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
                                key: ValueKey<String>(
                                  'milkWear_${mcParsed}_${pcParsed}_'
                                  '${_dentitionSapAllowedKey(milkAllowed)}_'
                                  '$_milkTeethWearValue',
                                ),
                                initialValue: _milkTeethWearValue,
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
                                  setState(() => _milkTeethWearValue = v);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: TextFormField(
                                key: const ValueKey(
                                  'receive_quick_dentition_perm_count',
                                ),
                                controller: _permanentTeethCountController,
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
                                  'permWear_${mcParsed}_${pcParsed}_'
                                  '${_dentitionSapAllowedKey(permAllowed)}_'
                                  '$_permanentTeethWearValue',
                                ),
                                initialValue: _permanentTeethWearValue,
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
                                  setState(() => _permanentTeethWearValue = v);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextFormField(
                                controller: _dentalEvaluationDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: l10n.dentalEvaluationDateShort,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: const Icon(Icons.calendar_today),
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
    );
  }

  Future<void> _checkNumberExists(String val) async {
    final l10n = AppLocalizations.of(context)!;
    if (val.isEmpty) {
      if (_numberExternalError != null) {
        setState(() => _numberExternalError = null);
      }
      return;
    }
    setState(() => _isValidatingNumber = true);
    try {
      final exists = await _apiService.checkCattleNumberExists(val);
      if (exists) {
        setState(() => _numberExternalError = l10n.cattle_exists_error);
      } else if (_numberExternalError != null) {
        setState(() => _numberExternalError = null);
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isValidatingNumber = false);
      }
    }
  }

  Future<void> _checkEartagExists(String val, {required bool isLeft}) async {
    final l10n = AppLocalizations.of(context)!;
    if (val.isEmpty) {
      if (isLeft && _eartagLeftExternalError != null) {
        setState(() => _eartagLeftExternalError = null);
      }
      if (!isLeft && _eartagRightExternalError != null) {
        setState(() => _eartagRightExternalError = null);
      }
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
      final exists = await _apiService.checkEartagExists(val);
      if (exists) {
        setState(() {
          if (isLeft) {
            _eartagLeftExternalError = l10n.eartag_exists_error;
          } else {
            _eartagRightExternalError = l10n.eartag_exists_error;
          }
        });
      } else {
        setState(() {
          if (isLeft && _eartagLeftExternalError != null) {
            _eartagLeftExternalError = null;
          }
          if (!isLeft && _eartagRightExternalError != null) {
            _eartagRightExternalError = null;
          }
        });
      }
    } catch (e) {
      widget.onError?.call(e.toString());
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
    final tempSelected = List<String>.from(selectedCharacteristicIds);

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
                      characteristics.map((char) {
                        final charId = char;
                        final isSelected = tempSelected.contains(charId);
                        final enumVal = CattleCharacteristic.fromString(charId);

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
                                    // Remove the first one (FIFO)
                                    tempSelected.remove(currentHalfHeads.first);
                                  }
                                }
                                tempSelected.add(charId);
                              } else {
                                tempSelected.remove(charId);
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
                      selectedCharacteristicIds = tempSelected;
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

  Future<void> _pickDentalEvaluationDate() async {
    final now = DateTime.now();
    final initial =
        DateTime.tryParse(_dentalEvaluationDateController.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (picked == null) return;
    final y = picked.year.toString().padLeft(4, '0');
    final m = picked.month.toString().padLeft(2, '0');
    final d = picked.day.toString().padLeft(2, '0');
    _dentalEvaluationDateController.text = '$y-$m-$d';
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    // Clear previous server errors
    if (!_formKey.currentState!.validate()) {
      debugPrint('DEBUG: Validation failed');
      return;
    }

    final dentParts = [
      _milkTeethCountController.text.trim(),
      _permanentTeethCountController.text.trim(),
      _milkTeethWearValue != null ? '$_milkTeethWearValue' : '',
      _permanentTeethWearValue != null ? '$_permanentTeethWearValue' : '',
      _dentalEvaluationDateController.text.trim(),
    ];
    if (dentitionHasPartialError(dentParts)) {
      widget.onError?.call(l10n.dentitionCompleteAllOrNone);
      return;
    }
    double? purchaseWeight = 0;
    double? purchasePrice = 0;
    if (selectedLotId != null) {
      for (var lot in widget.availableLots) {
        if (lot['id'] == selectedLotId) {
          try {
            var rawTotalWeight = lot['totalWeight'];
            var rawTotalCount = lot['purchasedCattleCount'];
            var rawPricePerKg = lot['pricePerKg'];
            num totalPurchaseWeight =
                rawTotalWeight is String
                    ? double.parse(rawTotalWeight)
                    : (rawTotalWeight as num? ?? 0);
            num totalPurchaseCount =
                rawTotalCount is String
                    ? double.parse(rawTotalCount)
                    : (rawTotalCount as num? ?? 0);
            num pricePerKg =
                rawPricePerKg is String
                    ? double.parse(rawPricePerKg)
                    : (rawPricePerKg as num? ?? 0);
            double averagePurchaseWeight = 0;
            if (totalPurchaseCount != 0) {
              averagePurchaseWeight =
                  (totalPurchaseWeight / totalPurchaseCount).toDouble();
            }
            // Round to 2 decimal places
            purchaseWeight = double.parse(
              averagePurchaseWeight.toStringAsFixed(2),
            );
            purchasePrice = double.parse(
              (averagePurchaseWeight * pricePerKg).toStringAsFixed(2),
            );
          } catch (e) {
            debugPrint('ERROR calculating purchase data: $e');
          }
        }
      }
    }

    int? milkC;
    int? permC;
    int? milkW;
    int? permW;
    if (dentitionIsCompleteFive(dentParts)) {
      milkC = int.tryParse(_milkTeethCountController.text.trim());
      permC = int.tryParse(_permanentTeethCountController.text.trim());
      milkW = _milkTeethWearValue;
      permW = _permanentTeethWearValue;
      if (milkC == null ||
          permC == null ||
          milkW == null ||
          permW == null) {
        widget.onError?.call(l10n.invalidValue);
        return;
      }
      final wearIssue = dentitionWearVsCountIssue(
        milkTeethCount: milkC,
        permanentTeethCount: permC,
        milkTeethWear: milkW,
        permanentTeethWear: permW,
      );
      if (wearIssue != null) {
        widget.onError?.call(
          wearIssue == DentitionWearVsCountIssue.milkWearNaWithTeeth
              ? l10n.dentitionWearCannotBeNaWhenMilkTeethPositive
              : l10n.dentitionWearCannotBeNaWhenPermanentTeethPositive,
        );
        return;
      }
      if (!dentitionWearGradesAllowedForSapCounts(
        milkTeethCount: milkC,
        permanentTeethCount: permC,
        milkTeethWear: milkW,
        permanentTeethWear: permW,
      )) {
        widget.onError?.call(l10n.dentitionWearGradeInvalidForTeethCounts);
        return;
      }
    }

    final cattleData = {
      'number': _numberController.text.trim(),
      'receivedWeight': double.tryParse(_weightController.text.trim()),
      'purchaseWeight': purchaseWeight,
      'purchasePrice': purchasePrice,
      'idLot': selectedLotId,
      'hasHorns': hasHorns,
      'isCastrated': isCastrated,
      if (dentitionIsCompleteFive(dentParts)) ...{
        'milkTeethCount': milkC,
        'permanentTeethCount': permC,
        'milkTeethWear': milkW,
        'permanentTeethWear': permW,
        'dentalEvaluationDate': _dentalEvaluationDateController.text.trim(),
      } else ...{
        'birthDateAprx':
            _birthDateAprxController.text.trim().isEmpty
                ? null
                : _birthDateAprxController.text.trim(),
      },
      'gender': _selectedGender.name,
      'color': selectedColorId,
      'characteristics': selectedCharacteristicIds,
      'eartagLeft':
          _eartagLeftController.text.trim().isEmpty
              ? null
              : _eartagLeftController.text.trim(),
      'eartagRight':
          _eartagRightController.text.trim().isEmpty
              ? null
              : _eartagRightController.text.trim(),
      'idDevice': _selectedDeviceId, // Use selected ID
      'deviceName': _trackerController.text, // Pass the name for consistency
      'comments':
          _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
      'idSimpleEvents': widget.activeEvents.map((e) => e.id).toList(),
    };
    try {
      await widget.onSubmit(cattleData);
      final usedDentition = dentitionIsCompleteFive(dentParts);
      final usedManualOnly =
          !usedDentition &&
          _birthDateAprxController.text.trim().isNotEmpty;
      await ReceptionBirthDateUsageMetrics.recordSubmission(
        usedDentition: usedDentition,
        usedManualOnly: usedManualOnly,
      );
      await _refreshQuickDentitionVisibility();
    } on ApiException catch (e) {
      if (e.code == 'conflictError' && e.message.contains('Eartag')) {
        widget.onError?.call(e.message);
      } else {
        widget.onError?.call(e.message);
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    }
    //_resetForm();
  }

}

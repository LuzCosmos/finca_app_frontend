import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';

class ReceiveCattleForm extends StatefulWidget {
  final String? currentNumber;
  final List<Map<String, dynamic>> availableLots;
  final List<Map<String, dynamic>> colors;
  final List<Map<String, dynamic>> characteristics;
  final List<SimpleEventModel> activeEvents;
  final Function(Map<String, dynamic> cattleData) onSubmit;
  final Function(String number) onNumberChanged;

  const ReceiveCattleForm({
    super.key,
    this.currentNumber,
    required this.availableLots,
    required this.colors,
    required this.characteristics,
    required this.activeEvents,
    required this.onSubmit,
    required this.onNumberChanged,
  });

  @override
  State<ReceiveCattleForm> createState() => _ReceiveCattleFormState();
}

class _ReceiveCattleFormState extends State<ReceiveCattleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberController;
  final _weightController = TextEditingController();
  final _commentsController = TextEditingController();
  final _eartagController = TextEditingController();
  final _trackerController = TextEditingController();
  
  Timer? _debounce;
  List<DeviceModel> _deviceOptions = [];
  bool _deviceLoading = false;
  Completer<List<DeviceModel>>? _lastCompleter; // Track last completer to prevent hangs
  final ReceptionApiService _apiService = ReceptionApiService(defaultHeaders: {});
  String? _selectedDeviceId; // Store the selected device ID
  String? _lastSelectedName; // To track if text matches selection

  String? selectedLotId;
  String? selectedColorId;
  List<String> selectedCharacteristicIds = [];
  bool hasHorns = false;
  bool isCastrated = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.currentNumber);
    _trackerController.addListener(() {
      if (_selectedDeviceId != null && _trackerController.text != _lastSelectedName) {
        setState(() {
          _selectedDeviceId = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ReceiveCattleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentNumber != oldWidget.currentNumber) {
      _numberController.text = widget.currentNumber ?? '';
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _weightController.dispose();
    _commentsController.dispose();
    _eartagController.dispose();
    _trackerController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _resetForm() {
    _weightController.clear();
    _commentsController.clear();
    _eartagController.clear();
    _trackerController.clear();
    setState(() {
      selectedLotId = null;
      selectedColorId = null;
      selectedCharacteristicIds = [];
      hasHorns = false;
      isCastrated = false;
      _selectedDeviceId = null; // Clear selected device
    });
  }

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

              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Cattle Number
                  SizedBox(
                    width: 125,
                    child: TextFormField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: l10n.cattleNumber,
                        border: const OutlineInputBorder(),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? l10n.fieldRequired
                                  : null,
                      onChanged: (value) {
                        widget.onNumberChanged(value);
                      },
                    ),
                  ),

                  // Lot Selection
                  SizedBox(
                    width: 145,
                    child: DropdownButtonFormField<String>(
                      value: selectedLotId,
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

                  // Color Dropdown
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      value: selectedColorId,
                      decoration: InputDecoration(
                        labelText: l10n.color,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: const Text('—'),
                        ),
                        ...widget.colors.map(
                          (color) => DropdownMenuItem<String>(
                            value: color['id'] as String,
                            child: Text(color['name']),
                          ),
                        ),
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

                  // Eartag
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _eartagController,
                      decoration: InputDecoration(
                        labelText: l10n.eartag,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                  // Tracker Autocomplete
                  SizedBox(
                    width: 200,
                    child: RawAutocomplete<DeviceModel>(

                      textEditingController: _trackerController,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Cancel previous completer if it exists and hasn't completed
                        if (_lastCompleter != null && !_lastCompleter!.isCompleted) {
                          _lastCompleter!.complete(const Iterable<DeviceModel>.empty().toList());
                        }

                        final Completer<List<DeviceModel>> completer = Completer();
                        _lastCompleter = completer;

                        if (textEditingValue.text.length < 3) {
                          if (_deviceOptions.isNotEmpty) {
                            setState(() => _deviceOptions = []);
                          }
                          completer.complete(const Iterable<DeviceModel>.empty().toList());
                          return completer.future;
                        }
                        
                        // Debounce search
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        
                         _debounce = Timer(const Duration(milliseconds: 500), () async {
                           if (!mounted) return;
                           setState(() => _deviceLoading = true);
                           try {
                             final results = await DeviceApiService.searchDevices(textEditingValue.text);
                             setState(() => _deviceOptions = results);
                             if (!completer.isCompleted) completer.complete(results);
                           } catch (e) {
                             print('DEBUG: API error: $e');
                             setState(() => _deviceOptions = []);
                             if (!completer.isCompleted) completer.complete(const Iterable<DeviceModel>.empty().toList());
                           } finally {
                             if (mounted) setState(() => _deviceLoading = false);
                           }
                        });
                        
                        return completer.future;
                      },
                      displayStringForOption: (DeviceModel option) => option.name,
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                             if (value != null && value.isNotEmpty && _selectedDeviceId == null) {
                               if (_deviceOptions.isEmpty) return l10n.trackerNotFound;
                               return l10n.trackerNotSelected;
                             }
                             return null;
                          },
                          decoration: InputDecoration(
                            labelText: l10n.trackerLabel, // using existing label key or new one
                            hintText: l10n.searchTracker, // We'll try to use the key if it exists
                            border: const OutlineInputBorder(),
                            suffixIcon: _deviceLoading 
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
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
                              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final DeviceModel option = options.elementAt(index);
                                  return Builder(
                                    builder: (BuildContext context) {
                                      final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                                      if (highlight) {
                                        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                                          Scrollable.ensureVisible(context, alignment: 0.5);
                                        });
                                      }
                                      return Container(
                                        color: highlight ? Colors.grey[300] : null,
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
            ],
          ),
        ),
      ),
    );
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
                      widget.characteristics.map((char) {
                        final charId = char['id'] as String;
                        final isSelected = tempSelected.contains(charId);

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                tempSelected.add(charId);
                              } else {
                                tempSelected.remove(charId);
                              }
                            });
                          },
                          title: Text(char['name']),
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

  void _submitForm() {
    print('DEBUG: Submit button clicked. Checking validation...');
    if (!_formKey.currentState!.validate()) {
      print('DEBUG: Validation failed');
      return;
    }
    print('DEBUG: Validation passed');
    double? purchaseWeight = 0;
    double? purchasePrice = 0;
    print('DEBUG: selectedLotId: $selectedLotId');
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

            print(
              'DEBUG: totalPurchaseWeight: $totalPurchaseWeight, totalPurchaseCount: $totalPurchaseCount, pricePerKg: $pricePerKg',
            );

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

            print(
              'DEBUG: Calculated purchaseWeight: $purchaseWeight, purchasePrice: $purchasePrice',
            );
          } catch (e) {
            print('ERROR calculating purchase data: $e');
          }
        }
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
      'idColor': selectedColorId,
      'characteristicsIds': selectedCharacteristicIds,
      'eartag':
          _eartagController.text.trim().isEmpty
              ? null
              : _eartagController.text.trim(),
      'eartag':
          _eartagController.text.trim().isEmpty
              ? null
              : _eartagController.text.trim(),
      'idDevice': _selectedDeviceId, // Use selected ID
      'deviceName': _trackerController.text, // Pass the name for consistency
      'comments':
          _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
      'idSimpleEvents': widget.activeEvents.map((e) => e.id).toList(),
    };

    widget.onSubmit(cattleData);
    //_resetForm();
  }
}

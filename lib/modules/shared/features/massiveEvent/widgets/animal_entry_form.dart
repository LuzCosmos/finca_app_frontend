import 'dart:convert';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/utils/regex_patterns.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/validator/validator.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/services/cattle_master_service.dart';

class AnimalEntryForm extends StatefulWidget {
  final String? idMassiveEvent;
  final List<SimpleEventModel> activeEvents;
  final Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap;
  final Function(Map<String, AnimalSimpleEventTableRowModel>) onApply;
  final Function(String?) showError;
  final Function(String?) showSuccess;
  final Function(String?) showInfo;
  /// Móvil: si se subió un masivo pendiente antes de aplicar al ganado, actualiza id y simples.
  final void Function(String newMassiveId, List<SimpleEventModel> remappedSimples)?
  onMassiveBranchSyncedFromServer;

  const AnimalEntryForm({
    super.key,
    required this.idMassiveEvent,
    required this.activeEvents,
    required this.animalEventsAppliedMap,
    required this.onApply,
    required this.showError,
    required this.showSuccess,
    required this.showInfo,
    this.onMassiveBranchSyncedFromServer,
  });

  @override
  State<AnimalEntryForm> createState() => _AnimalEntryFormState();
}

class _AnimalEntryFormState extends State<AnimalEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _animalNumberController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _trackerController = TextEditingController();
  final FocusNode _animalNumberFocusNode = FocusNode();
  final FocusNode _trackerFocusNode = FocusNode();
  final TextEditingController _eartagLeftController = TextEditingController();
  final TextEditingController _eartagRightController = TextEditingController();

  late Set<SimpleEventType> _activeTypes;

  // Autocomplete state
  Timer? _debounce;
  Timer? _animalDebounce;
  final _cattleService = CattleMasterService();
  List<Map<String, dynamic>> _animalOptions = [];
  bool _animalLoading = false;
  List<DeviceModel> _deviceOptions = [];
  bool _deviceLoading = false;
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _activeTypes = widget.activeEvents.map((e) => e.type).toSet();
  }

  @override
  void didUpdateWidget(covariant AnimalEntryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeEvents != widget.activeEvents) {
      setState(() {
        _activeTypes = widget.activeEvents.map((e) => e.type).toSet();
      });
    }
  }

  @override
  void dispose() {
    _animalDebounce?.cancel();
    _debounce?.cancel();
    _animalNumberController.dispose();
    _weightController.dispose();
    _trackerController.dispose();
    _animalNumberFocusNode.dispose();
    _trackerFocusNode.dispose();
    _eartagLeftController.dispose();
    _eartagRightController.dispose();
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
    _activeTypes.clear();
    super.dispose();
  }

  void _applyAnimalSimpleEvent() async {
    widget.showError(null);
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (widget.idMassiveEvent == null) {
        return;
      }
      if (widget.activeEvents.isEmpty) {
        widget.showError(l10n.applyAtLeastOneSimpleEvent);
        return;
      }
      if (!_formKey.currentState!.validate()) return;
      final animalNumber = _animalNumberController.text.trim();
      var toApplyRow = AnimalSimpleEventTableRowModel(
        animalNumber: animalNumber,
        castrated: false,
        weight: null,
        tracker: null,
        earTagLeft: null,
        earTagRight: null,
        idSimpleEventsApplied: <String>[],
        brandNames: <String>[],
        medicalTreatments: <String>[],
      );
      if (widget.animalEventsAppliedMap.containsKey(animalNumber)) {
        toApplyRow = widget.animalEventsAppliedMap[animalNumber]!;
      }
      final appliedEvents = <AnimalSimpleEventModel>[];
      for (var event in widget.activeEvents) {
        var data = event.data != null ? jsonDecode(event.data!) : null;
        switch (event.type) {
          case SimpleEventType.weight:
            if (_weightController.text.trim().isEmpty) {
              if (toApplyRow.weight == null) {
                return;
              }
              continue;
            }
            toApplyRow.weight = double.parse(_weightController.text.trim());
            data = {'weight': _weightController.text};
            break;
          case SimpleEventType.tracker:
            if (_trackerController.text.trim().isNotEmpty) {
              final tracker = _trackerController.text.trim();
              if (toApplyRow.tracker == tracker) {
                continue;
              }
              toApplyRow.tracker = tracker;
              // Prefer ID if selected, otherwise fallback to text (likely deveui or name, backend needs to handle)
              if (_selectedDeviceId != null) {
                data = {
                  'tracker_id': _selectedDeviceId,
                  'tracker_deveui': tracker,
                };
              } else {
                data = {'tracker_deveui': tracker};
              }
            } else {
              continue;
            }
            break;
          case SimpleEventType.eartag:
            final eartagLeft = _eartagLeftController.text.trim();
            final eartagRight = _eartagRightController.text.trim();
            if (eartagLeft.isNotEmpty || eartagRight.isNotEmpty) {
              if (toApplyRow.earTagLeft == eartagLeft &&
                  toApplyRow.earTagRight == eartagRight) {
                continue;
              }
              toApplyRow.earTagLeft = eartagLeft.isEmpty ? toApplyRow.earTagLeft : eartagLeft;
              toApplyRow.earTagRight = eartagRight.isEmpty ? toApplyRow.earTagRight : eartagRight;
              data = {
                if (eartagLeft.isNotEmpty) 'eartagLeft': eartagLeft,
                if (eartagRight.isNotEmpty) 'eartagRight': eartagRight,
              };
            } else {
              continue;
            }
            break;
          case SimpleEventType.castration:
            if (toApplyRow.castrated) {
              continue;
            }
            toApplyRow.castrated = true;
            break;
          case SimpleEventType.brand:
            if (data != null && data['idBrand'] != null) {
              final idBrand = data['idBrand'];
              if (toApplyRow.idBrandsApplied.contains(idBrand)) {
                continue;
              }
              final brandName = data['brandName'];
              if (brandName != null) {
                toApplyRow.brandNames.add(brandName);
              }
              toApplyRow.idBrandsApplied.add(idBrand);
            }
            break;
          case SimpleEventType.medication:
            if (toApplyRow.idSimpleEventsApplied.contains(event.id)) {
              continue;
            }
            if (data != null && data['medicationName'] != null) {
              final medicationName = data['medicationName'];
              if (toApplyRow.medicalTreatments.contains(medicationName)) {
                continue;
              }
              toApplyRow.medicalTreatments.add(medicationName);
            }
            break;
        }
        toApplyRow.idSimpleEventsApplied.add(event.id);
        final animalSimpleEventModel = AnimalSimpleEventModel(
          animalNumber: animalNumber,
          type: event.type,
          data: data != null ? jsonEncode(data) : null,
          appliedAt: DateTime.now(),
          idMassiveEvent: widget.idMassiveEvent!,
          idSimpleEvent: event.id,
        );
        appliedEvents.add(animalSimpleEventModel);
      }
      if (appliedEvents.isNotEmpty) {
        try {
          final dataSource = context.read<MassiveEventBloc>().dataSource;
          final outcome = await dataSource.saveAnimalSimpleEvents(
            animalSimpleEvents: appliedEvents,
            cattleNumber: animalNumber,
          );
          if (outcome.newMassiveEventId != null &&
              outcome.remappedSimpleEvents != null &&
              widget.onMassiveBranchSyncedFromServer != null) {
            widget.onMassiveBranchSyncedFromServer!(
              outcome.newMassiveEventId!,
              outcome.remappedSimpleEvents!,
            );
          }
          toApplyRow.updateWith(
            outcome.animalSimpleEvents,
            outcome.syncedWithServer,
          );
          _animalNumberController.clear();
          _weightController.clear();
          _trackerController.clear();
          _eartagLeftController.clear();
          _eartagRightController.clear();
          final newMap = widget.animalEventsAppliedMap;
          newMap[animalNumber] = toApplyRow;
          widget.onApply(newMap);
          widget.showSuccess(l10n.simpleEventApplied(animalNumber));
        } on ApiException catch (e) {
          if (mounted) {
            String? error = ApiExceptionCode.fromString(e.code).asText(context, objectName: animalNumber);
            if (e.code == ApiExceptionCode.notFound.name) {
              if (e.message.contains('Device')) {
                error = l10n.error_notFound(
                  'Traker ${toApplyRow.tracker ?? ''}',
                );
              }
              if (e.message.contains('Eartag')) {
                error = l10n.error_notFound(
                  'Eartag ${toApplyRow.earTagLeft ?? toApplyRow.earTagRight ?? ''}',
                );
              }
            }
            if (e.code == ApiExceptionCode.conflictError.name) {
              if (e.message.contains('Eartag')) {
                error = e.message;
              } else {
                error = l10n.error_conflict;
              }
            }
            if (error.isNotEmpty) {
              widget.showError(error);
            }
          }
        } catch (e) {
          widget.showError(l10n.error_generic);
        }
      } else {
        if (mounted) {
          widget.showInfo(l10n.eventsApplicationNotice);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.cattle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        (widget.idMassiveEvent == null ||
                                widget.activeEvents.isEmpty)
                            ? null
                            : _applyAnimalSimpleEvent,
                    icon: const Icon(Icons.save),
                    label: Text(l10n.apply),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (layoutContext, constraints) {
                        final layoutL10n = AppLocalizations.of(layoutContext)!;
                        return RawAutocomplete<Map<String, dynamic>>(
                          textEditingController: _animalNumberController,
                          focusNode: _animalNumberFocusNode,
                          optionsBuilder: (
                            TextEditingValue textEditingValue,
                          ) async {
                            final query = textEditingValue.text.trim();
                            final completer =
                                Completer<List<Map<String, dynamic>>>();

                            if (query.isEmpty) {
                              if (_animalOptions.isNotEmpty) {
                                setState(() => _animalOptions = []);
                              }
                              completer.complete(
                                const Iterable<Map<String, dynamic>>.empty()
                                    .toList(),
                              );
                              return completer.future;
                            }

                            if (_animalDebounce?.isActive ?? false) {
                              _animalDebounce!.cancel();
                            }

                            _animalDebounce = Timer(
                              const Duration(milliseconds: 350),
                              () async {
                                if (!mounted) return;
                                setState(() => _animalLoading = true);
                                try {
                                  final results = await _cattleService
                                      .searchCattle(query);
                                  if (!mounted) return;
                                  setState(() => _animalOptions = results);
                                  if (!completer.isCompleted) {
                                    completer.complete(results);
                                  }
                                } catch (_) {
                                  if (!mounted) return;
                                  setState(() => _animalOptions = []);
                                  if (!completer.isCompleted) {
                                    completer.complete(
                                      const Iterable<
                                            Map<String, dynamic>
                                          >.empty()
                                          .toList(),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _animalLoading = false);
                                  }
                                }
                              },
                            );

                            return completer.future;
                          },
                          displayStringForOption:
                              (option) => option['number'] ?? '',
                          onSelected: (selection) {
                            _animalNumberController.text =
                                selection['number']?.toString() ?? '';
                          },
                          fieldViewBuilder: (
                            context,
                            controller,
                            focusNode,
                            onFieldSubmitted,
                          ) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              style: const TextStyle(fontSize: 13),
                              keyboardType: TextInputType.number,
                              validator: Validator.validateNotEmpty(
                                layoutL10n.fieldRequired,
                                RegexPatterns.positiveIntegerNoZero,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onFieldSubmitted: (_) => onFieldSubmitted(),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                labelText: layoutL10n.animalNumber,
                                labelStyle: const TextStyle(fontSize: 11),
                                floatingLabelStyle: const TextStyle(
                                  fontSize: 11,
                                ),
                                suffixIcon:
                                    _animalLoading
                                        ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 12,
                                            height: 12,
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
                                  constraints: BoxConstraints(
                                    maxHeight: 220,
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (itemContext, index) {
                                      final option = options.elementAt(index);
                                      final device = option['device'];
                                      final deviceText =
                                          device != null
                                              ? (device['name'] ??
                                                  device['deveui'] ??
                                                  '')
                                              : '';
                                      final colorValue = option['color'];
                                      final colorText = colorValue != null
                                          ? CattleColor.fromString(colorValue.toString())
                                              .localizedName(itemContext)
                                          : '';
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          '${option['number']?.toString() ?? ''}${_formatEartags(option).isNotEmpty ? ' / ${_formatEartags(option)}' : ''}${deviceText.isNotEmpty ? ' / $deviceText' : ''}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        subtitle: colorText.isNotEmpty
                                            ? Text(
                                                '${layoutL10n.color}: $colorText / ${layoutL10n.castrated}: ${option['castrated'] == true ? layoutL10n.yes : layoutL10n.no} / ${layoutL10n.hasHorns}: ${option['hasHorn'] == true ? layoutL10n.yes : layoutL10n.no}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              )
                                            : null,
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_activeTypes.contains(SimpleEventType.weight))
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        style: const TextStyle(fontSize: 13),
                        validator: (value) {
                          if (widget.animalEventsAppliedMap.containsKey(
                            _animalNumberController.text,
                          )) {
                            var animalSimpleEventTableRowModel =
                                widget
                                    .animalEventsAppliedMap[_animalNumberController
                                    .text];
                            if (animalSimpleEventTableRowModel != null &&
                                animalSimpleEventTableRowModel.weight != null) {
                              return null;
                            }
                          }
                          if (value == null || value.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          if (!RegexPatterns.alphanumericHyphen.hasMatch(value)) {
                            return l10n.invalidValue;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegexPatterns.permissiveAlphanumericHyphen,
                          ),
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ), // Controla la altura
                          labelText: l10n.weightKg,
                          labelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota abajo
                          floatingLabelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota arriba
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  if (_activeTypes.contains(SimpleEventType.tracker))
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return RawAutocomplete<DeviceModel>(
                            optionsBuilder: (
                              TextEditingValue textEditingValue,
                            ) async {
                              final completer = Completer<List<DeviceModel>>();

                              if (textEditingValue.text == '') {
                                if (_deviceOptions.isNotEmpty) {
                                  setState(() => _deviceOptions = []);
                                }
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
                                    setState(() => _deviceOptions = results);
                                    if (!completer.isCompleted) {
                                      completer.complete(results);
                                    }
                                  } catch (e) {
                                    setState(() => _deviceOptions = []);
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
                            displayStringForOption:
                                (DeviceModel option) => option.name,
                            fieldViewBuilder: (
                              context,
                              controller,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              // Sync local controller if needed, but we used _trackerController.
                              // RawAutocomplete expects its own controller loop.
                              // We can pass _trackerController to it if we manage it carefully.
                              // But RawAutocomplete widget takes `textEditingController`.
                              // We didn't pass it in `optionsBuilder` above? No.
                              // We should pass `textEditingController: _trackerController` to RawAutocomplete.
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                style: const TextStyle(fontSize: 13),
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      _selectedDeviceId == null) {
                                    // We can check if options are empty to give a more specific error,
                                    // but _deviceOptions logic here might be tricky if debounce is running.
                                    // Using the same logic as ReceiveCattleForm usually works well enough.
                                    // Assuming l10n.trackerNotFound and l10n.trackerNotSelected exist.
                                    if (_deviceOptions.isEmpty) {
                                      return l10n.trackerNotFound;
                                    }
                                    return l10n.trackerNotSelected;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  labelText: l10n.tracker,
                                  labelStyle: const TextStyle(fontSize: 11),
                                  floatingLabelStyle: const TextStyle(
                                    fontSize: 11,
                                  ),
                                  suffixIcon:
                                      _deviceLoading
                                          ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 12,
                                              height: 12,
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
                                    constraints: BoxConstraints(
                                      maxHeight: 200,
                                      maxWidth: constraints.maxWidth,
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        final DeviceModel option = options
                                            .elementAt(index);
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
                                                  highlight
                                                      ? Colors.grey[300]
                                                      : null,
                                              child: ListTile(
                                                dense: true,
                                                title: Text(
                                                  option.name,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  option.deveui,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
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
                                _trackerController.text = selection.name;
                              });
                            },
                            textEditingController: _trackerController,
                            focusNode: _trackerFocusNode,
                          );
                        },
                      ),
                    ),
                  if (_activeTypes.contains(SimpleEventType.tracker) &&
                      _activeTypes.contains(SimpleEventType.eartag))
                    const SizedBox(width: 12),
                  if (_activeTypes.contains(SimpleEventType.eartag)) ... [
                    Expanded(
                      child: TextFormField(
                        controller: _eartagRightController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          labelText: l10n.eartagRight,
                          labelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota abajo
                          floatingLabelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota arriba
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _eartagLeftController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ), // Controla la altura
                          labelText: l10n.eartagLeft,
                          labelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota abajo
                          floatingLabelStyle: const TextStyle(
                            fontSize: 11,
                          ), // Label cuando flota arriba
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEartags(Map<String, dynamic> option) {
    final left = (option['eartagLeft'] ?? '').toString().trim();
    final right = (option['eartagRight'] ?? '').toString().trim();
    if (left.isEmpty && right.isEmpty) return '';
    if (left.isEmpty) return right;
    if (right.isEmpty) return left;
    return '$left / $right';
  }
}

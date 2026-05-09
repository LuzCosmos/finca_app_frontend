import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'dart:async';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/tracker_edit_dialog.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/tracker_remote_config_icon_button.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/characteristics_edit_dialog.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/cattle_history_dialogs.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/sale_sync_notifier.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';

class CattleMasterListPage extends StatefulWidget {
  const CattleMasterListPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<CattleMasterListPage> createState() => _CattleMasterListPageState();
}

class _CattleMasterListPageState extends State<CattleMasterListPage> {
  late final PlutoGridStateManager stateManager;
  final CattleMasterService _service = CattleMasterService();

  List<PlutoRow> rows = [];
  final List<String> _colors = CattleColor.values.map((e) => e.name).toList();
  final List<String> _characteristics =
      CattleCharacteristic.values.map((e) => e.name).toList();
  bool isLoading = true;
  bool _hasEditPermission = false;
  bool _hasRemoteConfigReadPermission = false;
  bool _isSaving = false;
  String? _globalErrorMessage;
  String? _globalSuccessMessage;

  // Pagination state
  int _page = 1;
  int _limit = 500;
  int _total = 0;
  final List<int> _allowedPageSizes = [10, 20, 50, 100, 500];

  // Need to rebuild columns when locale changes
  Key _gridKey = const ValueKey('cattle-grid');
  List<PlutoColumn> _cachedColumns = [];
  String _cachedLocaleKey = '';
  bool _cachedEditPermission = false;
  bool _cachedRemoteConfigPermission = false;

  void _showSuccess(String message) {
    if (mounted) {
      setState(() {
        _globalSuccessMessage = message;
        _globalErrorMessage = null;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _globalSuccessMessage = null;
          });
        }
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _globalErrorMessage = message;
        _globalSuccessMessage = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadData();
  }

  Future<void> _checkPermissions() async {
    final canEdit = await SessionService.hasActionPermission(
      'FARM',
      'cattle',
      'update',
    );
    final canReadRemoteConfig = await SessionService.hasActionPermission(
      'PROD_CENTER',
      'remote_config',
      'read',
    );
    if (mounted) {
      setState(() {
        _hasEditPermission = canEdit;
        _hasRemoteConfigReadPermission = canReadRemoteConfig;
      });
    }
  }

  Future<void> _loadData() async {
    if (_gridKey.toString().isEmpty || rows.isEmpty) {
      setState(() => isLoading = true);
    } else {
      try {
        stateManager.setShowLoading(true);
      } catch (e) {
        setState(() => isLoading = true);
      }
    }

    try {
      final cattleResult = await _service.getCattleList(
        page: _page,
        limit: _limit,
      );
      _total = cattleResult.total;
      final cattleList = cattleResult.items;
      final newRows = _createRows(cattleList);
      if (mounted) {
        if (isLoading) {
          setState(() {
            isLoading = false;
            rows = newRows;
          });
        } else {
          stateManager.setShowLoading(false);
          stateManager.removeAllRows();
          stateManager.appendRows(newRows);
          stateManager.notifyListeners();
          setState(() {
            rows = newRows;
          });
        }
      }
    } on ApiException catch (e) {
      final code = ApiExceptionCode.fromString(e.code);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final errorText = code.asText(context, objectName: l10n.cattle);
        _showError(errorText);
      }
      if (code == ApiExceptionCode.unknownError && e.code != 'unknownError') {
        debugPrint('ApiException code desconocido: ${e.code}');
      }
      if (mounted && isLoading) setState(() => isLoading = false);
    } catch (e) {
      debugPrint('Error loading cattle data: $e');
      if (mounted) {
        if (isLoading) setState(() => isLoading = false);
        try {
          stateManager.setShowLoading(false);
        } catch (_) {}
        final l10n = AppLocalizations.of(context)!;
        _showError(l10n.error_savingField('$e'));
      }
    }
  }

  void _onPageSizeChange(int? newLimit) {
    if (newLimit != null && newLimit != _limit) {
      setState(() {
        _limit = newLimit;
        _page = 1;
      });
      _loadData();
    }
  }

  void _onPageChange(int newPage) {
    if (newPage > 0 && newPage <= _pageCount) {
      setState(() {
        _page = newPage;
      });
      _loadData();
    }
  }

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  String _localizedCharacteristicLabel(String characteristicId) {
    return CattleCharacteristic.fromString(
          characteristicId,
        )?.localizedName(context) ??
        characteristicId;
  }

  List<String> _extractCharacteristicIds(Map<String, dynamic> cattle) {
    return (cattle['cattleCharacteristics'] as List?)
            ?.map((c) => c['characteristic'] as String)
            .toList() ??
        <String>[];
  }

  String _buildCharacteristicsLabel(List<String> characteristicIds) {
    return characteristicIds.map(_localizedCharacteristicLabel).join(', ');
  }

  /// Columna de fecha que usa el DatePicker de Flutter (calendario bien dimensionado)
  /// en lugar del calendario interno de PlutoGrid, que hereda la altura de fila y corta los números.
  PlutoColumn _buildDateColumn(String title, String field, double width) {
    return PlutoColumn(
      title: title,
      field: field,
      type: PlutoColumnType.text(),
      width: width,
      enableEditingMode: false,
      renderer: (rendererContext) {
        final cell = rendererContext.cell;
        final value = cell.value;
        final displayText = DateTimeHelper.formatLocalDate(value, fallback: '');
        return InkWell(
          onTap:
              !_hasEditPermission
                  ? null
                  : () async {
                    final rowKey = rendererContext.row.key;
                    DateTime? initial =
                        displayText.isEmpty
                            ? null
                            : DateTime.tryParse(displayText);
                    if (initial == null &&
                        value != null &&
                        value.toString().isNotEmpty) {
                      initial = DateTimeHelper.parseToLocal(value);
                    }
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      useRootNavigator: true,
                    );
                    if (picked == null || !mounted) return;
                    final formatted = DateTimeHelper.formatLocalDate(
                      picked,
                      fallback: '',
                    );
                    // Rebuscar la fila y celda actuales tras el async (la referencia puede quedar obsoleta)
                    final l10n = AppLocalizations.of(context)!;
                    PlutoRow? row;
                    try {
                      row = stateManager.rows.firstWhere(
                        (r) => r.key == rowKey,
                      );
                    } catch (_) {
                      if (mounted) _showError(l10n.cattleGrid_rowNotFound);
                      return;
                    }
                    final targetCell = row.cells[field];
                    if (targetCell != null) {
                      stateManager.changeCellValue(
                        targetCell,
                        formatted,
                        force: true,
                        callOnChangedEvent: false,
                      );
                    }
                    final rowId = row.cells['id']?.value.toString() ?? '';
                    if (rowId.isNotEmpty && rowId != 'New') {
                      try {
                        await _service.updateCattle(rowId, {field: formatted});
                        if (mounted) _showSuccess(l10n.cattleGrid_savedSuccess);
                      } catch (e) {
                        if (mounted) _showError(l10n.error_savingField('$e'));
                      }
                    }
                  },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                displayText,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        );
      },
    );
  }

  ({String field, dynamic value}) _normalizeChangedValue(
    PlutoGridOnChangedEvent event,
  ) {
    var field = event.column.field;
    dynamic value = event.value;

    if (field == 'hasHorn') {
      value = value.toString() == 'true';
    } else if (field == 'isCastrated') {
      field = 'castrated';
      value = value.toString() == 'true';
    } else if (field == 'characteristicsIds') {
      field = 'characteristics';
    }

    return (field: field, value: value);
  }

  bool _isIgnoredChangeField(String field) {
    return const [
      'tracker',
      'characteristics',
      'idDevice',
      'deveui',
    ].contains(field);
  }

  bool _isInvalidWeightValue(String field, dynamic value) {
    if (field != 'lastWeight' && field != 'receivedWeight') return false;
    final weight = double.tryParse(value.toString());
    return weight == null || weight <= 0;
  }

  bool _isInvalidSaleFieldValue(String field, dynamic value) {
    if (field != 'salePrice' && field != 'saleWeight') return false;
    final n = double.tryParse(value.toString());
    return n == null || n < 0;
  }

  void _revertCellValue(PlutoGridOnChangedEvent event) {
    stateManager.changeCellValue(
      event.row.cells[event.column.field]!,
      event.oldValue,
      callOnChangedEvent: false,
      force: true,
    );
  }

  void _applyRowServerUpdates(
    PlutoGridOnChangedEvent event,
    Map<String, dynamic> updatedData,
  ) {
    final row = stateManager.rows.firstWhere((r) => r.key == event.row.key);
    var changed = false;

    if (updatedData.containsKey('weightHistory')) {
      row.cells['weightHistory']!.value = updatedData['weightHistory'];
      changed = true;
    }
    if (updatedData.containsKey('medicationHistory')) {
      row.cells['medicationHistory']!.value = updatedData['medicationHistory'];
      changed = true;
    }
    // El backend puede recalcular averageDailyGain al actualizar lastWeight
    final averageDailyGain =
        updatedData['averageDailyGain'] ?? updatedData['average_daily_gain'];
    if (averageDailyGain != null && row.cells['averageDailyGain'] != null) {
      stateManager.changeCellValue(
        row.cells['averageDailyGain']!,
        averageDailyGain,
        force: true,
        callOnChangedEvent: false,
      );
      changed = true;
    }
    // Peso estimado se recalcula en backend al actualizar lastWeight
    if (updatedData.containsKey('estimatedWeight') ||
        updatedData.containsKey('estimated_weight')) {
      final estimatedWeight =
          updatedData['estimatedWeight'] ?? updatedData['estimated_weight'];
      if (row.cells['estimatedWeight'] != null) {
        stateManager.changeCellValue(
          row.cells['estimatedWeight']!,
          estimatedWeight,
          force: true,
          callOnChangedEvent: false,
        );
        changed = true;
      }
    }
    if (updatedData.containsKey('salePrice') &&
        row.cells['salePrice'] != null) {
      stateManager.changeCellValue(
        row.cells['salePrice']!,
        updatedData['salePrice'],
        force: true,
        callOnChangedEvent: false,
      );
      changed = true;
    }
    if (updatedData.containsKey('saleWeight') &&
        row.cells['saleWeight'] != null) {
      stateManager.changeCellValue(
        row.cells['saleWeight']!,
        updatedData['saleWeight'],
        force: true,
        callOnChangedEvent: false,
      );
      changed = true;
    }
    if (changed) {
      stateManager.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeKey = Localizations.localeOf(context).toLanguageTag();
    final shouldRebuildColumns =
        _cachedColumns.isEmpty ||
        _cachedLocaleKey != localeKey ||
        _cachedEditPermission != _hasEditPermission ||
        _cachedRemoteConfigPermission != _hasRemoteConfigReadPermission;

    if (shouldRebuildColumns) {
      _cachedLocaleKey = localeKey;
      _cachedEditPermission = _hasEditPermission;
      _cachedRemoteConfigPermission = _hasRemoteConfigReadPermission;
      _gridKey = ValueKey(
        'cattle-grid-$localeKey-$_hasEditPermission-$_hasRemoteConfigReadPermission',
      );

      _cachedColumns = [
        PlutoColumn(
          title: 'Id',
          field: 'id',
          type: PlutoColumnType.text(),
          hide: true,
          width: 0,
        ),
        PlutoColumn(
          title: 'deveui',
          field: 'deveui',
          type: PlutoColumnType.text(),
          hide: true,
          width: 0,
        ),
        PlutoColumn(
          title: l10n.number,
          field: 'number',
          type: PlutoColumnType.text(),
          width: 90,
          enableEditingMode: _hasEditPermission,
          frozen: PlutoColumnFrozen.start,
        ),
        PlutoColumn(
          title: l10n.status,
          field: 'status',
          type: PlutoColumnType.text(),
          enableEditingMode: _hasEditPermission,
          width: 80,
          frozen: PlutoColumnFrozen.start,
          renderer: (rendererContext) {
            String currentValue = rendererContext.cell.value.toString();
            final statusList = CattleStatusEnum.getStatusList();
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: statusList.contains(currentValue) ? currentValue : null,
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                isDense: true,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                items:
                    statusList.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(
                          CattleStatusEnum.fromString(s).localizedName(context),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                onChanged:
                    !_hasEditPermission
                        ? null
                        : (newValue) {
                          if (newValue != null) {
                            debugPrint('Status changed to $newValue');
                            rendererContext.stateManager.changeCellValue(
                              rendererContext.cell,
                              newValue,
                            );
                          }
                        },
              ),
            );
          },
        ),
        PlutoColumn(
          title: l10n.lastWeightKg,
          field: 'lastWeight',
          type: PlutoColumnType.number(format: '#,##0.00'),
          width: 100,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.estimatedWeightKg,
          field: 'estimatedWeight',
          type: PlutoColumnType.number(format: '#,##0.00'),
          width: 120,
          enableEditingMode: false,
        ),
        PlutoColumn(
          title: l10n.averageDailyGain,
          field: 'averageDailyGain',
          type: PlutoColumnType.number(
            format: '#,##0.000',
            applyFormatOnInit: true,
          ),
          width: 120,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.eartagRight,
          field: 'eartagRight',
          type: PlutoColumnType.text(),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.eartagLeft,
          field: 'eartagLeft',
          type: PlutoColumnType.text(),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.horns,
          field: 'hasHorn',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            bool value = rendererContext.cell.value.toString() == 'true';
            return Checkbox(
              value: value,
              onChanged:
                  !_hasEditPermission
                      ? null
                      : (newValue) {
                        stateManager.changeCellValue(
                          rendererContext.cell,
                          newValue.toString(),
                        );
                      },
            );
          },
          width: 80,
        ),
        PlutoColumn(
          title: l10n.castrated,
          field: 'isCastrated',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            bool value = rendererContext.cell.value.toString() == 'true';
            return Checkbox(
              value: value,
              onChanged:
                  !_hasEditPermission
                      ? null
                      : (newValue) {
                        stateManager.changeCellValue(
                          rendererContext.cell,
                          newValue.toString(),
                        );
                      },
            );
          },
          width: 90,
        ),
        // Dynamic Color Dropdown
        PlutoColumn(
          title: l10n.color,
          field: 'color',
          type: PlutoColumnType.text(),
          enableEditingMode: _hasEditPermission,
          width: 120,
          renderer: (rendererContext) {
            String currentValue = rendererContext.cell.value.toString();
            // Ensure current value is in the list, otherwise default to first or handle gracefully
            if (!_colors.contains(currentValue) && _colors.isNotEmpty) {
              // Optional: logic to handle unknown values
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _colors.contains(currentValue) ? currentValue : null,
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                isDense: true,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                items:
                    _colors.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(
                          CattleColor.fromString(c).localizedName(context),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                onChanged:
                    !_hasEditPermission
                        ? null
                        : (newValue) {
                          if (newValue != null) {
                            debugPrint('Color changed to $newValue');
                            rendererContext.stateManager.changeCellValue(
                              rendererContext.cell,
                              newValue,
                            );
                          }
                        },
              ),
            );
          },
        ),
        PlutoColumn(
          title: l10n.characteristics,
          field: 'characteristics',
          type: PlutoColumnType.text(),
          width: 150,
          enableEditingMode: false,
          renderer: (rendererContext) {
            return InkWell(
              onTap:
                  !_hasEditPermission
                      ? null
                      : () async {
                        final ids =
                            rendererContext
                                    .row
                                    .cells['characteristicsIds']
                                    ?.value
                                as List<String>;
                        // Capture key to ensure we find the correct row even if sorting/filtering changed usage
                        final rowKey = rendererContext.row.key;
                        final cattleNumber =
                            rendererContext.row.cells['number']?.value
                                .toString() ??
                            '';
                        final result = await showDialog(
                          context: context,
                          builder:
                              (ctx) => CharacteristicsEditDialog(
                                availableCharacteristics: _characteristics,
                                selectedIds: ids,
                                cattleNumber: cattleNumber,
                              ),
                        );
                        if (result != null && result is Map && mounted) {
                          final newIds = result['ids'] as List<String>;
                          final newNames = result['names'] as List<String>;
                          debugPrint('Dialog result received. IDs: $newIds');
                          // Find the row
                          PlutoRow activeRow;
                          try {
                            activeRow = stateManager.rows.firstWhere(
                              (r) => r.key == rowKey,
                            );
                          } catch (e) {
                            debugPrint(
                              'Could not find row with key $rowKey: $e',
                            );
                            return;
                          }
                          final rowId =
                              activeRow.cells['id']?.value.toString() ?? '';
                          if (rowId != 'New' && rowId.isNotEmpty) {
                            debugPrint("Saving to DB for row $rowId");
                            try {
                              // Manual API call to avoid triggering onChanged with List value
                              await _service.updateCattle(rowId, {
                                'characteristics': newIds,
                              });
                              if (mounted) {
                                // Update hidden value directly
                                activeRow.cells['characteristicsIds']!.value =
                                    newIds;
                                // Update visible text manually
                                activeRow
                                    .cells['characteristics']!
                                    .value = newNames.join(', ');
                                // Force grid refresh
                                stateManager
                                    .notifyListeners(); // Notify PlutoGrid to rebuild
                                setState(
                                  () {},
                                ); // Trigger local widget rebuild just in case
                                _showSuccess(l10n.cattleGrid_savedSuccess);
                              }
                            } catch (e) {
                              debugPrint("Error saving characteristics: $e");
                              if (mounted) {
                                _showError(l10n.error_savingField('$e'));
                              }
                            }
                          } else {
                            // For new rows not yet saved to DB, just update local state
                            activeRow.cells['characteristicsIds']!.value =
                                newIds;
                            stateManager.changeCellValue(
                              activeRow.cells['characteristics']!,
                              newNames.join(', '),
                            );
                          }
                        }
                      },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rendererContext.cell.value.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.edit, size: 14, color: Colors.grey),
                ],
              ),
            );
          },
        ),
        PlutoColumn(
          title: l10n.gender,
          field: 'gender',
          type: PlutoColumnType.text(),
          enableEditingMode: _hasEditPermission,
          width: 100,
          renderer: (rendererContext) {
            String currentValue = rendererContext.cell.value.toString();
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    CattleGender.values.any((e) => e.name == currentValue)
                        ? currentValue
                        : null,
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                isDense: true,
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                items:
                    CattleGender.values.map((e) {
                      return DropdownMenuItem(
                        value: e.name,
                        child: Text(
                          e.localizedName(context),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                onChanged:
                    !_hasEditPermission
                        ? null
                        : (newValue) {
                          if (newValue != null) {
                            // debugPrint('Gender changed to $newValue');
                            rendererContext.stateManager.changeCellValue(
                              rendererContext.cell,
                              newValue,
                            );
                          }
                        },
              ),
            );
          },
        ),
        _buildDateColumn(l10n.approxBirthDate, 'birthDateAprx', 120),
        _buildDateColumn(l10n.newFeedStartDate, 'newFeedStartDate', 140),
        PlutoColumn(
          title: l10n.tracker,
          field: 'tracker',
          type: PlutoColumnType.text(),
          width: 170,
          enableEditingMode: false,
          renderer: (rendererContext) {
            final trackerName = rendererContext.cell.value.toString();
            final deveui =
                rendererContext.row.cells['deveui']?.value?.toString() ?? '';
            return InkWell(
              onTap:
                  !_hasEditPermission
                      ? null
                      : () async {
                        final rowKey = rendererContext.row.key;
                        final result = await showDialog(
                          context: context,
                          builder:
                              (ctx) => TrackerEditDialog(
                                initialValue:
                                    rendererContext.cell.value.toString(),
                                onSelected:
                                    (device) {}, // Handled by await result
                              ),
                        );
                        if (result != null && mounted) {
                          PlutoRow? activeRow;
                          try {
                            activeRow = stateManager.rows.firstWhere(
                              (r) => r.key == rowKey,
                            );
                          } catch (e) {
                            return;
                          }

                          final rowId =
                              activeRow.cells['id']?.value.toString() ?? '';

                          if (result == 'remove') {
                            // Logic to remove tracker
                            if (rowId != 'New' && rowId.isNotEmpty) {
                              try {
                                await _service.updateCattle(rowId, {
                                  'idDevice': null,
                                });
                                if (mounted) {
                                  activeRow.cells['tracker']!.value = '';
                                  activeRow.cells['idDevice']!.value = '';
                                  if (activeRow.cells.containsKey('deveui')) {
                                    activeRow.cells['deveui']!.value = '';
                                  }
                                  stateManager.notifyListeners();
                                  _showSuccess(l10n.cattleGrid_trackerRemoved);
                                }
                              } catch (e) {
                                if (mounted) {
                                  _showError(l10n.error_savingField('$e'));
                                }
                              }
                            } else {
                              // For new rows
                              activeRow.cells['tracker']!.value = '';
                              activeRow.cells['idDevice']!.value = '';
                              if (activeRow.cells.containsKey('deveui')) {
                                activeRow.cells['deveui']!.value = '';
                              }
                            }
                          } else if (result is DeviceModel) {
                            // Logic to add tracker (existing)
                            if (rowId != 'New' && rowId.isNotEmpty) {
                              try {
                                await _service.updateCattle(rowId, {
                                  'idDevice': result.id,
                                });
                                if (mounted) {
                                  // Find any other row that has this device attached and clear it
                                  try {
                                    final oldOwnerRow = stateManager.rows
                                        .firstWhere(
                                          (r) =>
                                              r.key != rowKey &&
                                              r.cells['idDevice']?.value ==
                                                  result.id,
                                        );
                                    oldOwnerRow.cells['tracker']!.value = '';
                                    oldOwnerRow.cells['idDevice']!.value = '';
                                    if (oldOwnerRow.cells.containsKey(
                                      'deveui',
                                    )) {
                                      oldOwnerRow.cells['deveui']!.value = '';
                                    }
                                  } catch (e) {
                                    // No previous owner found
                                  }
                                  activeRow.cells['tracker']!.value =
                                      result.name;
                                  activeRow.cells['idDevice']!.value =
                                      result.id;
                                  if (activeRow.cells.containsKey('deveui')) {
                                    activeRow.cells['deveui']!.value =
                                        result.deveui;
                                  }
                                  stateManager.notifyListeners();
                                  _showSuccess(l10n.cattleGrid_savedSuccess);
                                }
                              } catch (e) {
                                if (mounted) {
                                  _showError(l10n.error_savingField('$e'));
                                }
                              }
                            } else {
                              activeRow.cells['tracker']!.value = result.name;
                              stateManager.changeCellValue(
                                activeRow.cells['idDevice']!,
                                result.id,
                              );
                              if (activeRow.cells.containsKey('deveui')) {
                                activeRow.cells['deveui']!.value =
                                    result.deveui;
                              }
                            }
                          }
                        }
                      },
              child: Row(
                children: [
                  if (trackerName.isNotEmpty)
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.green,
                    ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(trackerName, overflow: TextOverflow.ellipsis),
                  ),
                  /*
                  //Edit Device by downlinks button
                  TrackerRemoteConfigIconButton(
                    deveui: deveui,
                    deviceDisplayName:
                        trackerName.isNotEmpty ? trackerName : null,
                    hasRemoteConfigAccess: _hasRemoteConfigReadPermission,
                  ),*/
                  const Icon(Icons.edit, size: 14, color: Colors.grey),
                ],
              ),
            );
          },
        ),
        PlutoColumn(
          title: l10n.comments,
          field: 'comments',
          type: PlutoColumnType.text(),
          width: 200,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.purchaseWeightKg,
          field: 'purchaseWeight',
          type: PlutoColumnType.number(format: '#,##0.00'),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.purchasePrice,
          field: 'purchasePrice',
          type: PlutoColumnType.number(),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.purchaseCommission,
          field: 'purchaseCommission',
          type: PlutoColumnType.number(),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        _buildDateColumn(l10n.receivedAt, 'receivedAt', 110),
        PlutoColumn(
          title: l10n.receivedWeightKg,
          field: 'receivedWeight',
          type: PlutoColumnType.number(format: '#,##0.00'),
          width: 100,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.saleWeightKg,
          field: 'saleWeight',
          type: PlutoColumnType.number(format: '#,##0.00'),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.salePrice,
          field: 'salePrice',
          type: PlutoColumnType.number(),
          width: 110,
          enableEditingMode: _hasEditPermission,
        ),
        PlutoColumn(
          title: l10n.weightHistory,
          field: 'weightHistory',
          type: PlutoColumnType.text(),
          enableEditingMode: false,
          width: 100,
          renderer: (ctx) {
            return InkWell(
              onTap: () {
                final raw = ctx.cell.value;
                List<dynamic> history = <dynamic>[];
                if (raw is List) {
                  try {
                    history = List<dynamic>.from(raw);
                  } catch (_) {}
                }
                final cattleNumber =
                    ctx.row.cells['number']?.value.toString() ?? '';
                final loc = AppLocalizations.of(context);
                showDialog(
                  context: context,
                  builder:
                      (_) => WeightHistoryDialog(
                        history: history,
                        cattleNumber: cattleNumber,
                        noDataMessage: loc?.noData ?? 'No data available',
                        closeLabel: loc?.close ?? 'Close',
                        weightHistoryLabel:
                            loc?.weightHistory ?? 'Weight Hist.',
                      ),
                );
              },
              child: const Icon(Icons.history, size: 18),
            );
          },
        ),
        PlutoColumn(
          title: l10n.medicationHistory,
          field: 'medicationHistory',
          type: PlutoColumnType.text(),
          enableEditingMode: false,
          width: 100,
          renderer: (ctx) {
            return InkWell(
              onTap: () async {
                final rowId = ctx.row.cells['id']!.value.toString();
                final cattleNumber =
                    ctx.row.cells['number']?.value.toString() ?? '';
                final history = (ctx.cell.value as List?) ?? [];
                final result = await showDialog<List<dynamic>>(
                  context: context,
                  builder:
                      (_) => MedicationHistoryDialog(
                        cattleId: rowId,
                        cattleNumber: cattleNumber,
                        history: history,
                        service: _service,
                        onAdded: (newRecord) {
                          /*debugPrint(
                          'Adding new medication record to grid: $newRecord',
                        );*/
                          try {
                            final row = stateManager.rows.firstWhere(
                              (r) => r.key == ctx.row.key,
                            );
                            // ignore: unnecessary_null_comparison
                            if (row != null) {
                              final cell = row.cells['medicationHistory']!;
                              final currentHistory = List<dynamic>.from(
                                cell.value as List? ?? [],
                              );
                              currentHistory.insert(0, newRecord);
                              stateManager.changeCellValue(
                                cell,
                                currentHistory,
                                callOnChangedEvent: false,
                                force: true,
                              );
                              /*debugPrint(
                              'Grid cell updated. New history length: ${currentHistory.length}',
                            );*/
                            } else {
                              debugPrint(
                                'Could not find row by key to update medication history',
                              );
                            }
                          } catch (e) {
                            debugPrint(
                              'Error updating grid medication history: $e',
                            );
                          }
                        },
                      ),
                );
                // We rely on onAdded to update the grid, treating result as redundant or fallback
                if (result != null) {
                  // stateManager.changeCellValue(ctx.cell, result, callOnChangedEvent: false);
                }
              },
              child: const Icon(Icons.medical_services, size: 18),
            );
          },
        ),

        PlutoColumn(
          title: 'IdDevice',
          field: 'idDevice',
          type: PlutoColumnType.text(),
          hide: true,
          width: 0,
        ),
        PlutoColumn(
          title: 'CharacteristicsIds',
          field: 'characteristicsIds',
          type: PlutoColumnType.text(),
          hide: true,
          width: 0,
        ),
      ];
    }

    final columns = _cachedColumns;

    return FincaScaffold(
      title: l10n.masterListTitle,
      embedded: widget.embedded,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_globalErrorMessage != null)
              MessageBanner.error(_globalErrorMessage!),
            if (_globalSuccessMessage != null)
              MessageBanner.success(_globalSuccessMessage!),
            /*Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _addCattleRow,
                icon: const Icon(Icons.add),
                label: Text(l10n.addSomething(l10n.cattle)),
              ),
            ),*/
            const SizedBox(height: 12),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PlutoGrid(
                        key: _gridKey,
                        configuration: const PlutoGridConfiguration(
                          columnSize: PlutoGridColumnSizeConfig(
                            autoSizeMode: PlutoAutoSizeMode.none,
                          ),
                          style: PlutoGridStyleConfig(
                            enableCellBorderVertical: true,
                            rowHeight: 20,
                          ),
                        ),
                        columns: columns,
                        rows: rows,
                        onLoaded: (event) {
                          stateManager = event.stateManager;
                          stateManager.setShowColumnFilter(true);
                        },
                        onChanged: (event) async {
                          final rowId = event.row.cells['id']!.value.toString();
                          if (rowId.isEmpty || rowId == 'New') {
                            return;
                          }
                          if (_isSaving) return;
                          final normalized = _normalizeChangedValue(event);
                          final field = normalized.field;
                          final value = normalized.value;

                          if (_isIgnoredChangeField(field)) {
                            return;
                          }

                          if (_isInvalidWeightValue(field, value)) {
                            if (mounted) {
                              _showError(l10n.error_enterValidWeight);
                              _revertCellValue(event);
                            }
                            return;
                          }

                          if (_isInvalidSaleFieldValue(field, value)) {
                            if (mounted) {
                              _showError(l10n.error_enterValidWeight);
                              _revertCellValue(event);
                            }
                            return;
                          }

                          setState(() => _isSaving = true);
                          try {
                            final updatedData = await _service.updateCattle(
                              rowId,
                              {field: value},
                            );
                            if (mounted) {
                              if (updatedData != null) {
                                _applyRowServerUpdates(event, updatedData);
                                final affectedSaleId =
                                    updatedData['affectedSaleId']?.toString();
                                if (affectedSaleId != null &&
                                    affectedSaleId.isNotEmpty) {
                                  SaleSyncNotifier.instance.notifySaleUpdated(
                                    affectedSaleId,
                                  );
                                }
                              }
                              _showSuccess(l10n.cattleGrid_savedSuccess);
                            }
                          } on ApiException catch (e) {
                            if (!context.mounted) return;
                            final apiCode = ApiExceptionCode.fromString(e.code);
                            if (apiCode == ApiExceptionCode.conflictError) {
                              if (field == 'number') {
                                _showError(l10n.cattle_exists_error);
                              } else if (field == 'eartagLeft' ||
                                  field == 'eartagRight') {
                                _showError(l10n.eartag_exists_error);
                              } else {
                                _showError(apiCode.asText(context));
                              }
                            } else {
                              _showError(apiCode.asText(context));
                            }
                            _revertCellValue(event);
                          } catch (e) {
                            debugPrint('Error saving field $field: $e');
                            if (mounted) {
                              _showError(l10n.error_savingField(l10n.cattle));
                              _revertCellValue(event);
                            }
                          } finally {
                            if (mounted) setState(() => _isSaving = false);
                          }
                        },
                      ),
            ),
            // Pagination Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(l10n.rowsPerPage),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _allowedPageSizes.contains(_limit) ? _limit : 10,
                        items:
                            _allowedPageSizes
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text('$s'),
                                  ),
                                )
                                .toList(),
                        onChanged: _onPageSizeChange,
                        underline: Container(),
                      ),
                    ],
                  ),
                  Text(
                    '${l10n.page} $_page / $_pageCount   ($_total ${l10n.results})',
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed:
                            _page > 1 ? () => _onPageChange(_page - 1) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed:
                            _page < _pageCount
                                ? () => _onPageChange(_page + 1)
                                : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCattleRow() {
    stateManager.insertRows(0, [
      PlutoRow(
        cells: {
          'number': PlutoCell(value: ''),
          'status': PlutoCell(value: CattleStatusEnum.ACTIVE.name),
          'lastWeight': PlutoCell(value: 0),
          'averageDailyGain': PlutoCell(value: 0),
          'eartagLeft': PlutoCell(value: ''),
          'eartagRight': PlutoCell(value: ''),
          'hasHorn': PlutoCell(value: 'false'),
          'isCastrated': PlutoCell(value: 'false'),
          'color': PlutoCell(value: _colors.isNotEmpty ? _colors[0] : ''),
          'characteristics': PlutoCell(value: ''),
          'gender': PlutoCell(value: 'MALE'),
          'birthDateAprx': PlutoCell(value: ''),
          'newFeedStartDate': PlutoCell(value: ''),
          'tracker': PlutoCell(value: ''),
          'idDevice': PlutoCell(value: ''),
          'deveui': PlutoCell(value: ''),
          'comments': PlutoCell(value: ''),
          'purchaseWeight': PlutoCell(value: 0),
          'purchasePrice': PlutoCell(value: 0),
          'purchaseCommission': PlutoCell(value: 0),
          'receivedAt': PlutoCell(
            value: DateTimeHelper.formatLocalDate(DateTime.now(), fallback: ''),
          ),
          'receivedWeight': PlutoCell(value: 0),
          'saleWeight': PlutoCell(value: 0),
          'salePrice': PlutoCell(value: 0),
          'weightHistory': PlutoCell(value: ''),
          'medicationHistory': PlutoCell(value: ''),
          'characteristicsIds': PlutoCell(value: <String>[]),
        },
      ),
    ]);
  }

  List<PlutoRow> _createRows(List<Map<String, dynamic>> cattleList) {
    return cattleList.map((cattle) {
      final characteristicIds = _extractCharacteristicIds(cattle);
      final characteristicsList = _buildCharacteristicsLabel(characteristicIds);

      return PlutoRow(
        cells: {
          'id': PlutoCell(value: cattle['id'] ?? ''),
          'number': PlutoCell(value: cattle['number'] ?? ''),
          'status': PlutoCell(value: cattle['status'] ?? 'ACTIVE'),
          'lastWeight': PlutoCell(value: cattle['lastWeight'] ?? 0),
          'estimatedWeight': PlutoCell(
            value: cattle['estimatedWeight'] ?? cattle['estimated_weight'],
          ),
          'averageDailyGain': PlutoCell(
            value:
                cattle['averageDailyGain'] ?? cattle['average_daily_gain'] ?? 0,
          ),
          'eartagLeft': PlutoCell(value: cattle['eartagLeft'] ?? ''),
          'eartagRight': PlutoCell(value: cattle['eartagRight'] ?? ''),
          'hasHorn': PlutoCell(value: (cattle['hasHorn'] ?? false).toString()),
          'isCastrated': PlutoCell(
            value: (cattle['castrated'] ?? false).toString(),
          ),
          'color': PlutoCell(value: cattle['color'] ?? ''),
          'characteristics': PlutoCell(value: characteristicsList),
          'characteristicsIds': PlutoCell(value: characteristicIds),
          'gender': PlutoCell(value: cattle['gender'] ?? 'MALE'),
          'birthDateAprx': PlutoCell(
            value: DateTimeHelper.formatLocalDate(
              cattle['birthDateAprx'] ?? cattle['birth_date_aprx'],
              fallback: '',
            ),
          ),
          'newFeedStartDate': PlutoCell(
            value: DateTimeHelper.formatLocalDate(
              cattle['newFeedStartDate'] ?? cattle['new_feed_start_date'],
              fallback: '',
            ),
          ),
          'tracker': PlutoCell(
            value:
                cattle['device'] != null
                    ? cattle['device']['name']
                    : ((cattle['deviceName'] as String?) ?? ''),
          ),
          'idDevice': PlutoCell(
            value:
                cattle['device'] != null
                    ? cattle['device']['id']
                    : ((cattle['idDevice'] as String?) ?? ''),
          ),
          'deveui': PlutoCell(
            value:
                cattle['device'] != null
                    ? (cattle['device']['deveui'] ?? '')
                    : '',
          ),
          'comments': PlutoCell(value: cattle['comments'] ?? ''),
          'purchaseWeight': PlutoCell(value: cattle['purchaseWeight'] ?? 0),
          'purchasePrice': PlutoCell(value: cattle['purchasePrice'] ?? 0),
          'purchaseCommission': PlutoCell(
            value: cattle['purchaseCommission'] ?? 0,
          ),
          'receivedAt': PlutoCell(
            value: DateTimeHelper.formatLocalDate(
              cattle['receivedAt'],
              fallback: '',
            ),
          ),
          'receivedWeight': PlutoCell(value: cattle['receivedWeight'] ?? 0),
          'saleWeight': PlutoCell(value: cattle['saleWeight'] ?? 0),
          'salePrice': PlutoCell(value: cattle['salePrice'] ?? 0),
          'weightHistory': PlutoCell(value: cattle['weightHistory'] ?? []),
          'medicationHistory': PlutoCell(
            value: cattle['medicationHistory'] ?? [],
          ),
        },
      );
    }).toList();
  }
}

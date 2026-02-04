import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'dart:async';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/tracker_edit_dialog.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/characteristics_edit_dialog.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/cattle_history_dialogs.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class CattleMasterListPage extends StatefulWidget {
  const CattleMasterListPage({super.key});

  @override
  State<CattleMasterListPage> createState() => _CattleMasterListPageState();
}

class _CattleMasterListPageState extends State<CattleMasterListPage> {
  late final PlutoGridStateManager stateManager;
  final CattleMasterService _service = CattleMasterService();
  
  List<PlutoRow> rows = [];
  List<String> _colors = [];
  List<String> _characteristics = [];
  bool isLoading = true;
  bool _hasEditPermission = false;
  String? _globalErrorMessage;
  String? _globalSuccessMessage;

  // Pagination state
  int _page = 1;
  int _limit = 20;
  int _total = 0;
  final List<int> _allowedPageSizes = [10, 20, 50, 100];

  // Need to rebuild columns when locale changes
  Key _gridKey = UniqueKey();

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
     final permissions = await SessionService.getPermissions();
     // Check for FARM module and cattle resource. Permission string format: C R U D L (5 chars)
     // CRUDL: Create, Read, Update, Delete, List. Index 2 is Update.
     if (permissions['FARM'] != null && permissions['FARM']['cattle'] != null) {
        final permString = permissions['FARM']['cattle'].toString();
        if (permString.length >= 3 && permString[2] == '1') {
             setState(() => _hasEditPermission = true);
        }
     }
  }

  Future<void> _loadData() async {
    // Only show full screen loader if grid is not initialized yet (first load)
    if (_gridKey == null || rows.isEmpty) {
       setState(() => isLoading = true);
    } else {
       // Ideally we check if stateManager is initialized, but here we can just rely on mounted check
       // stateManager might not be accessible if grid is not built yet.
       try {
         stateManager.setShowLoading(true);
       } catch (e) {
         // Fallback if statemanager not ready
         setState(() => isLoading = true);
       }
    }

    try {
      final results = await Future.wait([
        _service.getCattleList(page: _page, limit: _limit),
        _service.getColors(),
        _service.getCharacteristics(),
      ]);

      final cattleResult = results[0] as CattlePageResult;
      _total = cattleResult.total;
      final cattleList = cattleResult.items;

      _colors = (results[1] as List).cast<String>();
      _characteristics = (results[2] as List).cast<String>();

      final newRows = _createRows(cattleList);
      
      if (mounted) {
         // If generic loading was used
         if (isLoading) {
             setState(() {
               isLoading = false;
               rows = newRows;
             });
         } else {
             // Grid already exists, update rows via stateManager
             stateManager.setShowLoading(false);
             stateManager.removeAllRows();
             stateManager.appendRows(newRows);
             stateManager.notifyListeners(); // Ensure grid redraws
             // Update local rows variable just in case, though usually stateManager holds the truth
             rows = newRows;
             setState(() {}); // Trigger rebuild for Footer info (page counts)
         }
      }
    } on ApiException catch (e) {
      final t = AppLocalizations.of(context)!;
      final code = ApiExceptionCode.values.firstWhere(
        (el) => el.name == (e.code ?? ''),
        orElse: () => ApiExceptionCode.unknownError,
      );
      final errorText = code.asText(context, objectName: t.cattle);
      _showError(errorText);
      if (code == ApiExceptionCode.unknownError && e.code != 'unknownError') {
        print('ApiException code desconocido: ${e.code}');
      }
      if (isLoading) setState(() => isLoading = false);
    } catch (e) {
      debugPrint('Error loading cattle data: $e');
      if (mounted) {
        if (isLoading) setState(() => isLoading = false);
        try { stateManager.setShowLoading(false); } catch (_) {}
        _showError('Error: $e');
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gridKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final columns = [
      PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text(), hide: true, width: 0),
      PlutoColumn(title: l10n.cattleNumber, field: 'number', type: PlutoColumnType.text(), width: 90, enableEditingMode: _hasEditPermission, frozen: PlutoColumnFrozen.start),
      PlutoColumn(
        title: l10n.colStatus, 
        field: 'status', 
        type: PlutoColumnType.text(),
        enableEditingMode: _hasEditPermission,
        width: 80,
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
                   items: statusList.map((s) {
                        return DropdownMenuItem(
                           value: s,
                           child: Text(
                             CattleStatusEnum.fromString(s).localizedName(context), 
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(fontSize: 12),
                           )
                        );
                   }).toList(),
                   onChanged: !_hasEditPermission ? null : (newValue) {
                       if (newValue != null) {
                           debugPrint('Status changed to $newValue');
                           rendererContext.stateManager.changeCellValue(rendererContext.cell, newValue);
                       }
                   },
               ),
           );
        },
      ),
      PlutoColumn(title: l10n.colLastWeight, field: 'lastWeight', type: PlutoColumnType.number(), width: 100, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.eartag, field: 'eartag', type: PlutoColumnType.text(), width: 100, enableEditingMode: _hasEditPermission),
      PlutoColumn(
        title: l10n.colHorns,
        field: 'hasHorn',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          bool value = rendererContext.cell.value.toString() == 'true';
          return Checkbox(
            value: value,
            onChanged: !_hasEditPermission ? null : (newValue) {
              stateManager.changeCellValue(rendererContext.cell, newValue.toString());
            },
          );
        },
        width: 80,
      ),
      PlutoColumn(
        title: l10n.colCastrated,
        field: 'isCastrated',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          bool value = rendererContext.cell.value.toString() == 'true';
          return Checkbox(
            value: value,
            onChanged: !_hasEditPermission ? null : (newValue) {
              stateManager.changeCellValue(rendererContext.cell, newValue.toString());
            },
          );
        },
        width: 90,
      ),
      // Dynamic Color Dropdown
      PlutoColumn(
        title: l10n.colBrandColor, 
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
                   items: _colors.map((c) {
                        return DropdownMenuItem(
                           value: c,
                           child: Text(
                             CattleColor.fromString(c).localizedName(context), 
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(fontSize: 12),
                           )
                        );
                   }).toList(),
                   onChanged: !_hasEditPermission ? null : (newValue) {
                       if (newValue != null) {
                           debugPrint('Color changed to $newValue');
                           rendererContext.stateManager.changeCellValue(rendererContext.cell, newValue);
                       }
                   },
               ),
           );
        },
      ),
      PlutoColumn(
        title: l10n.colCharacteristics, 
        field: 'characteristics', 
        type: PlutoColumnType.text(), 
        width: 150,
        enableEditingMode: false,
        renderer: (rendererContext) {
           return InkWell(
               onTap: !_hasEditPermission ? null : () async {
                   final ids = rendererContext.row.cells['characteristicsIds']?.value as List<String>;
                   // Capture key to ensure we find the correct row even if sorting/filtering changed usage
                   final rowKey = rendererContext.row.key;
                   final cattleNumber = rendererContext.row.cells['number']?.value.toString() ?? '';
                   final result = await showDialog(
                       context: context,
                       builder: (ctx) => CharacteristicsEditDialog(
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
                       PlutoRow? activeRow;
                       try {
                         activeRow = stateManager.rows.firstWhere((r) => r.key == rowKey);
                       } catch (e) {
                         debugPrint('Could not find row with key $rowKey: $e');
                         return;
                       }
                       if (activeRow != null) {
                           final rowId = activeRow.cells['id']?.value.toString();
                           if (rowId != null && rowId != 'New' && rowId.isNotEmpty) {
                               debugPrint("Saving to DB for row $rowId");
                               try {
                                   // Manual API call to avoid triggering onChanged with List value
                                   await _service.updateCattle(rowId, {'characteristics': newIds});
                                   if (mounted) {
                                      // Update hidden value directly
                                      activeRow!.cells['characteristicsIds']!.value = newIds;
                                      // Update visible text manually
                                      activeRow!.cells['characteristics']!.value = newNames.join(', ');
                                      // Force grid refresh
                                      stateManager.notifyListeners(); // Notify PlutoGrid to rebuild
                                      setState(() {}); // Trigger local widget rebuild just in case
                                      _showSuccess('Saved');
                                   }
                               } catch (e) {
                                   debugPrint("Error saving characteristics: $e");
                                   if (mounted) {
                                       _showError('Error saving: $e');
                                   }
                               }
                           } else {
                               // For new rows not yet saved to DB, just update local state
                               activeRow.cells['characteristicsIds']!.value = newIds;
                               stateManager.changeCellValue(activeRow.cells['characteristics']!, newNames.join(', '));
                           }
                       }
                   }
               },
               child: Row(
                    children: [
                        Expanded(child: Text(rendererContext.cell.value.toString(), overflow: TextOverflow.ellipsis)),
                        const Icon(Icons.edit, size: 14, color: Colors.grey),
                    ],
                ),
           );
        }
      ),
      PlutoColumn(
        title: l10n.colGender,
        field: 'gender',
        type: PlutoColumnType.text(),
        enableEditingMode: _hasEditPermission,
        width: 100,
        renderer: (rendererContext) {
           String currentValue = rendererContext.cell.value.toString();
           return DropdownButtonHideUnderline(
               child: DropdownButton<String>(
                   value: CattleGender.values.any((e) => e.name == currentValue) ? currentValue : null,
                   icon: const Icon(Icons.arrow_drop_down, size: 16),
                   isDense: true,
                   isExpanded: true,
                   style: const TextStyle(fontSize: 12, color: Colors.black),
                   items: CattleGender.values.map((e) {
                        return DropdownMenuItem(
                           value: e.name,
                           child: Text(
                             e.localizedName(context), 
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(fontSize: 12),
                           )
                        );
                   }).toList(),
                   onChanged: !_hasEditPermission ? null : (newValue) {
                       if (newValue != null) {
                           debugPrint('Gender changed to $newValue');
                           rendererContext.stateManager.changeCellValue(rendererContext.cell, newValue);
                       }
                   },
               ),
           );
        },
      ),
      PlutoColumn(title: l10n.colAge, field: 'age', type: PlutoColumnType.number(format: '#,##0.##'), width: 60, enableEditingMode: _hasEditPermission),
      PlutoColumn(
        title: l10n.trackerLabel,
        field: 'tracker',
        type: PlutoColumnType.text(),
        width: 170,
        enableEditingMode: false,
        renderer: (rendererContext) {
            return InkWell(
                onTap: !_hasEditPermission ? null : () async {
                    final rowKey = rendererContext.row.key;
                    final result = await showDialog(
                        context: context,
                        builder: (ctx) => TrackerEditDialog(
                            initialValue: rendererContext.cell.value.toString(),
                            onSelected: (device) {}, // Handled by await result
                        ),
                    );
                    if (result != null && result is DeviceModel && mounted) {
                        PlutoRow? activeRow;
                        try {
                           activeRow = stateManager.rows.firstWhere((r) => r.key == rowKey);
                        } catch (e) {
                           return;
                        }
                        if (activeRow != null) {
                            final rowId = activeRow.cells['id']?.value.toString();
                            if (rowId != null && rowId != 'New' && rowId.isNotEmpty) {
                                try {
                                    await _service.updateCattle(rowId, {'idDevice': result.id});
                                    if (mounted) {
                                        // Find any other row that has this device attached and clear it
                                        try {
                                            final oldOwnerRow = stateManager.rows.firstWhere((r) => 
                                                r.key != rowKey && 
                                                r.cells['idDevice']?.value == result.id
                                            );
                                            // Clear the old owner logic
                                            oldOwnerRow.cells['tracker']!.value = '';
                                            oldOwnerRow.cells['idDevice']!.value = '';
                                        } catch (e) {
                                            // No previous owner found in current loaded list, ignore
                                        }
                                        activeRow.cells['tracker']!.value = result.name;
                                        activeRow.cells['idDevice']!.value = result.id;
                                        stateManager.notifyListeners();
                                        setState(() {});
                                        _showSuccess('Saved');
                                    }
                                } catch (e) {
                                    if (mounted) {
                                        _showError('Error: $e');
                                    }
                                }
                            } else {
                                activeRow.cells['tracker']!.value = result.name;
                                stateManager.changeCellValue(activeRow.cells['idDevice']!, result.id);
                            }
                        }
                    }
                },
                child: Row(
                    children: [
                        if (rendererContext.cell.value.toString().isNotEmpty)
                            const Icon(Icons.location_on, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Expanded(child: Text(rendererContext.cell.value.toString(), overflow: TextOverflow.ellipsis)),
                        const Icon(Icons.edit, size: 14, color: Colors.grey),
                    ],
                ),
            );
        }
      ),
      PlutoColumn(title: l10n.lot, field: 'auctionLot', type: PlutoColumnType.text(), width: 100, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colComments, field: 'comments', type: PlutoColumnType.text(), width: 200, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colPurchaseWeight, field: 'purchaseWeight', type: PlutoColumnType.number(), width: 110, enableEditingMode: _hasEditPermission),
      //PlutoColumn(title: l10n.colReceivedDate, field: 'receivedDate', type: PlutoColumnType.date(), width: 110),
      PlutoColumn(title: l10n.colPurchasePrice, field: 'purchasePrice', type: PlutoColumnType.number(), width: 110, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colPurchaseCommission, field: 'purchaseCommission', type: PlutoColumnType.number(), width: 110, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colReceivedAt, field: 'receivedAt', type: PlutoColumnType.date(), width: 110, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colReceivedWeight, field: 'receivedWeight', type: PlutoColumnType.number(), width: 100, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colSaleWeight, field: 'saleWeight', type: PlutoColumnType.number(), width: 110, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.colSalePrice, field: 'salePrice', type: PlutoColumnType.number(), width: 110, enableEditingMode: _hasEditPermission),
      PlutoColumn(
        title: l10n.colWeightHistory, 
        field: 'weightHistory', 
        type: PlutoColumnType.text(), 
        enableEditingMode: false, 
        width: 100, 
        renderer: (ctx) {
          return InkWell(
            onTap: () {
              final history = ctx.cell.value;
              final cattleNumber = ctx.row.cells['number']?.value.toString() ?? '';
              if (history is List) {
                 showDialog(
                   context: context,
                   builder: (_) => WeightHistoryDialog(history: history, cattleNumber: cattleNumber),
                 );
              }
            },
            child: const Icon(Icons.history, size: 18),
          );
        }
      ),
      PlutoColumn(
        title: l10n.colMedicationHistory, 
        field: 'medicationHistory', 
        type: PlutoColumnType.text(), 
        enableEditingMode: false, 
        width: 100, 
        renderer: (ctx) {
          return InkWell(
            onTap: () async {
               final rowId = ctx.row.cells['id']!.value.toString();
               final cattleNumber = ctx.row.cells['number']?.value.toString() ?? '';
               final history = (ctx.cell.value as List?) ?? [];
               final result = await showDialog<List<dynamic>>(
                 context: context,
                 builder: (_) => MedicationHistoryDialog(
                   cattleId: rowId,
                   cattleNumber: cattleNumber,
                   history: history,
                   service: _service,
                   onAdded: (newRecord) {
                       debugPrint('Adding new medication record to grid: $newRecord');
                       try {
                          final row = stateManager.rows.firstWhere((r) => r.key == ctx.row.key);
                          // ignore: unnecessary_null_comparison
                          if (row != null) {
                             final cell = row.cells['medicationHistory']!;
                             final currentHistory = List<dynamic>.from(cell.value as List? ?? []);
                             currentHistory.insert(0, newRecord);
                             stateManager.changeCellValue(cell, currentHistory, callOnChangedEvent: false, force: true);
                             debugPrint('Grid cell updated. New history length: ${currentHistory.length}');
                          } else {
                             debugPrint('Could not find row by key to update medication history');
                          }
                       } catch (e) {
                          debugPrint('Error updating grid medication history: $e');
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
        }
      ),
      
      PlutoColumn(title: 'IdDevice', field: 'idDevice', type: PlutoColumnType.text(), hide: true, width: 0),
      PlutoColumn(title: 'CharacteristicsIds', field: 'characteristicsIds', type: PlutoColumnType.text(), hide: true, width: 0),
    ];

    return FincaScaffold(
      title: l10n.masterListTitle,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_globalErrorMessage != null) MessageBanner.error(_globalErrorMessage!),
            if (_globalSuccessMessage != null) MessageBanner.success(_globalSuccessMessage!),
            /*Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _addCattleRow,
                icon: const Icon(Icons.add),
                label: Text(l10n.addCattleRow),
              ),
            ),
            const SizedBox(height: 12),*/
            Expanded(
              child: isLoading
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
                          debugPrint('onChanged triggered for rowId: $rowId, field: ${event.column.field}, value: ${event.value}');
                          if (rowId.isEmpty || rowId == 'New') {
                              debugPrint('Skipping save for new/empty row');
                              return; 
                          }
                          String field = event.column.field;
                          dynamic value = event.value;
                          if (field == 'hasHorn') value = value.toString() == 'true';
                          if (field == 'isCastrated') {
                              field = 'castrated';
                              value = value.toString() == 'true';
                          }
                          if (field == 'characteristicsIds') field = 'characteristics';
                          if (['tracker', 'characteristics', 'idDevice'].contains(field)) return;

                          // Validation for lastWeight,receivedWeight
                          if (field == 'lastWeight' || field == 'receivedWeight' ) {
                             final double? weight = double.tryParse(value.toString());
                             if (weight == null || weight <= 0) {
                                if (mounted) {
                                  _showError(l10n.error_enterValidWeight);
                                  // Revert the cell value in the grid UI
                                  final oldWeight = event.oldValue;
                                  stateManager.changeCellValue(event.row.cells[field]!, oldWeight, callOnChangedEvent: false, force: true);
                                }
                                return;
                             }
                          }

                          try {
                            final updatedData = await _service.updateCattle(rowId, {field: value});
                            if (mounted) {
                                if (updatedData != null) {
                                   try {
                                      // Re-fetch row ensuring we have the latest reference
                                      final row = stateManager.rows.firstWhere((r) => r.key == event.row.key);
                                      // ignore: unnecessary_null_comparison
                                      if (row != null) {
                                         if (updatedData.containsKey('weightHistory')) {
                                             debugPrint('Updating weight history for row ${rowId}: ${updatedData['weightHistory'].length} items');
                                             stateManager.changeCellValue(row.cells['weightHistory']!, updatedData['weightHistory'], callOnChangedEvent: false, force: true);
                                         }
                                         if (updatedData.containsKey('medicationHistory')) {
                                             debugPrint('Updating medication history for row ${rowId}: ${updatedData['medicationHistory'].length} items');
                                             stateManager.changeCellValue(row.cells['medicationHistory']!, updatedData['medicationHistory'], callOnChangedEvent: false, force: true);
                                         }
                                      }
                                   } catch (e) {
                                      debugPrint('Error updating history cells: $e');
                                   }
                                }
                                _showSuccess('Saved');
                            }
                          } catch (e) {
                              debugPrint('Error saving field $field: $e');
                              if (mounted) {
                                _showError('Error saving: $e');
                                // Revert value on API error as well for consistency
                                stateManager.changeCellValue(event.row.cells[event.column.field]!, event.oldValue, callOnChangedEvent: false, force: true);
                              }
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
                         items: _allowedPageSizes.map((s) => DropdownMenuItem(value: s, child: Text('$s'))).toList(),
                         onChanged: _onPageSizeChange,
                         underline: Container(), 
                       ),
                    ],
                  ),
                  Text('${l10n.page} $_page / $_pageCount   ($_total ${l10n.results})'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _page > 1 ? () => _onPageChange(_page - 1) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _page < _pageCount ? () => _onPageChange(_page + 1) : null,
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
    stateManager.insertRows(
      0,
      [
        PlutoRow(cells: {
          'number': PlutoCell(value: ''),
          'status': PlutoCell(value: CattleStatusEnum.ACTIVE.name),
          'lastWeight': PlutoCell(value: 0),
          'eartag': PlutoCell(value: ''),
          'hasHorn': PlutoCell(value: 'false'),
          'isCastrated': PlutoCell(value: 'false'),
          'color': PlutoCell(value: _colors.isNotEmpty ? _colors[0] : ''), 
          'characteristics': PlutoCell(value: ''),
          'gender': PlutoCell(value: 'MALE'),
          'age': PlutoCell(value: 0),
          'tracker': PlutoCell(value: ''),
          'idDevice': PlutoCell(value: ''),
          'auctionLot': PlutoCell(value: ''),
          'comments': PlutoCell(value: ''),
          'purchaseWeight': PlutoCell(value: 0),
          'purchasePrice': PlutoCell(value: 0),
          'purchaseCommission': PlutoCell(value: 0),
          'receivedAt': PlutoCell(value: DateTime.now().toString().substring(0, 10)),
          'receivedWeight': PlutoCell(value: 0),
          'saleWeight': PlutoCell(value: 0),
          'salePrice': PlutoCell(value: 0),
          'weightHistory': PlutoCell(value: ''),
          'medicationHistory': PlutoCell(value: ''),
          'characteristicsIds': PlutoCell(value: <String>[]),
        }),
      ],
    );
  }

  List<PlutoRow> _createRows(List<Map<String, dynamic>> cattleList) {
    return cattleList.map((cattle) {
      final characteristicsList = (cattle['cattleCharacteristics'] as List?)
          ?.map((c) => c['characteristic'] as String)
          .map((c) => CattleCharacteristic.fromString(c)?.localizedName(context) ?? c)
          .join(', ') ?? '';

      return PlutoRow(
        cells: {
            'id': PlutoCell(value: cattle['id'] ?? ''), 
            'number': PlutoCell(value: cattle['number'] ?? ''),
            'status': PlutoCell(value: cattle['status'] ?? 'ACTIVE'),
            'lastWeight': PlutoCell(value: cattle['lastWeight'] ?? 0),
            'eartag': PlutoCell(value: cattle['eartag'] ?? ''),
            'hasHorn': PlutoCell(value: (cattle['hasHorn'] ?? false).toString()),
            'isCastrated': PlutoCell(value: (cattle['castrated'] ?? false).toString()),
            'color': PlutoCell(value: cattle['color'] ?? ''), 
            'characteristics': PlutoCell(value: characteristicsList), 
            'characteristicsIds': PlutoCell(value: (cattle['cattleCharacteristics'] as List?)
              ?.map((c) => c['characteristic'] as String)
              .toList() ?? <String>[]),
            'gender': PlutoCell(value: cattle['gender'] ?? 'MALE'),
            'age': PlutoCell(value: double.tryParse(cattle['age']?.toString() ?? '') ?? 0),
            'tracker': PlutoCell(value: cattle['device'] != null ? cattle['device']['name'] : ((cattle['deviceName'] as String?) ?? '')),
            'idDevice': PlutoCell(value: cattle['device'] != null ? cattle['device']['id'] : ((cattle['idDevice'] as String?) ?? '')),
            'auctionLot': PlutoCell(value: cattle['auctionLot'] ?? ''),
            'comments': PlutoCell(value: cattle['comments'] ?? ''),
            'purchaseWeight': PlutoCell(value: cattle['purchaseWeight'] ?? 0),
            'purchasePrice': PlutoCell(value: cattle['purchasePrice'] ?? 0),
            'purchaseCommission': PlutoCell(value: cattle['purchaseCommission'] ?? 0),
            'receivedAt': PlutoCell(value: cattle['receivedAt'] ?? ''),
            'receivedWeight': PlutoCell(value: cattle['receivedWeight'] ?? 0),  
            'saleWeight': PlutoCell(value: cattle['saleWeight'] ?? 0),
            'salePrice': PlutoCell(value: cattle['salePrice'] ?? 0),
            'weightHistory': PlutoCell(value: cattle['weightHistory'] ?? []),
            'medicationHistory': PlutoCell(value: cattle['medicationHistory'] ?? []),
        }
      );
    }).toList();
  }
}

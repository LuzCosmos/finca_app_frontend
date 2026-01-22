import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
// import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
// import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'dart:async';

import 'package:finca_app_frontend/modules/web/features/cattle/widgets/tracker_edit_dialog.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/characteristics_edit_dialog.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';

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

  // Need to rebuild columns when locale changes
  Key _gridKey = UniqueKey();

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
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        _service.getCattleList(),
        _service.getColors(),
        _service.getCharacteristics(),
      ]);

      final cattleList = (results[0] as List).cast<Map<String, dynamic>>();
      if (cattleList.isNotEmpty) {
          debugPrint('First cattle record: ${cattleList.first}');
      }
      _colors = (results[1] as List).cast<String>();
      _characteristics = (results[2] as List).cast<String>();

      rows = cattleList.map((cattle) {
        return PlutoRow(
          cells: {
             'id': PlutoCell(value: cattle['id'] ?? ''), // Store cattle ID
             'systemNumber': PlutoCell(value: cattle['systemNumber'] ?? 'New'),
             'number': PlutoCell(value: cattle['number'] ?? ''),
             'eartag': PlutoCell(value: cattle['eartag'] ?? ''),
             'color': PlutoCell(value: cattle['color'] ?? ''), // New Enum string field
             'characteristics': PlutoCell(value: (cattle['cattleCharacteristics'] as List?)
                ?.map((c) {
                   final val = c['characteristic'] as String;
                   // Ensure context is valid, though in _loadData it should be if mounted check logic surrounds it?
                   // However, modifying rows in setState logic is safe.
                   // But retrieving localizedName requires context. 
                   // Ideally we preload localized Strings or use a safe method.
                   // State context is available.
                   return CattleCharacteristic.fromString(val)?.localizedName(context) ?? val;
                })
                .join(', ') ?? ''), 
             'characteristicsIds': PlutoCell(value: (cattle['cattleCharacteristics'] as List?)
                ?.map((c) => c['characteristic'] as String)
                .toList() ?? <String>[]), // Store formatted List<String>
             'hasHorn': PlutoCell(value: (cattle['hasHorn'] ?? false).toString()),
             'isCastrated': PlutoCell(value: (cattle['castrated'] ?? false).toString()),
             'auctionLot': PlutoCell(value: cattle['auctionLot'] ?? ''), // Assuming this field exists
             'receivedAt': PlutoCell(value: cattle['receivedAt'] ?? ''),
             'purchaseWeight': PlutoCell(value: cattle['purchaseWeight'] ?? 0),
             'receivedDate': PlutoCell(value: cattle['receivedDate'] ?? ''), // Check actual field name
             'comments': PlutoCell(value: cattle['comments'] ?? ''),
             'purchasePrice': PlutoCell(value: cattle['purchasePrice'] ?? 0),
             'purchaseCommission': PlutoCell(value: cattle['purchaseCommission'] ?? 0),
             'status': PlutoCell(value: cattle['status'] ?? 'ACTIVE'),
             'weightHistory': PlutoCell(value: ''),
             'medicationHistory': PlutoCell(value: ''),
             'saleWeight': PlutoCell(value: 0), // Fetch if available
             'salePrice': PlutoCell(value: 0),
             'tracker': PlutoCell(value: cattle['device'] != null ? cattle['device']['name'] : (cattle['deviceName'] ?? '')),
             'idDevice': PlutoCell(value: cattle['device'] != null ? cattle['device']['id'] : (cattle['idDevice'] ?? '')),
          }
        );
      }).toList();

    } catch (e) {
      // Handle error
      debugPrint('Error loading cattle data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gridKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return FincaScaffold(
        title: l10n.masterListTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final columns = [
      PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text(), hide: true, width: 0),
      PlutoColumn(
        title: l10n.colSystemNumber,
        field: 'systemNumber',
        type: PlutoColumnType.text(),
        enableEditingMode: _hasEditPermission,
        width: 100,
      ),
      PlutoColumn(title: l10n.cattleNumber, field: 'number', type: PlutoColumnType.text(), width: 90, enableEditingMode: _hasEditPermission),
      PlutoColumn(title: l10n.eartag, field: 'eartag', type: PlutoColumnType.text(), width: 100, enableEditingMode: _hasEditPermission),
      // Dynamic Color Dropdown
      PlutoColumn(
        title: l10n.colBrandColor, 
        field: 'color', 
        type: PlutoColumnType.select(_colors), // Determine if we use ID or Name. Usually ID for value.
        enableEditingMode: _hasEditPermission,
        formatter: (value) {
            final colorEnum = CattleColor.fromString(value);
            return colorEnum.localizedName(context);
        },
        width: 100
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
                   
                   final result = await showDialog(
                       context: context,
                       builder: (ctx) => CharacteristicsEditDialog(
                           availableCharacteristics: _characteristics,
                           selectedIds: ids,
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
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                         const SnackBar(content: Text('Saved'), duration: Duration(milliseconds: 500), backgroundColor: Colors.green),
                                      );
                                   }
                               } catch (e) {
                                   debugPrint("Error saving characteristics: $e");
                                   if (mounted) {
                                       ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
                                       );
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
      PlutoColumn(
        title: l10n.trackerLabel,
        field: 'tracker',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: false,
        renderer: (rendererContext) {
            return InkWell(
                onTap: !_hasEditPermission ? null : () {
                    showDialog(
                        context: context,
                        builder: (ctx) => TrackerEditDialog(
                            initialValue: rendererContext.cell.value.toString(),
                            onSelected: (device) {
                                stateManager.changeCellValue(rendererContext.cell, device.name);
                                stateManager.changeCellValue(rendererContext.row.cells['idDevice']!, device.id);
                            },
                        ),
                    );
                },
                child: Row(
                    children: [
                        if (rendererContext.cell.value.toString().isNotEmpty)
                            const Icon(Icons.gps_fixed, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Expanded(child: Text(rendererContext.cell.value.toString(), overflow: TextOverflow.ellipsis)),
                        const Icon(Icons.edit, size: 14, color: Colors.grey),
                    ],
                ),
            );
        }
      ),
      PlutoColumn(title: l10n.lot, field: 'auctionLot', type: PlutoColumnType.text(), width: 100),
      PlutoColumn(title: l10n.colReceivedAt, field: 'receivedAt', type: PlutoColumnType.date(), width: 110),
      PlutoColumn(title: l10n.colPurchaseWeight, field: 'purchaseWeight', type: PlutoColumnType.number(), width: 110),
      PlutoColumn(title: l10n.colReceivedDate, field: 'receivedDate', type: PlutoColumnType.date(), width: 110),
      PlutoColumn(title: l10n.colComments, field: 'comments', type: PlutoColumnType.text(), width: 200),
      PlutoColumn(title: l10n.colPurchasePrice, field: 'purchasePrice', type: PlutoColumnType.number(), width: 110),
      PlutoColumn(title: l10n.colPurchaseCommission, field: 'purchaseCommission', type: PlutoColumnType.number(), width: 110),
      PlutoColumn(title: l10n.colStatus, field: 'status', type: PlutoColumnType.select(['ACTIVE', 'SOLD', 'DEAD', 'LOST']), width: 100),
      PlutoColumn(title: l10n.colWeightHistory, field: 'weightHistory', type: PlutoColumnType.text(), enableEditingMode: false, width: 100, renderer: (ctx) => const Icon(Icons.history, size: 18)),
      PlutoColumn(title: l10n.colMedicationHistory, field: 'medicationHistory', type: PlutoColumnType.text(), enableEditingMode: false, width: 100, renderer: (ctx) => const Icon(Icons.medical_services, size: 18)),
      PlutoColumn(title: l10n.colSaleWeight, field: 'saleWeight', type: PlutoColumnType.number(), width: 110),
      PlutoColumn(title: l10n.colSalePrice, field: 'salePrice', type: PlutoColumnType.number(), width: 110),
      PlutoColumn(title: 'IdDevice', field: 'idDevice', type: PlutoColumnType.text(), hide: true, width: 0),
      PlutoColumn(title: 'CharacteristicsIds', field: 'characteristicsIds', type: PlutoColumnType.text(), hide: true, width: 0),
    ];

    return FincaScaffold(
      title: l10n.masterListTitle,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _addCattleRow,
                icon: const Icon(Icons.add),
                label: Text(l10n.addCattleRow),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PlutoGrid(
                key: _gridKey,
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

                  // Map column field to DTO field if necessary
                  String field = event.column.field;
                  dynamic value = event.value;

                  // Handle special fields
                  if (field == 'hasHorn' || field == 'isCastrated') {
                     // Checkbox returns 'true'/'false' string, converting to boolean
                     if (field == 'hasHorn') value = value.toString() == 'true';
                     if (field == 'isCastrated') {
                         field = 'castrated';
                         value = value.toString() == 'true';
                     }
                  } else if (field == 'tracker') {
                     // Tracker isn't directly editable via text, dialog handles it by setting idDevice
                     // Logic handled below
                     return; 
                  } else if (field == 'characteristics') {
                     // Characteristics text isn't directly saved, we use characteristicsIds from dialog
                     return;
                  } else if (field == 'characteristicsIds') {
                      field = 'characteristics'; // DTO expects 'characteristics'
                      // value is List<String>
                  } else if (field == 'idDevice') {
                      // Handled by tracker dialog
                  } else if (field == 'auctionLot') {
                      // field name matches
                  }

                  // Construct payload
                  final Map<String, dynamic> payload = {field: value};

                  try {
                    await _service.updateCattle(rowId, payload);
                     if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Saved'), duration: Duration(milliseconds: 500), backgroundColor: Colors.green),
                        );
                     }
                  } catch (e) {
                      debugPrint('Error saving field $field: $e');
                      if (mounted) {
                        // Revert change?
                        // stateManager.changeCellValue(event.row.cells[field]!, event.oldValue);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
                        );
                      }
                  }
                },
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
          'systemNumber': PlutoCell(value: 'New'),
          'number': PlutoCell(value: ''),
          'eartag': PlutoCell(value: ''),
          'color': PlutoCell(value: _colors.isNotEmpty ? _colors[0] : ''), // Default to first color
          'characteristics': PlutoCell(value: ''),
          'hasHorn': PlutoCell(value: 'false'),
          'isCastrated': PlutoCell(value: 'false'),
          'auctionLot': PlutoCell(value: ''),
          'receivedAt': PlutoCell(value: DateTime.now().toString().substring(0, 10)),
          'purchaseWeight': PlutoCell(value: 0),
          'receivedDate': PlutoCell(value: DateTime.now().toString().substring(0, 10)),
          'comments': PlutoCell(value: ''),
          'purchasePrice': PlutoCell(value: 0),
          'purchaseCommission': PlutoCell(value: 0),
          'status': PlutoCell(value: 'ACTIVE'),
          'weightHistory': PlutoCell(value: ''),
          'medicationHistory': PlutoCell(value: ''),
          'saleWeight': PlutoCell(value: 0),
          'salePrice': PlutoCell(value: 0),
          'tracker': PlutoCell(value: ''),
          'idDevice': PlutoCell(value: ''),
          'characteristicsIds': PlutoCell(value: <String>[]),
        }),
      ],
    );
  }
}


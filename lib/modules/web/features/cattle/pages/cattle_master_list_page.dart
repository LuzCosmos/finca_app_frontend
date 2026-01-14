import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
// import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
// import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'dart:async';

class CattleMasterListPage extends StatefulWidget {
  const CattleMasterListPage({super.key});

  @override
  State<CattleMasterListPage> createState() => _CattleMasterListPageState();
}

class _CattleMasterListPageState extends State<CattleMasterListPage> {
  late final PlutoGridStateManager stateManager;
  final CattleMasterService _service = CattleMasterService();
  
  List<PlutoRow> rows = [];
  List<Map<String, dynamic>> _colors = [];
  // List<Map<String, dynamic>> _characteristics = [];
  bool isLoading = true;

  // Need to rebuild columns when locale changes
  Key _gridKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        _service.getCattleList(),
        _service.getColors(),
        _service.getCharacteristics(),
      ]);

      final cattleList = results[0] as List<Map<String, dynamic>>;
      _colors = results[1] as List<Map<String, dynamic>>;
      // Characteristics loaded but not yet used in column renderer
      // _characteristics = results[2] as List<Map<String, dynamic>>;

      rows = cattleList.map((cattle) {
        return PlutoRow(
          cells: {
             'systemNumber': PlutoCell(value: cattle['systemNumber'] ?? 'New'),
             'number': PlutoCell(value: cattle['number'] ?? ''),
             'eartag': PlutoCell(value: cattle['eartag'] ?? ''),
             'color': PlutoCell(value: cattle['idColor'] ?? ''), // Should map ID to value if possible, but select column handles this via items
             'characteristics': PlutoCell(value: (cattle['characteristicsIds'] as List?)?.join(', ') ?? ''),
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
             'tracker': PlutoCell(value: cattle['deviceName'] ?? ''),
             'idDevice': PlutoCell(value: cattle['idDevice'] ?? ''),
          }
        );
      }).toList();

    } catch (e) {
      // Handle error
      print('Error loading cattle data: $e');
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
      PlutoColumn(
        title: l10n.colSystemNumber,
        field: 'systemNumber',
        type: PlutoColumnType.text(),
        enableEditingMode: true,
        width: 100,
      ),
      PlutoColumn(title: l10n.cattleNumber, field: 'number', type: PlutoColumnType.text(), width: 90),
      PlutoColumn(title: l10n.eartag, field: 'eartag', type: PlutoColumnType.text(), width: 100),
      // Dynamic Color Dropdown
      PlutoColumn(
        title: l10n.colBrandColor, 
        field: 'color', 
        type: PlutoColumnType.select(_colors.map((c) => c['id']).toList()), // Determine if we use ID or Name. Usually ID for value.
        formatter: (value) {
            final color = _colors.firstWhere((c) => c['id'] == value, orElse: () => {'name': value});
            return color['name'];
        },
        width: 100
      ),
      PlutoColumn(title: l10n.colCharacteristics, field: 'characteristics', type: PlutoColumnType.text(), width: 150),
      PlutoColumn(
        title: l10n.colHorns,
        field: 'hasHorn',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          bool value = rendererContext.cell.value.toString() == 'true';
          return Checkbox(
            value: value,
            onChanged: (newValue) {
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
            onChanged: (newValue) {
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
        enableEditingMode: true,
        renderer: (rendererContext) {
            return Row(
                children: [
                    if (rendererContext.cell.value.toString().isNotEmpty)
                        const Icon(Icons.gps_fixed, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Expanded(child: Text(rendererContext.cell.value.toString())),
                ],
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
                onChanged: (event) {
                    // Logic to update backend
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
          'color': PlutoCell(value: _colors.isNotEmpty ? _colors[0]['id'] : ''), // Default to first color
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
        }),
      ],
    );
  }
}


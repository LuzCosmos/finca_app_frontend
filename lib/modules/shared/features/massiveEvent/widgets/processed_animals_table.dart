import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProcessedAnimalsTable extends StatelessWidget {
  const ProcessedAnimalsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Datos simulados
    final animals = [
      {'number': 'A001', 'weight': '500', 'tracker': 'T-100', 'synced': true},
      {'number': 'A002', 'weight': '480', 'tracker': 'T-101', 'synced': false},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child:
          animals.isEmpty
              ? Center(child: Text(l10n.noAnimals))
              : SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(l10n.tableAnimal)),
                    DataColumn(label: Text(l10n.tableWeight)),
                    DataColumn(label: Text(l10n.tableTracker)),
                    DataColumn(label: Text(l10n.tableStatus)),
                  ],
                  rows:
                      animals.map((a) {
                        return DataRow(
                          cells: [
                            DataCell(Text(a['number'] as String)),
                            DataCell(Text(a['weight'] as String)),
                            DataCell(Text(a['tracker'] as String)),
                            DataCell(
                              Icon(
                                a['synced'] as bool
                                    ? Icons.check_circle
                                    : Icons.sync_problem,
                                color:
                                    a['synced'] as bool
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }
}

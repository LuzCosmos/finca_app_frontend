import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';

class ProcessedAnimalsTable extends StatelessWidget {
  final Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap;
  final List<SimpleEventType> simpleEventTypes;
  final bool isWide;

  const ProcessedAnimalsTable({
    super.key,
    required this.animalEventsAppliedMap,
    required this.simpleEventTypes,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(5),
      child:
          animalEventsAppliedMap.isEmpty
              ? Center(child: Text(l10n.noAnimals))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: isWide ? 12.0 : 6.0,
                    dataRowMinHeight: 24,
                    dataRowMaxHeight: 50,
                    columns: [
                      DataColumn(
                        label: Text(
                          l10n.tableAnimal,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (simpleEventTypes.contains(SimpleEventType.weight))
                        DataColumn(
                          label: Text(
                            l10n.tableWeight,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (simpleEventTypes.contains(SimpleEventType.tracker))
                        DataColumn(
                          label: Text(
                            l10n.tableTracker,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (simpleEventTypes.contains(SimpleEventType.eartag))
                        DataColumn(
                          label: Text(
                            l10n.tableEartag,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (simpleEventTypes.contains(SimpleEventType.castration))
                        DataColumn(
                          label: Text(
                            l10n.tableCastration,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (simpleEventTypes.contains(SimpleEventType.brand))
                        DataColumn(
                          label: Text(
                            l10n.tableBrand,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (simpleEventTypes.contains(SimpleEventType.medication))
                        DataColumn(
                          label: Text(
                            l10n.tableMedication,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      DataColumn(
                        label: Text(
                          l10n.tableSynced,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows:
                        animalEventsAppliedMap.values.map((animalRow) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    animalRow.animalNumber,
                                    style: const TextStyle(fontSize: 13.5),
                                  ),
                                ),
                              ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.weight,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      animalRow.weight?.toString() ?? '',
                                    ),
                                  ),
                                ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.tracker,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(animalRow.tracker ?? ''),
                                  ),
                                ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.eartag,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(animalRow.earTag ?? ''),
                                  ),
                                ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.castration,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      animalRow.castrated ? l10n.yes : l10n.no,
                                    ),
                                  ),
                                ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.brand,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      animalRow.brandNames.join(', '),
                                    ),
                                  ),
                                ),
                              if (simpleEventTypes.contains(
                                SimpleEventType.medication,
                              ))
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      animalRow.medicalTreatments.join(', '),
                                    ),
                                  ),
                                ),

                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Icon(
                                    animalRow.isSynced
                                        ? Icons.check_circle
                                        : Icons.sync_problem,
                                    color:
                                        animalRow.isSynced
                                            ? Colors.green
                                            : Colors.orange,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }
}

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';

class ProcessedAnimalsTable extends StatefulWidget {
  final Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap;
  final List<SimpleEventType> simpleEventTypes;
  final bool isWide;
  /// Si no es null (p. ej. sesión cargada desde lista), muestra peso previo y Δ% cuando hay columna de peso.
  final Map<String, double?>? previousWeightByAnimal;

  const ProcessedAnimalsTable({
    super.key,
    required this.animalEventsAppliedMap,
    required this.simpleEventTypes,
    required this.isWide,
    this.previousWeightByAnimal,
  });
  @override
  State<ProcessedAnimalsTable> createState() => _ProcessedAnimalsTableState();
}

class _ProcessedAnimalsTableState extends State<ProcessedAnimalsTable> {
  final ScrollController _horizontalScroll = ScrollController();

  bool get _showPrevWeightAnalytics =>
      widget.previousWeightByAnimal != null &&
      widget.simpleEventTypes.contains(SimpleEventType.weight);

  String _previousWeightText(
    AnimalSimpleEventTableRowModel row,
    AppLocalizations l10n,
  ) {
    final m = widget.previousWeightByAnimal;
    if (m == null) return '';
    final p = m[row.animalNumber];
    if (p == null) return l10n.massiveEventNoPreviousWeight;
    return p.toString();
  }

  String _deltaPercentText(AnimalSimpleEventTableRowModel row) {
    final m = widget.previousWeightByAnimal;
    if (m == null) return '';
    final p = m[row.animalNumber];
    final w = row.weight;
    if (p == null || w == null || p <= 0) return '—';
    final pct = (w - p) / p * 100;
    return '${pct.toStringAsFixed(1)}%';
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.animalEventsAppliedMap.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Center(child: Text(l10n.noAnimals)),
      );
    }

    final table = _buildDataTable(context, l10n);

    // --- NO WIDE: vertical lo hace el ListView padre, aquí SIEMPRE horizontal ---
    if (!widget.isWide) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Scrollbar(
          trackVisibility: true,
          controller: _horizontalScroll,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScroll,
            primary: false,
            child: table,
          ),
        ),
      );
    }

    // --- WIDE: vertical + horizontal internos; horizontal SIEMPRE activo ---
    return Padding(
      padding: const EdgeInsets.all(5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            // vertical
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              primary: false,
              child: Scrollbar(
                // horizontal SIEMPRE
                trackVisibility: true,
                controller: _horizontalScroll,
                notificationPredicate:
                    (notif) => notif.metrics.axis == Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalScroll,
                  primary: false,
                  child: ConstrainedBox(
                    // evita que el DataTable se achique por debajo del ancho disponible
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: table,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DataTable _buildDataTable(BuildContext context, AppLocalizations l10n) {
    return DataTable(
      columnSpacing: widget.isWide ? 12.0 : 6.0,
      dataRowMinHeight: 24,
      dataRowMaxHeight: 50,
      columns: [
        DataColumn(
          label: Text(
            l10n.animal,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.simpleEventTypes.contains(SimpleEventType.weight))
          DataColumn(
            label: Text(
              l10n.weightKg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (_showPrevWeightAnalytics)
          DataColumn(
            label: Text(
              l10n.massiveEventPreviousWeightShort,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (_showPrevWeightAnalytics)
          DataColumn(
            label: Text(
              l10n.massiveEventDeltaPctShort,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.tracker))
          DataColumn(
            label: Text(
              l10n.tracker,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.eartag))
          DataColumn(
            label: Text(
              l10n.eartagRight,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.eartag))
          DataColumn(
            label: Text(
              l10n.eartagLeft,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.castration))
          DataColumn(
            label: Text(
              l10n.castrated,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.brand))
          DataColumn(
            label: Text(
              l10n.brand,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.simpleEventTypes.contains(SimpleEventType.medication))
          DataColumn(
            label: Text(
              l10n.medication,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

        if (kIsWeb)
          DataColumn(
            label: Text(
              l10n.tableSynced,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
      ],
      rows:
          widget.animalEventsAppliedMap.values.map((animalRow) {
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
                if (widget.simpleEventTypes.contains(SimpleEventType.weight))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.weight?.toString() ?? ''),
                    ),
                  ),
                if (_showPrevWeightAnalytics)
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(_previousWeightText(animalRow, l10n)),
                    ),
                  ),
                if (_showPrevWeightAnalytics)
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(_deltaPercentText(animalRow)),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(SimpleEventType.tracker))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.tracker ?? ''),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(SimpleEventType.eartag))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.earTagRight ?? ''),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(SimpleEventType.eartag))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.earTagLeft ?? ''),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(
                  SimpleEventType.castration,
                ))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.castrated ? l10n.yes : l10n.notApplied),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(SimpleEventType.brand))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.brandNames.join(', ')),
                    ),
                  ),
                if (widget.simpleEventTypes.contains(
                  SimpleEventType.medication,
                ))
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      child: Text(animalRow.medicalTreatments.join(', ')),
                    ),
                  ),

                if (kIsWeb)
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Icon(
                        animalRow.isSynced
                            ? Icons.check_circle
                            : Icons.sync_problem,
                        color:
                            animalRow.isSynced ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
    );
  }
}

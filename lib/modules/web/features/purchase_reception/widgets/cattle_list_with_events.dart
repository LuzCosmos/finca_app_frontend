import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/assign_lot_dialog.dart';

class CattleListWithEvents extends StatefulWidget {
  final List<Map<String, dynamic>> cattle;
  final List<Map<String, dynamic>> availableLots;
  final Function(String cattleId, String lotId) onAssignLot;
  final Function(String? cattleId)? onCattleSelected;

  const CattleListWithEvents({
    super.key,
    required this.cattle,
    required this.availableLots,
    required this.onAssignLot,
    this.onCattleSelected,
  });

  @override
  State<CattleListWithEvents> createState() => _CattleListWithEventsState();
}

class _CattleListWithEventsState extends State<CattleListWithEvents> {
  String? selectedCattleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final selectedCattle = widget.cattle.firstWhere(
      (c) => c['id'] == selectedCattleId,
      orElse: () => {},
    );

    return Card(
      child: Row(
        children: [
          // Left: Cattle List (Table format)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    l10n.cattleOfSelection,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Table Header
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.weightKg,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.eartag,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.tracker,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.actions,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child:
                      widget.cattle.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                l10n.noAnimals,
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: widget.cattle.length,
                            itemBuilder: (context, index) {
                              final cattle = widget.cattle[index];
                              final isSelected =
                                  selectedCattleId == cattle['id'];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCattleId =
                                        isSelected ? null : cattle['id'];
                                  });
                                  widget.onCattleSelected?.call(
                                    selectedCattleId,
                                  );
                                },
                                child: Container(
                                  color:
                                      isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.1)
                                          : null,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          cattle['number'] ?? '—',
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${cattle['receivedWeight'] ?? '—'} kg',
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          cattle['eartag'] ?? '—',
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          cattle['deviceName'] ?? '—',
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (
                                                      context,
                                                    ) => AssignLotDialog(
                                                      availableLots:
                                                          widget.availableLots,
                                                      onAssign: (lotId) {
                                                        widget.onAssignLot(
                                                          cattle['id'],
                                                          lotId,
                                                        );
                                                      },
                                                    ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.playlist_add,
                                              size: 14,
                                            ),
                                            label: Text(
                                              l10n.assignSomething(l10n.lot),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),

          // Right: Events Display
          if (selectedCattleId != null && selectedCattle.isNotEmpty) ...[
            const VerticalDivider(width: 1),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      l10n.eventsApplied,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(child: _buildEventsDisplay(selectedCattle, l10n)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsDisplay(
    Map<String, dynamic> cattle,
    AppLocalizations l10n,
  ) {
    final events = (cattle['appliedEvents'] as List<dynamic>?) ?? [];

    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.noEventsApplied,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index] as Map<String, dynamic>;
        final data = event['data'] as Map<String, dynamic>?;
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data != null && data.containsKey('medicationName'))
                  ..._buildMedicationInfo(data, l10n)
                else if (data != null && data.containsKey('brandName'))
                  ..._buildBrandInfo(data, l10n)
                else
                  Text(
                    event['id'] ?? 'Event',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (event['appliedAt'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateTimeHelper.formatLocalDateTime(event['appliedAt']),
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMedicationInfo(
    Map<String, dynamic> data,
    AppLocalizations l10n,
  ) {
    var firstLine = '';
    if (data['dosage'] != null) {
      firstLine = '${l10n.dosage}: ${data['dosage']}';
    }
    if (data['route'] != null) {
      firstLine += '; ${l10n.route}: ${data['route']}';
    }
    var secondLine = '';
    if (data['lot'] != null) {
      secondLine = '${l10n.medicationLot}: ${data['lot']}';
    }
    return [
      Text(
        data['medicationName'] ?? 'Medication',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(firstLine, style: const TextStyle(fontSize: 13)),
      Text(secondLine, style: const TextStyle(fontSize: 13)),
    ];
  }

  List<Widget> _buildBrandInfo(
    Map<String, dynamic> data,
    AppLocalizations l10n,
  ) {
    return [
      Text(
        '${l10n.eventTypeBrand}: ${data['brandName'] ?? 'Brand'}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ];
  }
}

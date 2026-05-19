import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/applied_reception_event_label.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';

const _kTableHeaderFontSize = 15.0;
const _kTableRowFontSize = 14.0;
const _kTableHeaderPadding = EdgeInsets.symmetric(vertical: 3, horizontal: 2);
const _kTableRowPadding = EdgeInsets.symmetric(vertical: 3, horizontal: 2);
const _kEditIconSize = 18.0;
const _kActionsColumnWidth = _kEditIconSize + 4;

class UnassignedCattleList extends StatefulWidget {
  final List<Map<String, dynamic>> cattle;
  final List<Map<String, dynamic>> availableLots;
  final Function(String? cattleId)? onCattleSelected;
  final bool canEditCattle;
  final VoidCallback? onCattleUpdated;

  const UnassignedCattleList({
    super.key,
    required this.cattle,
    required this.availableLots,
    this.onCattleSelected,
    this.canEditCattle = false,
    this.onCattleUpdated,
  });

  @override
  State<UnassignedCattleList> createState() => _UnassignedCattleListState();
}

class _UnassignedCattleListState extends State<UnassignedCattleList> {
  String? selectedCattleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final selectedCattle =
        selectedCattleId != null
            ? widget.cattle.firstWhere(
              (c) => c['id'] == selectedCattleId,
              orElse: () => {},
            )
            : null;

    return Card(
      child: Row(
        children: [
          // Left: Cattle list
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    l10n.unassignedCattle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Table Header
                Container(
                  color: Colors.grey.shade200,
                  padding: _kTableHeaderPadding,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          l10n.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _kTableHeaderFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          l10n.weightKg,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _kTableHeaderFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          l10n.eartagRight,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _kTableHeaderFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          l10n.eartagLeft,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _kTableHeaderFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          l10n.tracker,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _kTableHeaderFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: _kActionsColumnWidth),
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
                              final animal = widget.cattle[index];
                              final isSelected =
                                  selectedCattleId == animal['id'];

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCattleId =
                                        isSelected ? null : animal['id'];
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
                                  padding: _kTableRowPadding,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          animal['number'] ?? '—',
                                          style: const TextStyle(
                                            fontSize: _kTableRowFontSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${animal['receivedWeight'] ?? '—'}',
                                          style: const TextStyle(
                                            fontSize: _kTableRowFontSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _eartagRight(animal),
                                          style: const TextStyle(
                                            fontSize: _kTableRowFontSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _eartagLeft(animal),
                                          style: const TextStyle(
                                            fontSize: _kTableRowFontSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          animal['deviceName'] ?? '—',
                                          style: const TextStyle(
                                            fontSize: _kTableRowFontSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: _kActionsColumnWidth,
                                        height: _kEditIconSize,
                                        child:
                                            widget.canEditCattle
                                                ? IconButton(
                                                  tooltip: l10n.edit,
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints.tightFor(
                                                        width:
                                                            _kActionsColumnWidth,
                                                        height: _kEditIconSize,
                                                      ),
                                                  style: IconButton.styleFrom(
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    minimumSize: const Size(
                                                      _kActionsColumnWidth,
                                                      _kEditIconSize,
                                                    ),
                                                    fixedSize: const Size(
                                                      _kActionsColumnWidth,
                                                      _kEditIconSize,
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: _kEditIconSize,
                                                    color: Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    final saved = await showDialog<
                                                      bool
                                                    >(
                                                      context: context,
                                                      builder:
                                                          (
                                                            _,
                                                          ) => EditReceivedCattleDialog(
                                                            cattle: animal,
                                                            availableLots:
                                                                widget
                                                                    .availableLots,
                                                          ),
                                                    );
                                                    if (saved == true) {
                                                      widget.onCattleUpdated
                                                          ?.call();
                                                    }
                                                  },
                                                )
                                                : null,
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

          // Right: Events display (only if cattle selected)
          if (selectedCattleId != null && selectedCattle != null) ...[
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
                    appliedReceptionEventTitle(context, event, l10n),
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

  String _eartagLeft(Map<String, dynamic> cattle) {
    final value = (cattle['eartagLeft'] ?? '').toString().trim();
    return value.isEmpty ? '—' : value;
  }

  String _eartagRight(Map<String, dynamic> cattle) {
    final value = (cattle['eartagRight'] ?? '').toString().trim();
    return value.isEmpty ? '—' : value;
  }
}

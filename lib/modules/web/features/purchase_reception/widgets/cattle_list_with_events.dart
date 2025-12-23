import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class CattleListWithEvents extends StatefulWidget {
  final List<Map<String, dynamic>> cattle;
  final Function(String? cattleId)? onCattleSelected;

  const CattleListWithEvents({
    super.key,
    required this.cattle,
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
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.cattleNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.weightKg,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.eartag,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.trackerId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                Expanded(
                  child: widget.cattle.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l10n.noAnimals,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.cattle.length,
                          itemBuilder: (context, index) {
                            final cattle = widget.cattle[index];
                            final isSelected = selectedCattleId == cattle['id'];
                            
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCattleId = isSelected ? null : cattle['id'];
                                });
                                widget.onCattleSelected?.call(selectedCattleId);
                              },
                              child: Container(
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
                                    : null,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                                        style: const TextStyle(fontSize: 11),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        cattle['idDevice'] ?? '—',
                                        style: const TextStyle(fontSize: 11),
                                        textAlign: TextAlign.center,
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
                  Expanded(
                    child: _buildEventsDisplay(selectedCattle, l10n),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsDisplay(Map<String, dynamic> cattle, AppLocalizations l10n) {
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
                  ..._buildMedicationInfo(data)
                else
                  Text(
                    event['id'] ?? 'Event',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (event['appliedAt'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateTime.parse(event['appliedAt']).toString().substring(0, 16),
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

  List<Widget> _buildMedicationInfo(Map<String, dynamic> data) {
    return [
      Text(
        data['medicationName'] ?? 'Medication',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      if (data['dosage'] != null) ...[
        const SizedBox(height: 4),
        Text(
          'Dosage: ${data['dosage']}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
      if (data['route'] != null) ...[
        const SizedBox(height: 2),
        Text(
          'Route: ${data['route']}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
      if (data['lot'] != null) ...[
        const SizedBox(height: 2),
        Text(
          'Lot: ${data['lot']}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ];
  }
}

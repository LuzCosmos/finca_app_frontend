import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_date_filter_field.dart';

/// Filtros colapsables del listado autónomo en **móvil** (equivalente funcional a la barra web).
class MassiveEventStandaloneListMobileFiltersCard extends StatelessWidget {
  const MassiveEventStandaloneListMobileFiltersCard({
    super.key,
    required this.l10n,
    required this.from,
    required this.to,
    required this.nameController,
    required this.statusRaw,
    required this.hasActiveFilters,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onNameChanged,
    required this.onNameSubmitted,
    required this.onStatusChanged,
    required this.onSearch,
    required this.onClearFilters,
  });

  final AppLocalizations l10n;
  final DateTime? from;
  final DateTime? to;
  final TextEditingController nameController;
  final String statusRaw;
  final bool hasActiveFilters;
  final ValueChanged<DateTime?> onFromChanged;
  final ValueChanged<DateTime?> onToChanged;
  final VoidCallback onNameChanged;
  final VoidCallback onNameSubmitted;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onSearch;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final labels = <String, String>{
      'all': l10n.all,
      'open': l10n.open,
      'closed': l10n.massiveEventsStatusClosedLabel,
    };
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          maintainState: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Icon(Icons.tune, color: scheme.primary),
          title: Row(
            children: [
              Expanded(child: Text(l10n.massiveEventsListFiltersTitle)),
              if (hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.circle, size: 8, color: scheme.primary),
                ),
            ],
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: MassiveEventListDateFilterField(
                    label: l10n.from,
                    value: from,
                    onChanged: onFromChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MassiveEventListDateFilterField(
                    label: l10n.to,
                    value: to,
                    onChanged: onToChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.massiveEventsSearchNameOrId,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => onNameChanged(),
              onSubmitted: (_) => onNameSubmitted(),
            ),
            const SizedBox(height: 8),
            Text(l10n.status, style: Theme.of(context).textTheme.labelLarge),
            DropdownButton<String>(
              isExpanded: true,
              value: MassiveEventStandaloneListQuery.coerceStatus(statusRaw),
              items:
                  MassiveEventStandaloneListQuery.allowedStatusCodes.map((code) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(labels[code] ?? code),
                    );
                  }).toList(),
              onChanged: (v) {
                if (v == null) return;
                onStatusChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasActiveFilters)
                  IconButton(
                    onPressed: onClearFilters,
                    icon: const Icon(Icons.clear),
                    tooltip: l10n.clearFilters,
                  ),
                FilledButton.icon(
                  onPressed: onSearch,
                  icon: const Icon(Icons.search),
                  label: Text(l10n.search),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

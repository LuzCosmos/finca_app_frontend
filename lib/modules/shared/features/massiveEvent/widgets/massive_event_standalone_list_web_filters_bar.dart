import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_date_filter_field.dart';

/// Fila de filtros del listado autónomo en **web** (`Card` + `Wrap`).
class MassiveEventStandaloneListWebFiltersBar extends StatelessWidget {
  const MassiveEventStandaloneListWebFiltersBar({
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
    required this.onSearchPressed,
    required this.onClearFilters,
    this.onShortcutToday,
    this.onShortcutThisWeek,
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
  final VoidCallback onSearchPressed;
  final VoidCallback onClearFilters;
  final VoidCallback? onShortcutToday;
  final VoidCallback? onShortcutThisWeek;

  @override
  Widget build(BuildContext context) {
    final labels = <String, String>{
      'all': l10n.all,
      'open': l10n.open,
      'closed': l10n.massiveEventsStatusClosedLabel,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          runSpacing: 8,
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            MassiveEventListDateFilterField(
              label: l10n.from,
              value: from,
              onChanged: onFromChanged,
              width: 130,
            ),
            MassiveEventListDateFilterField(
              label: l10n.to,
              value: to,
              onChanged: onToChanged,
              width: 130,
            ),
            if (onShortcutToday != null)
              TextButton(
                onPressed: onShortcutToday,
                child: Text(l10n.massiveEventsDateShortcutToday),
              ),
            if (onShortcutThisWeek != null)
              TextButton(
                onPressed: onShortcutThisWeek,
                child: Text(l10n.massiveEventsDateShortcutThisWeek),
              ),
            SizedBox(
              width: 240,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.massiveEventsSearchName,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => onNameChanged(),
                onSubmitted: (_) => onNameSubmitted(),
              ),
            ),
            DropdownButton<String>(
              value: MassiveEventStandaloneListQuery.coerceStatus(statusRaw),
              onChanged: (v) {
                if (v == null) return;
                onStatusChanged(v);
              },
              items:
                  MassiveEventStandaloneListQuery.allowedStatusCodes.map((
                    code,
                  ) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(labels[code] ?? code),
                    );
                  }).toList(),
            ),
            if (hasActiveFilters)
              IconButton(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear),
                tooltip: l10n.clearFilters,
              ),
            FilledButton.icon(
              onPressed: onSearchPressed,
              icon: const Icon(Icons.search),
              label: Text(l10n.search),
            ),
          ],
        ),
      ),
    );
  }
}

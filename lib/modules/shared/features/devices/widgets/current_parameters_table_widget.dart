import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

/// Tabla con los valores actuales (`confirmed`) de los parámetros del collar
/// LW001-BG PRO, comparados con el valor `desired` cuando aplica.
///
/// El backend va alimentando `RemoteConfigStatusModel.confirmed` a medida
/// que llegan uplinks de respuesta a Read parameters. Esta tabla muestra
/// la unión de claves de `confirmed ∪ desired` y resalta el estado de
/// cada parámetro: OK / Divergente / Sin lectura / Solo lectura.
class CurrentParametersTableWidget extends StatefulWidget {
  final RemoteConfigStatusModel? status;

  const CurrentParametersTableWidget({super.key, required this.status});

  @override
  State<CurrentParametersTableWidget> createState() =>
      _CurrentParametersTableWidgetState();
}

class _CurrentParametersTableWidgetState
    extends State<CurrentParametersTableWidget> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final status = widget.status;

    final confirmed = status?.confirmed ?? const <String, dynamic>{};
    final desired = status?.desired ?? const <String, dynamic>{};
    final divergent = (status?.divergent ?? const <String>[]).toSet();

    final allKeys = <String>{...confirmed.keys, ...desired.keys}.toList()
      ..sort();
    final filtered = _query.trim().isEmpty
        ? allKeys
        : allKeys
            .where((k) => k.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deviceRemoteConfig_currentValuesTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              status?.lastConfirmedAt == null
                  ? l10n.deviceRemoteConfig_currentValues_neverRead
                  : l10n.deviceRemoteConfig_currentValues_lastReadAt(
                      DateFormat.yMd().add_Hm().format(
                            status!.lastConfirmedAt!.toLocal(),
                          ),
                    ),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: l10n.deviceRemoteConfig_currentValues_searchHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            if (allKeys.isEmpty)
              _emptyHint(context, l10n)
            else if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(l10n.deviceRemoteConfig_currentValues_noMatches),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  headingRowHeight: 36,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 56,
                  columns: [
                    DataColumn(
                      label: Text(l10n.deviceRemoteConfig_currentValues_colParameter),
                    ),
                    DataColumn(
                      label: Text(l10n.deviceRemoteConfig_currentValues_colConfirmed),
                    ),
                    DataColumn(
                      label: Text(l10n.deviceRemoteConfig_currentValues_colDesired),
                    ),
                    DataColumn(
                      label: Text(l10n.deviceRemoteConfig_currentValues_colState),
                    ),
                  ],
                  rows: filtered.map((key) {
                    final confValue = confirmed[key];
                    final desValue = desired[key];
                    final state = _resolveState(
                      hasConfirmed: confirmed.containsKey(key),
                      hasDesired: desired.containsKey(key),
                      isDivergent: divergent.contains(key),
                    );
                    return DataRow(
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 240),
                            child: Text(
                              key,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(_valueCell(confValue, isMissing: !confirmed.containsKey(key))),
                        DataCell(_valueCell(desValue, isMissing: !desired.containsKey(key))),
                        DataCell(_stateChip(context, l10n, state)),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _valueCell(dynamic value, {required bool isMissing}) {
    if (isMissing) {
      return const Text('—', style: TextStyle(color: Colors.grey));
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Text(
        value == null ? 'null' : value.toString(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }

  _ParamState _resolveState({
    required bool hasConfirmed,
    required bool hasDesired,
    required bool isDivergent,
  }) {
    if (hasDesired && !hasConfirmed) return _ParamState.desiredOnly;
    if (!hasDesired && hasConfirmed) return _ParamState.confirmedOnly;
    if (isDivergent) return _ParamState.divergent;
    return _ParamState.ok;
  }

  Widget _stateChip(
    BuildContext context,
    AppLocalizations l10n,
    _ParamState state,
  ) {
    switch (state) {
      case _ParamState.ok:
        return _chip(context, l10n.deviceRemoteConfig_currentValues_state_ok,
            Colors.green);
      case _ParamState.divergent:
        return _chip(
            context,
            l10n.deviceRemoteConfig_currentValues_state_divergent,
            Colors.deepOrange);
      case _ParamState.desiredOnly:
        return _chip(
            context,
            l10n.deviceRemoteConfig_currentValues_state_pending,
            Colors.grey);
      case _ParamState.confirmedOnly:
        return _chip(
            context,
            l10n.deviceRemoteConfig_currentValues_state_readonly,
            Colors.blueGrey);
    }
  }

  Widget _chip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  Widget _emptyHint(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(l10n.deviceRemoteConfig_currentValues_emptyHint),
          ),
        ],
      ),
    );
  }
}

enum _ParamState { ok, divergent, desiredOnly, confirmedOnly }

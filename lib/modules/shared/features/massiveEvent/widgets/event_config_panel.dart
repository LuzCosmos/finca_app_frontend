import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_config.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_event.dart';
import 'event_detail_form.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'dart:convert';

class EventConfigPanel extends StatefulWidget {
  const EventConfigPanel({super.key});

  @override
  State<EventConfigPanel> createState() => _EventConfigPanelState();
}

class _EventConfigPanelState extends State<EventConfigPanel> {
  final List<SimpleEventConfig> _allDetails = [];

  List<SimpleEventConfig> get activeDetails =>
      _allDetails.where((e) => e.isActive).toList();

  List<SimpleEventConfig> get historyDetails => _allDetails;

  void _openAddEventDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const EventDetailForm(),
    );
    if (result != null) {
      final type = result['type'] ?? '';
      final name = (type == 'brand') ? result['brand'] : result['name'];

      if (_canAddDetail(type, name)) {
        final newConfig = SimpleEventConfig.create(
          name: name ?? '',
          type: EventType.values.firstWhere((e) => e.name == type),
          dataJson: result['dataJson'] ?? '',
        );

        // 👉 Añadimos al estado local para la UI
        setState(() {
          _allDetails.add(newConfig);
        });

        // 👉 Enviamos al Bloc para guardar en backend o sqlite
        context.read<MassiveEventBloc>().add(
          AddSimpleEventConfig(
            config: newConfig,
            massiveEventId: 'TODO-massive-event-id', // id local si es mobile
            idTenant: 'TODO-id-tenant',
          ),
        );
      }
    }
  }

  void _deactivateDetail(SimpleEventConfig detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: false);
      }
    });
  }

  void _reactivateDetail(SimpleEventConfig detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: true);
      }
    });

    final l10n = AppLocalizations.of(context)!;
    _showInfo(l10n.reactivatedInfo(detail.name));

    // 👉 también podrías reenviar al Bloc si quieres que se re-sincronice:
    // context.read<MassiveEventBloc>().add(
    //   AddSimpleEventConfig(
    //     config: detail.copyWith(isActive: true),
    //     massiveEventId: 'TODO-massive-event-id',
    //     idTenant: 'TODO-id-tenant',
    //   ),
    // );
  }

  bool _canAddDetail(String type, String? name) {
    final l10n = AppLocalizations.of(context)!;

    if (type == 'weight' || type == 'tracker' || type == 'eartag') {
      final idx = _allDetails.indexWhere(
        (d) => d.type == EventType.values.firstWhere((e) => e.name == type),
      );
      if (idx != -1) {
        final existing = _allDetails[idx];
        if (!existing.isActive) {
          _reactivateDetail(existing);
          return false;
        } else {
          _showError(l10n.onlyOneType(type));
          return false;
        }
      }
    }

    if (type == 'brand' && name != null && name.isNotEmpty) {
      final idx = _allDetails.indexWhere(
        (d) => d.type == 'brand' && d.name.toLowerCase() == name.toLowerCase(),
      );
      if (idx != -1) {
        final existing = _allDetails[idx];
        if (!existing.isActive) {
          _reactivateDetail(existing);
          return false;
        } else {
          _showError(l10n.brandAlreadyExists(name));
          return false;
        }
      }
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.eventConfigTitle,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: _openAddEventDialog,
            icon: const Icon(Icons.add),
            label: Text(l10n.addEventDetail),
          ),
          const SizedBox(height: 14),

          Text(
            l10n.activeDetails,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                activeDetails.isEmpty
                    ? Center(child: Text(l10n.noActiveDetails))
                    : ListView.builder(
                      itemCount: activeDetails.length,
                      itemBuilder: (context, index) {
                        final detail = activeDetails[index];
                        return Card(
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            title: Text(
                              detail.type == EventType.medication
                                  ? detail.dataJson != null
                                      ? detail.type.asText(context) +
                                          ': ' +
                                          jsonDecode(
                                            detail.dataJson!,
                                          )['medicationName']
                                      : detail.type.asText(context)
                                  : detail.type.asText(context),
                              style: const TextStyle(fontSize: 11),
                            ),
                            subtitle:
                                detail.type == EventType.medication &&
                                        detail.dataJson != null
                                    ? Text(
                                      _buildMedicationSubtitle(
                                        detail.dataJson!,
                                      ),
                                      style: const TextStyle(fontSize: 10),
                                    )
                                    : null,
                            trailing: IconButton(
                              icon: const Icon(
                                size: 15,
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _deactivateDetail(detail),
                              tooltip: l10n.deactivateTooltip,
                            ),
                          ),
                        );
                      },
                    ),
          ),

          const Divider(height: 32),

          Text(
            l10n.historyTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child:
                historyDetails.isEmpty
                    ? Center(child: Text(l10n.noHistory))
                    : ListView.builder(
                      itemCount: historyDetails.length,
                      itemBuilder: (context, index) {
                        final detail = historyDetails[index];
                        return ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          leading: Icon(
                            size: 15,
                            detail.isActive
                                ? Icons.check_circle
                                : Icons.history,
                            color: detail.isActive ? Colors.green : Colors.grey,
                          ),
                          title: Text(
                            style: const TextStyle(fontSize: 11),
                            detail.type == EventType.medication
                                ? detail.dataJson != null
                                    ? jsonDecode(
                                      detail.dataJson!,
                                    )['medicationName']
                                    : ''
                                : detail.type.asText(context),
                          ),
                          subtitle: Text(
                            '${l10n.addEventDetail}: ${detail.createdAt.toLocal()}',
                            style: const TextStyle(fontSize: 10),
                          ),
                          trailing:
                              detail.isActive
                                  ? null
                                  : IconButton(
                                    iconSize: 15,
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _reactivateDetail(detail),
                                    tooltip: l10n.reactivateTooltip,
                                  ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _buildMedicationSubtitle(String dataJson) {
    final l10n = AppLocalizations.of(context)!;
    final data = jsonDecode(dataJson);
    final route = data['route'] ?? '';
    final dosage = data['dosage'] ?? '';
    final lot = data['lot'] ?? '';

    // Une las partes no vacías con un espacio
    return [
      l10n.medicationRoute + ': ' + route,
      l10n.medicationDosage + ': ' + dosage,
      l10n.medicationLot + ': ' + lot,
    ].where((part) => part.toString().trim().isNotEmpty).join('; ');
  }
}

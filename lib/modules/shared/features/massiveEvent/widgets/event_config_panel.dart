import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'event_detail_form.dart';

class EventConfigPanel extends StatefulWidget {
  final String? idMassiveEvent;
  final ValueChanged<String> onMassiveEventCreated;

  const EventConfigPanel({
    super.key,
    this.idMassiveEvent,
    required this.onMassiveEventCreated,
  });

  @override
  State<EventConfigPanel> createState() => _EventConfigPanelState();
}

class _EventConfigPanelState extends State<EventConfigPanel> {
  final List<SimpleEventModel> _allDetails = [];
  String? idTenant;
  late String? _currentMassiveEventId;

  @override
  void initState() {
    super.initState();
    _currentMassiveEventId = widget.idMassiveEvent;
  }

  List<SimpleEventModel> get activeDetails =>
      _allDetails.where((e) => e.isActive).toList();

  List<SimpleEventModel> get historyDetails => _allDetails;

  void _openAddEventDialog() async {
    if (idTenant == null || idTenant!.isEmpty) {
      idTenant = await SessionService.getIdTenant();
    }
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const EventDetailForm(),
    );
    if (result != null) {
      final type = result['type'] ?? '';
      final name = result['name'];
      if (_canAddDetail(type, name)) {
        var newSimpleEvent = SimpleEventModel.create(
          name: name ?? '',
          type: SimpleEventType.values.firstWhere((e) => e.name == type),
          data: result['data'] ?? null,
          idMassiveEvent: _currentMassiveEventId,
        );
        final bloc = context.read<MassiveEventBloc>();
        final dataSource = bloc.dataSource;
        try {
          if (_currentMassiveEventId == null) {
            var masEv = MassiveEventModel.create(
              eventDate: DateTime.now(),
              simpleEvents: [newSimpleEvent],
              idTenant: idTenant,
            );
            final newMassiveEvent = await dataSource.saveMassiveEvent(
              massiveEvent: masEv,
              idTenant: idTenant!,
            );
            setState(() {
              _currentMassiveEventId = newMassiveEvent.id;
            });
            newSimpleEvent = newMassiveEvent.simpleEvents.first;
            setState(() {
              _currentMassiveEventId = newMassiveEvent.id;
            });
            widget.onMassiveEventCreated(newMassiveEvent.id);
          } else {
            newSimpleEvent = await dataSource.saveSimpleEvent(
              simpleEvent: newSimpleEvent,
              idTenant: idTenant!,
            );
          }
          if (PlatformService().isWeb()) {
            setState(() {
              _allDetails.add(newSimpleEvent);
            });
          }
        } on ApiException catch (e) {
          if (mounted) {
            String? error = ApiExceptionCode.values
                .firstWhere((el) => el.name == e.code)
                .asText(context);
            if (e.code == ApiExceptionCode.serverConnectionError.name &&
                PlatformService().isMobile()) {
              error = null;
            }
            if (error != null) {
              _showError(error);
            }
          }
        } catch (e) {
          if (mounted) {
            _showError(AppLocalizations.of(context)!.error_generic);
          }
        } finally {
          if (PlatformService().isMobile()) {
            setState(() {
              _allDetails.add(newSimpleEvent);
            });
          }
        }
      }
    }
  }

  void _deactivateDetail(SimpleEventModel detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: false);
      }
    });
  }

  void _reactivateDetail(SimpleEventModel detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: true);
      }
    });

    final l10n = AppLocalizations.of(context)!;
    _showInfo(l10n.reactivatedInfo(detail.type.asText(context)));
  }

  bool _canAddDetail(String type, String? name) {
    final l10n = AppLocalizations.of(context)!;
    if (type == SimpleEventType.weight.name ||
        type == SimpleEventType.tracker.name ||
        type == SimpleEventType.eartag.name ||
        type == SimpleEventType.castration.name) {
      final idx = _allDetails.indexWhere(
        (d) =>
            d.type == SimpleEventType.values.firstWhere((e) => e.name == type),
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
    if (type == SimpleEventType.brand.name && name != null && name.isNotEmpty) {
      final idx = _allDetails.indexWhere((d) {
        if (d.type != SimpleEventType.brand) return false;
        final dynamic rawData = jsonDecode(d.data!);
        final Map<String, dynamic> decoded =
            rawData is String ? jsonDecode(rawData) : rawData;
        return decoded['brandName'].toLowerCase() == name.toLowerCase();
      });
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
                              detail.type == SimpleEventType.medication
                                  ? detail.data != null
                                      ? detail.type.asText(context) +
                                          ': ' +
                                          jsonDecode(
                                            detail.data!,
                                          )['medicationName']
                                      : detail.type.asText(context)
                                  : detail.type.asText(context),
                              style: const TextStyle(fontSize: 11),
                            ),
                            subtitle:
                                detail.type == SimpleEventType.medication &&
                                        detail.data != null
                                    ? Text(
                                      _buildMedicationSubtitle(detail.data!),
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
                            detail.type == SimpleEventType.medication
                                ? detail.data != null
                                    ? jsonDecode(detail.data!)['medicationName']
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

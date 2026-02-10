import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'event_detail_form.dart';

class EventConfigPanel extends StatefulWidget {
  final bool isWide;
  final DateTime? eventDate;
  final String? idMassiveEvent;
  final List<SimpleEventModel> simpleEvents;
  final ValueChanged<String> onMassiveEventCreated;
  final ValueChanged<String?> showError;
  final ValueChanged<String?> showSuccess;
  final ValueChanged<String?> showInfo;
  final ValueChanged<List<SimpleEventModel>> onEventsChanged;

  const EventConfigPanel({
    super.key,
    required this.isWide,
    required this.eventDate,
    this.idMassiveEvent,
    required this.simpleEvents,
    required this.onMassiveEventCreated,
    required this.showError,
    required this.showSuccess,
    required this.showInfo,
    required this.onEventsChanged,
  });

  @override
  State<EventConfigPanel> createState() => _EventConfigPanelState();
}

class _EventConfigPanelState extends State<EventConfigPanel> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  List<SimpleEventModel> get activeDetails {
    final list = widget.simpleEvents.where((e) => e.isActive).toList();
    list.sort(
      (a, b) => a.type
          .asText(context)
          .toLowerCase()
          .compareTo(b.type.asText(context).toLowerCase()),
    );
    return list;
  }

  List<SimpleEventModel> get inactiveDetails {
    final list = widget.simpleEvents.where((e) => (!e.isActive)).toList();
    list.sort(
      (a, b) => a.type
          .asText(context)
          .toLowerCase()
          .compareTo(b.type.asText(context).toLowerCase()),
    );
    return list;
  }

  void _openAddEventDialog() async {
    if (mounted) {
      widget.showError(null);
      final massiveBloc = context.read<MassiveEventBloc>();
      final activeEventTypes = activeDetails.map((e) => e.type).toList();
      if (widget.key != null &&
          widget.key is ValueKey<String> &&
          (widget.key as ValueKey<String>).value.contains(
            'eventConfigPanel_reception',
          )) {
        activeEventTypes.add(SimpleEventType.weight);
        activeEventTypes.add(SimpleEventType.tracker);
        activeEventTypes.add(SimpleEventType.eartag);
      }
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder:
            (outerContext) => BlocProvider.value(
              value: massiveBloc,
              child: EventDetailForm(activeEventTypes: activeEventTypes),
            ),
      );
      if (result != null) {
        final type = result['type'];
        final name = result['name'];
        if (_canAddDetail(type, name)) {
          var newSimpleEvent = SimpleEventModel.create(
            name: name ?? '',
            type: SimpleEventType.values.firstWhere((e) => e.name == type),
            data: result['data'],
            idMassiveEvent: widget.idMassiveEvent,
          );
          try {
            final dataSource = context.read<MassiveEventBloc>().dataSource;
            if (widget.idMassiveEvent == null) {
              var masEv = MassiveEventModel.create(
                eventDate: widget.eventDate!,
                simpleEvents: [newSimpleEvent],
              );
              final newMassiveEvent = await dataSource.saveMassiveEvent(
                massiveEvent: masEv,
              );
              newSimpleEvent = newMassiveEvent.simpleEvents.first;
              widget.onMassiveEventCreated(newMassiveEvent.id);
            } else {
              newSimpleEvent = await dataSource.saveSimpleEvent(
                simpleEvent: newSimpleEvent,
              );
            }
            final allDetails = [...widget.simpleEvents, newSimpleEvent];
            widget.onEventsChanged(allDetails);
          } on ApiException catch (e) {
            if (mounted) {
              String? error = ApiExceptionCode.values
                  .firstWhere((el) => el.name == e.code)
                  .asText(context);
              if (error.isNotEmpty) {
                widget.showError(error);
              }
            }
          } catch (e) {
            if (mounted) {
              widget.showError(AppLocalizations.of(context)!.error_generic);
            }
          }
        }
      }
    }
  }

  Future<void> _deactivateDetail(SimpleEventModel detail) async {
    final allDetails = widget.simpleEvents;
    final idx = allDetails.indexWhere((e) => e.id == detail.id);
    if (idx != -1) {
      allDetails[idx] = allDetails[idx].copyWith(isActive: false);
      widget.onEventsChanged(allDetails);
      var endpoint = 'simple-events';
      if (widget.key != null &&
          widget.key is ValueKey<String> &&
          (widget.key as ValueKey<String>).value.contains(
            'eventConfigPanel_reception',
          )) {
        endpoint = 'purchase-receptions/update-simple-event';
      }
      await context.read<MassiveEventBloc>().dataSource.updateSimpleEvent(
        simpleEvent: allDetails[idx],
        endpoint: endpoint,
      );
    }
  }

  Future<void> _reactivateDetail(SimpleEventModel detail) async {
    final allDetails = widget.simpleEvents;
    final idx = allDetails.indexWhere((e) => e.id == detail.id);
    if (idx != -1) {
      allDetails[idx] = allDetails[idx].copyWith(isActive: true);
      widget.onEventsChanged(allDetails);
      final l10n = AppLocalizations.of(context)!;
      widget.showInfo(l10n.reactivatedInfo(detail.type.asText(context)));
      var endpoint = 'simple-events';
      if (widget.key != null &&
          widget.key is ValueKey<String> &&
          (widget.key as ValueKey<String>).value.contains(
            'eventConfigPanel_reception',
          )) {
        endpoint = 'purchase-receptions/update-simple-event';
      }
      await context.read<MassiveEventBloc>().dataSource.updateSimpleEvent(
        simpleEvent: allDetails[idx],
        endpoint: endpoint,
      );
    }
  }

  bool _canAddDetail(String type, String? name) {
    final l10n = AppLocalizations.of(context)!;
    if (type == SimpleEventType.weight.name ||
        type == SimpleEventType.tracker.name ||
        type == SimpleEventType.eartag.name ||
        type == SimpleEventType.castration.name) {
      final idx = widget.simpleEvents.indexWhere(
        (d) =>
            d.type == SimpleEventType.values.firstWhere((e) => e.name == type),
      );
      if (idx != -1) {
        final existing = widget.simpleEvents[idx];
        if (!existing.isActive) {
          _reactivateDetail(existing);
          return false;
        } else {
          widget.showError(
            l10n.onlyOneType(
              SimpleEventType.values
                  .firstWhere((e) => e.name == type)
                  .asText(context),
            ),
          );
          return false;
        }
      }
    }
    if (type == SimpleEventType.brand.name && name != null && name.isNotEmpty) {
      final idx = widget.simpleEvents.indexWhere((d) {
        if (d.type != SimpleEventType.brand) return false;
        final dynamic rawData = jsonDecode(d.data!);
        final Map<String, dynamic> decoded =
            rawData is String ? jsonDecode(rawData) : rawData;
        return decoded['brandName'].toLowerCase() == name.toLowerCase();
      });
      if (idx != -1) {
        final existing = widget.simpleEvents[idx];
        if (!existing.isActive) {
          _reactivateDetail(existing);
          return false;
        } else {
          widget.showError(l10n.brandAlreadyExists(name));
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: widget.isWide ? null : 360,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.eventConfigTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ElevatedButton.icon(
            onPressed: _openAddEventDialog,
            icon: const Icon(Icons.add),
            label: Text(l10n.addEventDetail),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
                // 70% - activeDetails
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.activeDetails,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child:
                            activeDetails.isEmpty
                                ? Center(child: Text(l10n.noActiveDetails))
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 2,
                                  ),
                                  itemCount: activeDetails.length,
                                  itemBuilder: (context, index) {
                                    final detail = activeDetails[index];
                                    final titleText = _buildTitle(
                                      detail,
                                      context,
                                    );
                                    final subtitleText = _buildSubtitle(detail);

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 1,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 6,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    titleText,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  if (subtitleText != null)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 2,
                                                          ),
                                                      child: Text(
                                                        subtitleText,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 15,
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () =>
                                                      _deactivateDetail(detail),
                                              tooltip: l10n.deactivateTooltip,
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
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

                const Divider(height: 8),
                // 30% - inactiveDetails
                Expanded(
                  flex: widget.isWide ? 4 : (inactiveDetails.isEmpty ? 1 : 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.inactiveTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child:
                            inactiveDetails.isEmpty
                                ? Center(child: Text(l10n.noInactive))
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 2,
                                  ),
                                  itemCount: inactiveDetails.length,
                                  itemBuilder: (context, index) {
                                    final detail = inactiveDetails[index];
                                    final titleText = _buildTitle(
                                      detail,
                                      context,
                                    );
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 6,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              detail.isActive
                                                  ? Icons.check_circle
                                                  : Icons.history,
                                              size: 15,
                                              color:
                                                  detail.isActive
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                titleText,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (!detail.isActive)
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.blue,
                                                ),
                                                onPressed:
                                                    () => _reactivateDetail(
                                                      detail,
                                                    ),
                                                tooltip: l10n.reactivateTooltip,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildTitle(SimpleEventModel detail, BuildContext context) {
    final data = detail.data != null ? jsonDecode(detail.data!) : {};
    switch (detail.type) {
      case SimpleEventType.medication:
        return '${detail.type.asText(context)}: ${data['medicationName'] ?? ''}';
      case SimpleEventType.brand:
        return '${detail.type.asText(context)}: ${data['brandName'] ?? ''}';
      default:
        return detail.type.asText(context);
    }
  }

  String? _buildSubtitle(SimpleEventModel detail) {
    if (detail.type != SimpleEventType.medication || detail.data == null) {
      return null;
    } else if (detail.type == SimpleEventType.medication) {
      final l10n = AppLocalizations.of(context)!;
      final data = jsonDecode(detail.data!);
      final route = data['route'] ?? '';
      final dosage = data['dosage'] ?? '';
      final lot = data['lot'] ?? '';
      return [
        '${l10n.medicationDosage}: $dosage',
        '${l10n.medicationRoute}: $route',
        '${l10n.medicationLot}: $lot',
      ].where((part) => part.toString().trim().isNotEmpty).join('; ');
    }
    return null;
  }
}

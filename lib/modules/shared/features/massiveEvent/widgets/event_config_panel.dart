import 'dart:convert';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'event_detail_form.dart';

class EventConfigPanel extends StatefulWidget {
  final String? idMassiveEvent;
  final bool isWide;
  final ValueChanged<String> onMassiveEventCreated;
  final ValueChanged<String?> showError;
  final ValueChanged<String?> showSuccess;
  final ValueChanged<String?> showInfo;
  final ValueChanged<List<SimpleEventModel>> onEventsChanged;

  const EventConfigPanel({
    super.key,
    this.idMassiveEvent,
    required this.isWide,
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
  final List<SimpleEventModel> _allDetails = [];
  String? idTenant;
  late String? _currentMassiveEventId;
  final List<BrandModel> _brands = [];

  @override
  void initState() {
    super.initState();
    _currentMassiveEventId = widget.idMassiveEvent;
    Future.microtask(() async {
      try {
        final brands =
            await context.read<MassiveEventBloc>().dataSource.getAllBrands();
        setState(() {
          for (var brand in brands) {
            _brands.add(brand);
          }
        });
      } on ApiException catch (e) {
        String? error = ApiExceptionCode.values
            .firstWhere((el) => el.name == e.code)
            .asText(context);
        widget.showError(error);
      } catch (e) {
        final l10n = AppLocalizations.of(context)!;
        widget.showError(l10n.error_generic);
      }
    });
  }

  List<SimpleEventModel> get activeDetails {
    final list = _allDetails.where((e) => e.isActive).toList();
    list.sort(
      (a, b) => a.type
          .asText(context)
          .toLowerCase()
          .compareTo(b.type.asText(context).toLowerCase()),
    );
    return list;
  }

  List<SimpleEventModel> get deactiveDetails {
    final list = _allDetails.where((e) => (!e.isActive)).toList();
    list.sort(
      (a, b) => a.type
          .asText(context)
          .toLowerCase()
          .compareTo(b.type.asText(context).toLowerCase()),
    );
    return list;
  }

  List<SimpleEventModel> get historyDetails => _allDetails;

  void _openAddEventDialog() async {
    if (idTenant == null || idTenant!.isEmpty) {
      idTenant = await SessionService.getIdTenant();
    }
    if (mounted) {
      final massiveBloc = context.read<MassiveEventBloc>();
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder:
            (outerContext) => BlocProvider.value(
              value: massiveBloc,
              child: const EventDetailForm(),
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
            idMassiveEvent: _currentMassiveEventId,
          );
          try {
            final dataSource = context.read<MassiveEventBloc>().dataSource;
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
            setState(() {
              _allDetails.add(newSimpleEvent);
            });
            widget.onEventsChanged(_allDetails);
          } on ApiException catch (e) {
            if (mounted) {
              String? error = ApiExceptionCode.values
                  .firstWhere((el) => el.name == e.code)
                  .asText(context);
              if (error != null) {
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

  void _deactivateDetail(SimpleEventModel detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: false);
      }
    });
    widget.onEventsChanged(_allDetails);
  }

  void _reactivateDetail(SimpleEventModel detail) {
    setState(() {
      final idx = _allDetails.indexWhere((e) => e.id == detail.id);
      if (idx != -1) {
        _allDetails[idx] = _allDetails[idx].copyWith(isActive: true);
      }
    });
    widget.onEventsChanged(_allDetails);
    final l10n = AppLocalizations.of(context)!;
    widget.showInfo(l10n.reactivatedInfo(detail.type.asText(context)));
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
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.eventConfigTitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                          fontSize: 12,
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
                                        borderRadius: BorderRadius.circular(2),
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
                                                      fontSize: 11,
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
                                                          fontSize: 10,
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

                const Divider(height: 16),
                // 30% - deactiveDetails (history)
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.historyTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child:
                            deactiveDetails.isEmpty
                                ? Center(child: Text(l10n.noHistory))
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 2,
                                  ),
                                  itemCount: deactiveDetails.length,
                                  itemBuilder: (context, index) {
                                    final detail = deactiveDetails[index];
                                    final titleText = _buildTitle(
                                      detail,
                                      context,
                                    );
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
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
                                                  fontSize: 11,
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
    }
    return _buildMedicationSubtitle(detail.data!);
  }

  String _buildMedicationSubtitle(String dataJson) {
    final l10n = AppLocalizations.of(context)!;
    final data = jsonDecode(dataJson);
    final route = data['route'] ?? '';
    final dosage = data['dosage'] ?? '';
    final lot = data['lot'] ?? '';
    return [
      '${l10n.medicationDosage}: $dosage',
      '${l10n.medicationRoute}: $route',
      '${l10n.medicationLot}: $lot',
    ].where((part) => part.toString().trim().isNotEmpty).join('; ');
  }
}

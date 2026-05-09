import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/bootstrap/massive_event_sync_status.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_sync_listener.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/event_config_panel.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/animal_entry_form.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/processed_animals_table.dart';

class MassiveEventPage extends StatefulWidget {
  const MassiveEventPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<MassiveEventPage> createState() => _MassiveEventPageState();
}

class _MassiveEventPageState extends State<MassiveEventPage> {
  String? idMassiveEvent;
  DateTime _selectedDate = DateTime.now();
  List<SimpleEventModel> simpleEvents = [];
  Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap = {};
  String? _globalErrorMessage;
  String? _globalSuccessMessage;
  String? _globalInfoMessage;
  bool _massivePendingSync = false;

  Future<void> _refreshMassivePendingSync() async {
    if (kIsWeb || idMassiveEvent == null) return;
    final pending = await isMassiveEventPendingSync(idMassiveEvent!);
    if (mounted) {
      setState(() {
        _massivePendingSync = pending;
      });
    }
  }

  void setidMassiveEvent(String id) {
    setState(() {
      idMassiveEvent = id;
    });
  }

  @override
  void dispose() {
    idMassiveEvent = null;
    _selectedDate = DateTime.now();
    simpleEvents.clear();
    animalEventsAppliedMap.clear();
    _globalErrorMessage = null;
    _globalSuccessMessage = null;
    _globalInfoMessage = null;
    super.dispose();
  }

  void setEvents(List<SimpleEventModel> events) {
    setState(() {
      simpleEvents = events;
    });
  }

  void setAnimalSimpleEventsAppliedMap(
    Map<String, AnimalSimpleEventTableRowModel> map,
  ) {
    setState(() {
      animalEventsAppliedMap = map;
    });
  }

  List<SimpleEventModel> get activeSimpleEvents =>
      simpleEvents.where((e) => e.isActive).toList();

  void _selectDate() async {
    _globalErrorMessage = null;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void setGlobalError(String? msg) {
    setState(() {
      _globalErrorMessage = msg;
      _globalSuccessMessage = null;
      _globalInfoMessage = null;
    });
  }

  void setGlobalSuccess(String? msg) {
    setState(() {
      _globalSuccessMessage = msg;
      _globalErrorMessage = null;
      _globalInfoMessage = null;
    });
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _globalSuccessMessage = null;
        });
      }
    });
  }

  void _closeMassiveEvent() async {
    final l10n = AppLocalizations.of(context)!;
    setGlobalError(null);
    try {
      if (idMassiveEvent == null) {
        return;
      }
      if (animalEventsAppliedMap.isEmpty) {
        setGlobalError(l10n.error_noSimpleEventsApplied);
        return;
      }
      context.read<MassiveEventBloc>().dataSource.closeMassiveEvent(
        idMassiveEvent: idMassiveEvent!,
      );
      setState(() {
        _globalSuccessMessage = l10n.event_finishSuccess;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _globalSuccessMessage = null;
          });
          context.go('/home');
        }
      });
    } on ApiException catch (e) {
      if (mounted) {
        String? error = ApiExceptionCode.fromString(e.code).asText(context);
        if (e.code == ApiExceptionCode.unprocessableEntity.name) {
          if (e.message.contains('closed')) {
            error = l10n.error_massiveEventAlreadyClosed;
          } else {
            error = l10n.error_noSimpleEventsApplied;
          }
        }
        setGlobalError(error);
      }
    } catch (e) {
      setGlobalError(l10n.error_generic);
    }
  }

  void setGlobalInfo(String? msg) {
    setState(() {
      _globalInfoMessage = msg;
      _globalSuccessMessage = null;
      _globalErrorMessage = null;
    });
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _globalInfoMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width > 500;
    final eventConfigPanel = EventConfigPanel(
      key: const ValueKey('eventConfigPanel_massiveEvent'),
      isWide: isWide,
      eventDate: _selectedDate,
      simpleEvents: simpleEvents,
      idMassiveEvent: idMassiveEvent,
      onMassiveEventCreated: (newId) {
        setidMassiveEvent(newId);
        if (!kIsWeb) {
          setState(() => _massivePendingSync = true);
        }
      },
      showError: setGlobalError,
      showSuccess: setGlobalSuccess,
      showInfo: setGlobalInfo,
      onEventsChanged: setEvents,
    );
    final animalEntryForm = AnimalEntryForm(
      key: const ValueKey('animalEntryForm'),
      activeEvents: activeSimpleEvents,
      idMassiveEvent: idMassiveEvent,
      animalEventsAppliedMap: animalEventsAppliedMap,
      onApply: (appliedEventsMap) {
        setAnimalSimpleEventsAppliedMap(appliedEventsMap);
      },
      showError: setGlobalError,
      showSuccess: setGlobalSuccess,
      showInfo: setGlobalInfo,
      onMassiveBranchSyncedFromServer:
          !kIsWeb
              ? (newId, simples) {
                setidMassiveEvent(newId);
                setEvents(simples);
                _refreshMassivePendingSync();
              }
              : null,
    );
    final processedAnimalsTable = ProcessedAnimalsTable(
      key: const ValueKey('processedAnimalsTable'),
      animalEventsAppliedMap: animalEventsAppliedMap,
      simpleEventTypes: simpleEvents.map((e) => e.type).toList(),
      isWide: isWide,
    );

    Widget page = BlocListener<MassiveEventBloc, MassiveEventState>(
      listener: (context, state) {
        if (state is MassiveEventSuccess) {
          String msg =
              state.messageKey == 'simpleEventAdded'
                  ? l10n.simpleEventAdded
                  : state.messageKey;
          setGlobalSuccess(msg);
          if (!kIsWeb) {
            _refreshMassivePendingSync();
          }
        }
        if (state is MassiveEventError) {
          String msg =
              state.messageKey == 'simpleEventError'
                  ? l10n.simpleEventError
                  : state.messageKey;
          setGlobalError(msg);
        }
      },
      child: FincaScaffold(
        title: l10n.massiveEvent,
        embedded: widget.embedded,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_globalErrorMessage != null)
              MessageBanner.error(_globalErrorMessage!),
            if (_globalSuccessMessage != null)
              MessageBanner.success(_globalSuccessMessage!),
            if (_globalInfoMessage != null)
              MessageBanner.info(_globalInfoMessage!),
            if (!kIsWeb &&
                idMassiveEvent != null &&
                _massivePendingSync)
              MessageBanner.info(l10n.massiveEventPendingSync),

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 3.0,
              ),
              child: Row(
                children: [
                  // Parte izquierda (textos y botón de fecha)
                  Expanded(
                    child: Row(
                      children: [
                        Text(l10n.dateSomething(l10n.event)),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                          ),
                          onPressed:
                              idMassiveEvent == null ? _selectDate : null,
                        ),
                      ],
                    ),
                  ),

                  // Parte derecha (botón de finalizar)
                  if (idMassiveEvent != null)
                    ElevatedButton.icon(
                      onPressed:
                          (idMassiveEvent == null ||
                                  animalEventsAppliedMap.isEmpty)
                              ? null
                              : _closeMassiveEvent,
                      icon: const Icon(Icons.task_rounded),
                      label: Text(l10n.finish),
                    ),
                ],
              ),
            ),
            Expanded(
              child:
                  isWide
                      ? Row(
                        children: [
                          Expanded(flex: 1, child: eventConfigPanel),
                          const VerticalDivider(width: 1),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                animalEntryForm,
                                const SizedBox(height: 16),
                                Expanded(child: processedAnimalsTable),
                              ],
                            ),
                          ),
                        ],
                      )
                      : ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          eventConfigPanel,
                          const Divider(height: 1),
                          animalEntryForm,
                          const SizedBox(height: 16),
                          processedAnimalsTable,
                        ],
                      ),
            ),
          ],
        ),
      ),
    );

    page = wrapMassiveEventPageSyncListener(
      child: page,
      onSyncSuccess: _refreshMassivePendingSync,
    );

    return page;
  }
}

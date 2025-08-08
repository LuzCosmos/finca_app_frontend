import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/event_config_panel.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/animal_entry_form.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/processed_animals_table.dart';

class MassiveEventPage extends StatefulWidget {
  const MassiveEventPage({super.key});

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

  void setidMassiveEvent(String id) {
    setState(() {
      idMassiveEvent = id;
    });
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
      key: const ValueKey('eventConfigPanel'),
      isWide: isWide,
      simpleEvents: simpleEvents,
      idMassiveEvent: idMassiveEvent,
      onMassiveEventCreated: (newId) {
        setidMassiveEvent(newId);
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
    );
    final processedAnimalsTable = ProcessedAnimalsTable(
      key: const ValueKey('processedAnimalsTable'),
      animalEventsAppliedMap: animalEventsAppliedMap,
    );

    return BlocListener<MassiveEventBloc, MassiveEventState>(
      listener: (context, state) {
        if (state is MassiveEventSuccess) {
          String msg =
              state.messageKey == 'simpleEventAdded'
                  ? l10n.simpleEventAdded
                  : state.messageKey;
          setGlobalSuccess(msg);
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
        title: l10n.home_massiveEvent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_globalErrorMessage != null)
              MessageBanner.error(_globalErrorMessage!),
            if (_globalSuccessMessage != null)
              MessageBanner.success(_globalSuccessMessage!),
            if (_globalInfoMessage != null)
              MessageBanner.info(_globalInfoMessage!),
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
                      : SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                eventConfigPanel,
                                const Divider(height: 1),
                                animalEntryForm,
                                const SizedBox(height: 16),
                                // Puedes poner aquí el processedAnimalsTable sin Expanded
                                processedAnimalsTable,
                              ],
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';

import '../widgets/event_config_panel.dart';
import '../widgets/animal_entry_form.dart';
import '../widgets/processed_animals_table.dart';

class MassiveEventPage extends StatefulWidget {
  const MassiveEventPage({super.key});

  @override
  State<MassiveEventPage> createState() => _MassiveEventPageState();
}

class _MassiveEventPageState extends State<MassiveEventPage> {
  String? idMassiveEvent;
  DateTime _selectedDate = DateTime.now();
  List<SimpleEventModel> events = [];
  String? _globalErrorMessage;
  String? _globalSuccessMessage;

  void setidMassiveEvent(String id) {
    setState(() {
      idMassiveEvent = id;
    });
  }

  void setEvents(List<SimpleEventModel> events) {
    setState(() {
      this.events = events;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width > 800;

    return BlocListener<MassiveEventBloc, MassiveEventState>(
      listener: (context, state) {
        if (state is MassiveEventSuccess) {
          String msg =
              state.messageKey == 'simpleEventAdded'
                  ? l10n.simpleEventAdded
                  : state.messageKey;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
        if (state is MassiveEventError) {
          String msg =
              state.messageKey == 'simpleEventError'
                  ? l10n.simpleEventError
                  : state.messageKey;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
        if (_globalErrorMessage != null)
          MessageBanner.error(_globalErrorMessage!);
        if (_globalSuccessMessage != null)
          MessageBanner.success(_globalSuccessMessage!);
      },

      child: FincaScaffold(
        title: l10n.home_massiveEvent,
        body:
            isWide
                ? Row(
                  children: [
                    if (_globalErrorMessage != null)
                      MessageBanner.error(_globalErrorMessage!),
                    if (_globalSuccessMessage != null)
                      MessageBanner.success(_globalSuccessMessage!),

                    Expanded(
                      flex: 2,
                      child: EventConfigPanel(
                        idMassiveEvent: idMassiveEvent,
                        onMassiveEventCreated: (newId) {
                          setidMassiveEvent(newId);
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          AnimalEntryForm(),
                          const SizedBox(height: 16),
                          Expanded(child: ProcessedAnimalsTable()),
                        ],
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    EventConfigPanel(
                      idMassiveEvent: idMassiveEvent,
                      onMassiveEventCreated: (newId) {
                        setidMassiveEvent(newId);
                      },
                    ),
                    const Divider(height: 1),
                    AnimalEntryForm(),
                    const SizedBox(height: 16),
                    Expanded(child: ProcessedAnimalsTable()),
                  ],
                ),
      ),
    );
  }
}

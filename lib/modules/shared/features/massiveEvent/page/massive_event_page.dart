import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

import '../widgets/event_config_panel.dart';
import '../widgets/animal_entry_form.dart';
import '../widgets/processed_animals_table.dart';

class MassiveEventPage extends StatelessWidget {
  const MassiveEventPage({super.key});

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
      },
      child: FincaScaffold(
        title: l10n.home_massiveEvent,
        body:
            isWide
                ? Row(
                  children: [
                    Expanded(flex: 2, child: EventConfigPanel()),
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
                    EventConfigPanel(),
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

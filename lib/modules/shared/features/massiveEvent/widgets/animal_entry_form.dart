import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/material.dart';

class AnimalEntryForm extends StatefulWidget {
  final List<SimpleEventModel> activeEvents;

  const AnimalEntryForm({super.key, required this.activeEvents});

  @override
  State<AnimalEntryForm> createState() => _AnimalEntryFormState();
}

class _AnimalEntryFormState extends State<AnimalEntryForm> {
  final TextEditingController _animalNumberController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _trackerController = TextEditingController();
  final TextEditingController _eartagController = TextEditingController();

  late Set<SimpleEventType> _activeTypes;

  @override
  void initState() {
    super.initState();
    _activeTypes = widget.activeEvents.map((e) => e.type).toSet();
  }

  @override
  void didUpdateWidget(covariant AnimalEntryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeEvents != widget.activeEvents) {
      setState(() {
        _activeTypes = widget.activeEvents.map((e) => e.type).toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addAnimalTitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Primera fila: Número de animal + Peso
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _animalNumberController,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      labelText: l10n.animalNumberLabel,
                      labelStyle: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_activeTypes.contains(SimpleEventType.weight))
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        labelText: l10n.weightLabel,
                        labelStyle: const TextStyle(fontSize: 9),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),

            // Segunda fila: Tracker + Eartag
            Row(
              children: [
                if (_activeTypes.contains(SimpleEventType.tracker))
                  Expanded(
                    child: TextField(
                      controller: _trackerController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        labelText: l10n.trackerLabel,
                        labelStyle: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                  ),
                if (_activeTypes.contains(SimpleEventType.tracker) &&
                    _activeTypes.contains(SimpleEventType.eartag))
                  const SizedBox(width: 12),
                if (_activeTypes.contains(SimpleEventType.eartag))
                  Expanded(
                    child: TextField(
                      controller: _eartagController,
                      style: const TextStyle(fontSize: 12), // Texto ingresado
                      decoration: InputDecoration(
                        isDense: true, // Hace el campo más compacto
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ), // Controla la altura
                        labelText: l10n.eartagLabel,
                        labelStyle: const TextStyle(
                          fontSize: 11.5,
                        ), // Label cuando flota abajo
                        floatingLabelStyle: const TextStyle(
                          fontSize: 9,
                        ), // Label cuando flota arriba
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                // TODO: aplicar datos y guardar local
              },
              icon: const Icon(Icons.save),
              label: Text(l10n.applyButton),
            ),
          ],
        ),
      ),
    );
  }
}

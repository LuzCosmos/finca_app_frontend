import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AnimalEntryForm extends StatefulWidget {
  const AnimalEntryForm({super.key});

  @override
  State<AnimalEntryForm> createState() => _AnimalEntryFormState();
}

class _AnimalEntryFormState extends State<AnimalEntryForm> {
  final TextEditingController _animalNumberController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _trackerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addAnimalTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _animalNumberController,
              decoration: InputDecoration(labelText: l10n.animalNumberLabel),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: l10n.weightLabel),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _trackerController,
              decoration: InputDecoration(labelText: l10n.trackerLabel),
            ),
            const SizedBox(height: 16),
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

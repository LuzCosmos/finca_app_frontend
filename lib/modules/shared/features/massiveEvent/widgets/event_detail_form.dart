import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EventDetailForm extends StatefulWidget {
  const EventDetailForm({super.key});

  @override
  State<EventDetailForm> createState() => _EventDetailFormState();
}

class _EventDetailFormState extends State<EventDetailForm> {
  String selectedType = 'weight';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  String? selectedBrand;

  final List<String> existingBrands = ['Las Garzas', 'Brand X', 'Brand Y'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.addEventDetail),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              onChanged:
                  (value) => setState(() => selectedType = value ?? 'weight'),
              items: [
                DropdownMenuItem(
                  value: EventType.weight.name,
                  child: Text(EventType.weight.asText(context)),
                ),
                DropdownMenuItem(
                  value: EventType.castration.name,
                  child: Text(EventType.castration.asText(context)),
                ),
                DropdownMenuItem(
                  value: EventType.tracker.name,
                  child: Text(EventType.tracker.asText(context)),
                ),
                DropdownMenuItem(
                  value: EventType.eartag.name,
                  child: Text(EventType.eartag.asText(context)),
                ),
                DropdownMenuItem(
                  value: EventType.medication.name,
                  child: Text(EventType.medication.asText(context)),
                ),
                DropdownMenuItem(
                  value: EventType.brand.name,
                  child: Text(EventType.brand.asText(context)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Campos específicos
            if (selectedType == 'medication') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.medicationName),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dosageController,
                decoration: InputDecoration(labelText: l10n.medicationDosage),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _routeController,
                decoration: InputDecoration(labelText: l10n.medicationRoute),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _lotController,
                decoration: InputDecoration(labelText: l10n.medicationLot),
              ),
            ],

            if (selectedType == EventType.brand.name) ...[
              DropdownButtonFormField<String>(
                value: selectedBrand,
                onChanged: (value) => setState(() => selectedBrand = value),
                hint: Text(l10n.selectBrand),
                items:
                    existingBrands
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await showDialog<Map<String, String>>(
                    context: context,
                    builder: (context) => _CreateBrandDialog(),
                  );
                  if (result != null) {
                    setState(() {
                      existingBrands.add(result['name']!);
                      selectedBrand = result['name'];
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.createNewBrand),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final Map<String, String> data = {'type': selectedType};
            if (selectedType == EventType.medication.name) {
              data['name'] = _nameController.text;
              data['dataJson'] = jsonEncode({
                'medicationName': _nameController.text,
                'route': _routeController.text,
                'dosage': _dosageController.text,
                'lot': _lotController.text,
              });
            } else if (selectedType == EventType.brand.name) {
              data['name'] = selectedBrand ?? '';
              data['dataJson'] = jsonEncode({
                'idBrand': selectedBrand ?? '',
                'brandName': selectedBrand ?? '',
              });
            } else {
              data['name'] = selectedType;
            }
            Navigator.pop(context, data);
          },
          child: Text(l10n.add),
        ),
      ],
    );
  }
}

class _CreateBrandDialog extends StatefulWidget {
  @override
  State<_CreateBrandDialog> createState() => _CreateBrandDialogState();
}

class _CreateBrandDialogState extends State<_CreateBrandDialog> {
  final TextEditingController _brandNameController = TextEditingController();
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.createNewBrandTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _brandNameController,
            decoration: InputDecoration(labelText: l10n.brandName),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              setState(() {
                selectedImage = 'path/to/image.png';
              });
            },
            child: Text(l10n.selectImage),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': _brandNameController.text,
              'image': selectedImage ?? '',
            });
          },
          child: Text(l10n.create),
        ),
      ],
    );
  }
}

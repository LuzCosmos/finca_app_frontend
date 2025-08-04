import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:finca_app_frontend/core/utils/logger.dart';

class EventDetailForm extends StatefulWidget {
  const EventDetailForm({super.key});

  @override
  State<EventDetailForm> createState() => _EventDetailFormState();
}

class _EventDetailFormState extends State<EventDetailForm> {
  String selectedType = SimpleEventType.weight.name;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  BrandModel? selectedBrandObject;

  List<BrandModel> availableBrands = [];

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await BrandApiService.loadBrands();
      setState(() {
        availableBrands = brands;
      });
    } catch (e) {
      // Manejo de error
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.addEventDetail),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged:
                    (value) => setState(
                      () => selectedType = value ?? SimpleEventType.weight.name,
                    ),
                items: [
                  DropdownMenuItem(
                    value: SimpleEventType.weight.name,
                    child: Text(SimpleEventType.weight.asText(context)),
                  ),
                  DropdownMenuItem(
                    value: SimpleEventType.castration.name,
                    child: Text(SimpleEventType.castration.asText(context)),
                  ),
                  DropdownMenuItem(
                    value: SimpleEventType.tracker.name,
                    child: Text(SimpleEventType.tracker.asText(context)),
                  ),
                  DropdownMenuItem(
                    value: SimpleEventType.eartag.name,
                    child: Text(SimpleEventType.eartag.asText(context)),
                  ),
                  DropdownMenuItem(
                    value: SimpleEventType.medication.name,
                    child: Text(SimpleEventType.medication.asText(context)),
                  ),
                  DropdownMenuItem(
                    value: SimpleEventType.brand.name,
                    child: Text(SimpleEventType.brand.asText(context)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campos específicos
              if (selectedType == SimpleEventType.medication.name) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.medicationName),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dosageController,
                  decoration: InputDecoration(labelText: l10n.medicationDosage),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                ),
                TextFormField(
                  controller: _routeController,
                  decoration: InputDecoration(labelText: l10n.medicationRoute),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lotController,
                  decoration: InputDecoration(labelText: l10n.medicationLot),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                ),
              ],
              if (selectedType == SimpleEventType.brand.name) ...[
                DropdownButtonFormField<String>(
                  value: selectedBrandObject?.name,
                  onChanged:
                      (value) => setState(() {
                        selectedBrandObject = availableBrands.firstWhere(
                          (b) => b.name == value,
                        );
                      }),
                  hint: Text(l10n.selectBrand),
                  items:
                      availableBrands
                          .map(
                            (b) => DropdownMenuItem<String>(
                              value: b.name,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                ),
                if (selectedBrandObject != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Center(
                      child: Image.memory(
                        base64Decode(
                          selectedBrandObject!.imageBase64.split(',').last,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<Map<String, String>>(
                      context: context,
                      builder: (context) => _CreateBrandDialog(),
                    );
                    if (result != null) {
                      final newBrand = BrandModel(
                        id: result['id']!,
                        idTenant: result['idTenant']!,
                        name: result['name']!,
                        imageMimeType: result['imageMimeType']!,
                        imageBase64: result['image']!,
                      );
                      setState(() {
                        availableBrands.add(newBrand);
                        selectedBrandObject = availableBrands.last;
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final requiresValidation =
                selectedType == SimpleEventType.medication.name ||
                selectedType == SimpleEventType.brand.name;
            if (requiresValidation) {
              final isValid = _formKey.currentState?.validate() ?? false;
              if (!isValid) return;
            }
            final Map<String, dynamic> data = {'type': selectedType};
            if (selectedType == SimpleEventType.medication.name) {
              data['name'] = _nameController.text;
              data['data'] = jsonEncode({
                'medicationName': _nameController.text,
                'route': _routeController.text,
                'dosage': _dosageController.text,
                'lot': _lotController.text,
              });
            } else if (selectedType == SimpleEventType.brand.name) {
              data['name'] = selectedBrandObject?.name ?? '';
              data['data'] = jsonEncode({
                'idBrand': selectedBrandObject?.id ?? '',
                'brandName': selectedBrandObject?.name ?? '',
              });
              logger.d(data);
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

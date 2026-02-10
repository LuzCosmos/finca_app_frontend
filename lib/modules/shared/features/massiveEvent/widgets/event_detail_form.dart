import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/widgets/create_brand_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:finca_app_frontend/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailForm extends StatefulWidget {
  final List<SimpleEventType> activeEventTypes;

  const EventDetailForm({super.key, required this.activeEventTypes});

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
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _routeController.dispose();
    _dosageController.dispose();
    _lotController.dispose();
    availableBrands.clear();
    selectedBrandObject = null;
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      if (widget.activeEventTypes.isNotEmpty) {
        final availableTypes = _availableEventTypes(context);
        final defaultType = availableTypes.firstWhere(
          (e) => e.key == SimpleEventType.weight.name,
          orElse: () => availableTypes.first,
        );
        setState(() => selectedType = defaultType.key);
      }
      _initialized = true;
    }
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands =
          await context.read<MassiveEventBloc>().dataSource.getAllBrands();
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
                initialValue: selectedType,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedType = value);
                },
                items: _buildAvailableEventTypes(context),
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
                DropdownButtonFormField<BrandModel>(
                  initialValue: selectedBrandObject,
                  onChanged:
                      (value) => setState(() => selectedBrandObject = value),
                  items:
                      availableBrands
                          .map(
                            (b) => DropdownMenuItem<BrandModel>(
                              value: b,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                  validator:
                      (value) => value == null ? l10n.fieldRequired : null,
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
                          selectedBrandObject!.imageBase64!.split(',').last,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final massiveBloc = context.read<MassiveEventBloc>();
                    final newBrand = await showDialog<BrandModel>(
                      context: context,
                      builder:
                          (dialogContext) => BlocProvider.value(
                            value: massiveBloc,
                            child: CreateBrandDialog(),
                          ),
                    );
                    if (newBrand != null) {
                      setState(() {
                        availableBrands.add(newBrand);
                        selectedBrandObject = newBrand;
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
              data['name'] = '$selectedType: ${selectedBrandObject!.name}';
              data['data'] = jsonEncode({
                'idBrand': selectedBrandObject!.id,
                'brandName': selectedBrandObject!.name,
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

  List<MapEntry<String, String>> _availableEventTypes(BuildContext context) {
    final alwaysVisible = {SimpleEventType.brand, SimpleEventType.medication};
    final availableTypes =
        SimpleEventType.values
            .where((type) {
              return (alwaysVisible.contains(type) ||
                  !widget.activeEventTypes.contains(type));
            })
            .toList()
            .map((type) => MapEntry(type.name, type.asText(context)))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    return availableTypes;
  }

  List<DropdownMenuItem<String>> _buildAvailableEventTypes(
    BuildContext context,
  ) {
    final availableTypes = _availableEventTypes(context);
    return availableTypes
        .map(
          (entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          ),
        )
        .toList();
  }
}

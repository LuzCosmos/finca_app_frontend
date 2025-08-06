import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/services/brand_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:finca_app_frontend/core/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final brands = await BrandApiService.getAllBrands();
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
                items:
                    (() {
                      final items =
                          SimpleEventType.values
                              .map(
                                (type) =>
                                    MapEntry(type.name, type.asText(context)),
                              )
                              .toList()
                            ..sort((a, b) => a.value.compareTo(b.value));

                      return items
                          .map(
                            (entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                          )
                          .toList();
                    })(),
                /*[
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
                ]*/
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
                  value: selectedBrandObject,
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
                            child: _CreateBrandDialog(),
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
}

class _CreateBrandDialog extends StatefulWidget {
  @override
  State<_CreateBrandDialog> createState() => _CreateBrandDialogState();
}

class _CreateBrandDialogState extends State<_CreateBrandDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
  bool _showImageError = false;
  String? error;

  Uint8List? _pickedImageBytes;
  String? _pickedMimeType;
  String? _pickedImageBase64;

  Future<void> _pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      setState(() {
        _pickedImageBytes = file.bytes!;
        _pickedMimeType = lookupMimeType(file.name);
        _pickedImageBase64 =
            'data:$_pickedMimeType;base64,${base64Encode(_pickedImageBytes!)}';
      });
    }
  }

  void _onCreatePressed() {
    final l10n = AppLocalizations.of(context)!;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_pickedImageBase64 == null) {
      setState(() {
        error = l10n.imageRequired;
        _showImageError = true;
      });
      return;
    } else {
      setState(() {
        error = '';
        _showImageError = false;
      });
    }
    final brand = BrandModel.create(
      name: _brandNameController.text.trim(),
      imageBytes: _pickedImageBytes,
      imageMimeType: _pickedMimeType!,
      imageBase64: _pickedImageBase64!,
    );
    Future.microtask(() async {
      try {
        final bloc = context.read<MassiveEventBloc>();
        final newBrand = await bloc.dataSource.saveBrand(brand: brand);
        Navigator.pop(context, newBrand);
      } on ApiException catch (e) {
        setState(() {
          error = ApiExceptionCode.values
              .firstWhere((el) => el.name == e.code)
              .asText(context);
          ;
          _showImageError = true;
        });
      } catch (e) {
        setState(() {
          error = ApiExceptionCode.unknownError.asText(context);
          _showImageError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.createNewBrandTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _brandNameController,
              decoration: InputDecoration(labelText: l10n.brandName),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? l10n.fieldRequired
                          : null,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickImageFile,
              child: Text(l10n.selectImage),
            ),
            if (_showImageError) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            if (_pickedImageBytes != null) ...[
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(border: Border.all()),
                child: Image.memory(_pickedImageBytes!, fit: BoxFit.contain),
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
        ElevatedButton(onPressed: _onCreatePressed, child: Text(l10n.create)),
      ],
    );
  }
}

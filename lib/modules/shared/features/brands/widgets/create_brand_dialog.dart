import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';

class CreateBrandDialog extends StatefulWidget {
  const CreateBrandDialog({super.key});

  @override
  State<CreateBrandDialog> createState() => _CreateBrandDialogState();
}

class _CreateBrandDialogState extends State<CreateBrandDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
  bool _showImageError = false;
  String? error;
  Uint8List? _pickedImageBytes;
  String? _pickedMimeType;
  String? _pickedImageBase64;

  @override
  void dispose() {
    _brandNameController.dispose();
    _pickedImageBytes = null;
    _pickedMimeType = null;
    _pickedImageBase64 = null;
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
    error = null;
    _showImageError = false;
    _pickedImageBytes = null;
    _pickedMimeType = null;
    _pickedImageBase64 = null;
    super.dispose();
  }

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
            OutlinedButton.icon(
              onPressed: _pickImageFile,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: Text(l10n.selectImage),
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

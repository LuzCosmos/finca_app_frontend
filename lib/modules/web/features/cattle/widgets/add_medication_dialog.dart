import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class AddMedicationDialog extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const AddMedicationDialog({super.key, required this.onSave});

  @override
  State<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<AddMedicationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _lotController = TextEditingController();
  DateTime _appliedDate = DateTime.now();
  String? _selectedRoute;

  bool _isSaving = false;

  final List<String> _routes = [
    'Oral',
    'Inyectable Subcutanea',
    'Inyectable Intramuscular',
    'Topico',
    'Intravenosa',
    'Intranasal'  
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _lotController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a route')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final data = {
        'medicationName': _nameController.text,
        'dosage': _dosageController.text,
        'route': _selectedRoute,
        'lot': _lotController.text.isNotEmpty ? _lotController.text : null,
        'appliedAt': _appliedDate.toIso8601String(),
      };

      await widget.onSave(data);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.addMedication),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.medicationName),
                validator: (v) => v?.isEmpty == true ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(labelText: l10n.dosage),
                validator: (v) => v?.isEmpty == true ? l10n.fieldRequired : null,
              ),
               const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _selectedRoute,
                decoration: InputDecoration(labelText: l10n.route),
                items: _routes.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedRoute = v),
                validator: (v) => v == null ? l10n.fieldRequired : null,
              ),
               const SizedBox(height: 16),
               TextFormField(
                controller: _lotController,
                decoration: InputDecoration(labelText: l10n.medicationLot),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.date),
                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(_appliedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _appliedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null && mounted) {
                    setState(() => _appliedDate = date);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(l10n.save),
        ),
      ],
    );
  }
}

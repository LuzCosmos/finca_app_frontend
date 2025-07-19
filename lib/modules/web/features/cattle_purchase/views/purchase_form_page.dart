import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../../../../shared/widgets/finca_scaffold.dart';
import '../widgets/provider_input.dart';
import '../widgets/lots_section.dart';
import '../models/provider.dart';
import '../models/lot.dart';
import '../../../../shared/widgets/message_banner.dart';
import 'package:logger/logger.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  ProviderModel? _selectedProvider;
  DateTime _selectedDate = DateTime.now();
  List<LotModel> _lots = [];
  String? _globalErrorMessage;
  final GlobalKey<LotsSectionState> _lotsSectionKey =
      GlobalKey<LotsSectionState>();

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

  void _onLotsChanged(List<LotModel> updatedLots) {
    _globalErrorMessage = null;
    setState(() {
      _lots = updatedLots;
    });
  }

  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showError(l10n.purchase_dateRequired);
      return;
    }
    if (_selectedProvider == null) {
      _showError(l10n.cp_error_providerRequired);
      return;
    }
    if (_lots.isEmpty) {
      _showError(l10n.cp_error_noLots);
      return;
    }
    if (!_lotsSectionKey.currentState!.validateDuplicatedLotNumbers(context)) {
      _showError(l10n.lot_duplicateLotNumber);
      return;
    }
    Logger().d('submit');
  }

  void _showError(String message) {
    setState(() {
      _globalErrorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: l10n.cattlePurchase,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_globalErrorMessage != null)
                MessageBanner.error(_globalErrorMessage!),

              /// Save Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _onSubmit,
                  icon: const Icon(Icons.save),
                  label: Text(l10n.purchase_create),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.provider,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              /// Provider
              ProviderInput(
                onProviderSelected: (providerData) {
                  setState(() {
                    _selectedProvider = providerData;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Purchase Date
              Row(
                children: [
                  Text('${l10n.purchase_date}: '),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    onPressed: _selectDate,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Lots
              LotsSection(key: _lotsSectionKey, onLotsChanged: _onLotsChanged),
            ],
          ),
        ),
      ),
    );
  }
}

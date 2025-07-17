import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../../../../shared/features/auth/widgets/finca_scaffold.dart';
import '../widgets/provider_input.dart';
import '../widgets/lots_section.dart';
import '../models/provider.dart';
import '../models/lot.dart';

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

  void _selectDate() async {
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
    setState(() {
      _lots = updatedLots;
    });
  }

  void _onSubmit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      _showError(l10n.fixErrors);
      return;
    }
    if (_selectedProvider == null) {
      _showError(l10n.cp_error_providerRequired);
      return;
    }
    if (_selectedDate == null) {
      _showError(l10n.purchase_dateRequired);
      return;
    }
    if (_lots.isEmpty) {
      _showError(l10n.cp_error_noLots);
      return;
    }
    for (final lot in _lots) {
      if (lot.cattleCount <= 0 || lot.avgWeight <= 0 || lot.pricePerKg <= 0) {
        _showError(l10n.lot_countAvWeightPriceKgRequired);
        return;
      }
    }
    // TODO: Llamar a tu servicio de guardado aquí con _selectedProvider, _selectedDate y _lots
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
              /// Save Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (_selectedProvider == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.cp_errors_cattleCountRequired),
                        ),
                      );
                      return;
                    }
                    if (_lots.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.cp_error_noLots)),
                      );
                      return;
                    }
                    // TODO: enviar compra
                  },
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
              LotsSection(onLotsChanged: _onLotsChanged),
            ],
          ),
        ),
      ),
    );
  }
}

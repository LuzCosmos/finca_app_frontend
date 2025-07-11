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
  ProviderModel? selectedProvider;
  DateTime selectedDate = DateTime.now();
  List<LotModel> lots = [];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _onLotsChanged(List<LotModel> updatedLots) {
    setState(() {
      lots = updatedLots;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: l10n.cattlePurchase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.cattlePurchase,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              /// PROVEEDOR
              ProviderInput(
                onProviderSelected: (providerData) {
                  setState(() {
                    selectedProvider = providerData;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// FECHA DE COMPRA
              Row(
                children: [
                  Text('${l10n.cp_purchaseDate}: '),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    onPressed: _selectDate,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// LOTES
              LotsSection(onLotsChanged: _onLotsChanged),
              const SizedBox(height: 24),

              /// BOTÓN DE GUARDAR
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (selectedProvider == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.cp_errors_cattleCountRequired),
                        ),
                      );
                      return;
                    }
                    if (lots.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.cp_errors_noLots)),
                      );
                      return;
                    }
                    // TODO: enviar compra
                  },
                  icon: const Icon(Icons.save),
                  label: Text(l10n.cp_createPurchase),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

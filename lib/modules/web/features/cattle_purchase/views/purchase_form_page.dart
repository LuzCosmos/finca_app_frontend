import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../../../../shared/features/auth/widgets/finca_scaffold.dart';
import '../widgets/provider_input.dart';
import '../models/provider.dart';
import '../widgets/lot_input.dart';
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

  // Lista dinámica de GlobalKeys para los LotInputs
  final List<GlobalKey<LotInputState>> _lotInputKeys = [];

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

  void _addLotForm() {
    setState(() {
      _lotInputKeys.add(GlobalKey<LotInputState>());
    });
  }

  void _removeLotForm(int index) {
    setState(() {
      _lotInputKeys.removeAt(index);
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

              // PROVEEDOR
              ProviderInput(
                onProviderSelected: (providerData) {
                  setState(() {
                    selectedProvider = providerData;
                  });
                },
              ),
              const SizedBox(height: 16),

              // FECHA
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

              // LOTES HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.lot, style: Theme.of(context).textTheme.titleLarge),
                  ElevatedButton.icon(
                    onPressed: _addLotForm,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addLot),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // LOTES INPUTS
              ..._lotInputKeys.asMap().entries.map((entry) {
                final index = entry.key;
                final key = entry.value;
                return Column(
                  children: [
                    LotInput(
                      key: key,
                      onChanged: (lot) {
                        // Por ahora puedes dejarlo vacío o para logs
                      },
                      onRemove: () => _removeLotForm(index),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              const Divider(height: 32),

              // BOTÓN DE GUARDAR
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: validación y envío
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

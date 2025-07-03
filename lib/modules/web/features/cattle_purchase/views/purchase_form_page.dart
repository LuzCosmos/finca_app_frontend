import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../../../../shared/widgets/finca_scaffold.dart';
import '../widgets/provider_input.dart';
//import '../widgets/purchase_summary.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Estado inicial
  DateTime selectedDate = DateTime.now();

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
              ProviderInput(),
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

              /// SECCIÓN: Lotes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.cp_lot,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: agregar nuevo formulario de lote
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.cp_addLot),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Aquí irán los lotes agregados (ExpansionTiles o lista)
              const Divider(height: 32),

              /// RESUMEN
              // PurchaseSummary(),
              const SizedBox(height: 24),

              /// BOTÓN DE GUARDAR
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_event.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_state.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:uuid/uuid.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({super.key});

  @override
  State<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  final _formKey = GlobalKey<FormState>();
  final _minWeightController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _cattleSearchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedBuyerId;
  String? _selectedTransporterId;

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(LoadSalesInitialData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Sale')),
      body: BlocConsumer<SalesBloc, SalesState>(
        listener: (context, state) {
          if (state is SaleSavedSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sale saved successfully')),
            );
          }
          if (state is SalesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is CattleSearchSuccess) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Cattle found (Implementation pending)')),
             );
          }
        },
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Assuming SalesReady stores the lists. 
          // Note: If state changes to e.g. CattleSearchSuccess, we might lose lists if not carried over.
          // For this MVP, I'll access lists if state is SalesReady, otherwise empty? 
          // Ideally Bloc State should hold lists always.
          
          List<dynamic> buyers = [];
          List<dynamic> transporters = [];
          
          if (state is SalesReady) {
            buyers = state.buyers;
            transporters = state.transporters;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDatePicker(context),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Buyer'),
                    value: _selectedBuyerId,
                    items: buyers.map<DropdownMenuItem<String>>((b) {
                      return DropdownMenuItem(value: b.id, child: Text(b.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedBuyerId = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Transporter'),
                    value: _selectedTransporterId,
                    items: transporters.map<DropdownMenuItem<String>>((t) {
                      return DropdownMenuItem(value: t.id, child: Text(t.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedTransporterId = val),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minWeightController,
                          decoration: const InputDecoration(labelText: 'Min Weight (Kg)'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(labelText: 'Price / Kg'),
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Cattle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cattleSearchController,
                          decoration: const InputDecoration(labelText: 'Scan/Enter Number'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (_cattleSearchController.text.isNotEmpty) {
                            context.read<SalesBloc>().add(SearchCattleByNumber(_cattleSearchController.text));
                          }
                        },
                      )
                    ],
                  ),
                  // List of added cattle would go here...
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                         if (_formKey.currentState!.validate()) {
                           // Construct SaleModel
                           // double totalAmt = ...
                           // context.read<SalesBloc>().add(SaveSaleTransaction(model));
                         }
                      },
                      child: const Text('Save Sale'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Transaction Date'),
        child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
      ),
    );
  }
  
  @override
  void dispose() {
    _minWeightController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _cattleSearchController.dispose();
    super.dispose();
  }
}

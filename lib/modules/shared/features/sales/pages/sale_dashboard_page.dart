import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_event.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_state.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/create_sale_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/data/sales/sales_data_source_mobile_interface.dart'
    if (dart.library.html) 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web_interface.dart';

class SaleDashboardPage extends StatelessWidget {
  const SaleDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesBloc(dataSource: createSalesDataSource())..add(LoadUnsyncedSales()),
      child: const SaleDashboardView(),
    );
  }
}

class SaleDashboardView extends StatelessWidget {
  const SaleDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<SalesBloc>().add(SyncSalesTransaction());
            },
          )
        ],
      ),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnsyncedSalesLoaded) {
             if (state.sales.isEmpty) {
               return const Center(child: Text('No offline sales pending sync.'));
             }
             return ListView.builder(
               itemCount: state.sales.length,
               itemBuilder: (context, index) {
                 final sale = state.sales[index];
                 return ListTile(
                   title: Text('Sale ${sale.transactionDate}'),
                   subtitle: Text('Total: ${sale.totalAmount}'),
                   trailing: const Icon(Icons.sync_problem, color: Colors.orange),
                 );
               },
             );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
               builder: (_) => BlocProvider(
                 create: (_) => SalesBloc(dataSource: createSalesDataSource()), // New Bloc for Form
                 child: const CreateSalePage(),
               )
            ),
          ).then((_) => context.read<SalesBloc>().add(LoadUnsyncedSales())); // Refresh list on return
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

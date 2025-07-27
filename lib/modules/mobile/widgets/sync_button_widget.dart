import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';

class SyncButtonWidget extends StatelessWidget {
  final String idTenant;

  const SyncButtonWidget({super.key, required this.idTenant});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) {
        if (state is SyncInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sincronizando datos...')),
          );
        } else if (state is SyncSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sincronización completa ✅')),
          );
        } else if (state is SyncFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al sincronizar: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.sync),
          label: const Text('Sincronizar ahora'),
          onPressed: () {
            context.read<SyncBloc>().add(StartSync(idTenant));
          },
        );
      },
    );
  }
}
/*


import 'package:finca_app_frontend/modules/mobile/widgets/sync_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SyncConnectivityListener _syncListener;
  final String _idTenant = 'TENANT_ID_DEL_USUARIO';

  @override
  void initState() {
    super.initState();
    final syncBloc = context.read<SyncBloc>();
    _syncListener = SyncConnectivityListener(syncBloc: syncBloc, idTenant: _idTenant);
    _syncListener.start();
  }

  @override
  void dispose() {
    _syncListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: SyncButtonWidget(idTenant: _idTenant),
      ),
    );
  }
}


 */
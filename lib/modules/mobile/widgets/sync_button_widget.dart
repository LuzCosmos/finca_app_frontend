import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';

class SyncButtonWidget extends StatelessWidget {
  final String idTenant;

  const SyncButtonWidget({super.key, required this.idTenant});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is SyncInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.syncMassiveEventsInProgress)),
          );
        } else if (state is SyncSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.syncMassiveEventsSuccess)),
          );
        } else if (state is SyncFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.syncMassiveEventsFailure(state.message)),
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return ElevatedButton.icon(
          icon: const Icon(Icons.sync),
          label: Text(l10n.syncNow),
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
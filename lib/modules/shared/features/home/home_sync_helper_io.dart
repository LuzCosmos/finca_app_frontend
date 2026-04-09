import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/modules/mobile/sync/sync_connectivity_listener.dart';
import 'package:finca_app_frontend/platform/detectors/platform_detector.dart';

class HomeSyncHelper {
  SyncConnectivityListener? _listener;

  void dispose() {
    _listener?.dispose();
  }

  Future<void> onPostFrame(State state) async {
    if (!state.mounted || !PlatformDetector.isMobile()) return;
    final idTenant = await SessionService.getIdTenant();
    if (!state.mounted || idTenant == null) return;
    try {
      final syncBloc = state.context.read<SyncBloc>();
      _listener?.dispose();
      _listener = SyncConnectivityListener(
        syncBloc: syncBloc,
        idTenant: idTenant,
      );
      _listener!.start();
    } catch (_) {}
  }

  Widget buildSyncSection(BuildContext context, AppLocalizations l10n) {
    if (!PlatformDetector.isMobile()) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Align(
        alignment: Alignment.center,
        child: FutureBuilder<String?>(
          future: SessionService.getIdTenant(),
          builder: (context, snap) {
            final tenant = snap.data;
            if (tenant == null) return const SizedBox.shrink();
            return OutlinedButton.icon(
              onPressed: () {
                try {
                  context.read<SyncBloc>().add(StartSync(tenant));
                } catch (_) {}
              },
              icon: const Icon(Icons.sync, size: 20),
              label: Text(l10n.syncNow),
            );
          },
        ),
      ),
    );
  }
}

HomeSyncHelper createHomeSyncHelper() => HomeSyncHelper();

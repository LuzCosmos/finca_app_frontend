import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/platform/detectors/platform_detector.dart';

class SyncConnectivityListener {
  final SyncBloc syncBloc;
  final String idTenant;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  SyncConnectivityListener({required this.syncBloc, required this.idTenant});

  void start() {
    // 👉 Sólo escuchar en móviles, no en web
    if (PlatformDetector.isMobile()) {
      _subscription = Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> results,
      ) {
        final hasConnection = results.isNotEmpty &&
            results.last != ConnectivityResult.none;
        if (hasConnection) {
          // Tenemos conexión: dispara sincronización
          debugPrint(
            '[SyncConnectivityListener] Conexión detectada, sincronizando...',
          );
          syncBloc.add(StartSync(idTenant));
        }
      });
    } else {
      debugPrint(
        '[SyncConnectivityListener] Plataforma web: no se activa sync automático.',
      );
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

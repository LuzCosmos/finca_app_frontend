import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Conectividad para mostrar u ocultar opciones del menú que son 100 % online.
class HomeConnectivityService {
  /// Solo tests: fuerza el estado online/offline sin depender del plugin.
  @visibleForTesting
  static bool? debugForceOnline;

  static Future<bool> isOnline() async {
    final forced = debugForceOnline;
    if (forced != null) return forced;
    if (kIsWeb) return true;
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  static Stream<bool> onlineStream() {
    final forced = debugForceOnline;
    if (forced != null) return Stream<bool>.value(forced);
    if (kIsWeb) return Stream<bool>.value(true);
    return Connectivity().onConnectivityChanged.map(
      (results) => results.any((r) => r != ConnectivityResult.none),
    );
  }
}

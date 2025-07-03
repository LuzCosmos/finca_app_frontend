import 'package:platform/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class PlatformService {
  final Platform _platform = const LocalPlatform();
  final Logger _logger = Logger();

  String getOS() => _platform.operatingSystem;

  String getOSVersion() => _platform.operatingSystemVersion;

  bool isMobile() => !kIsWeb;

  bool isWeb() => kIsWeb;

  bool isAndroid() => _platform.isAndroid;

  bool isIOS() => _platform.isIOS;

  void initialize() {
    try {
      _logger.d('Inicializando servicio de plataforma...');

      // Guardar info para usar globalmente
      final os = getOS();
      final version = getOSVersion();
      _logger.i('Sistema: $os, versión: $version');

      // Validación de plataforma
      if (isWeb()) {
        _logger.w('La funcionalidad nativa no estará disponible en Web.');
      }

      // Registro con algún servicio externo
      // await AnalyticsService.logPlatform(os, version); ← si lo haces async, marca como Future<void>

      _logger.d('Servicio de plataforma inicializado correctamente');
    } catch (e) {
      _logger.e('Error al inicializar servicio de plataforma: $e');
      rethrow;
    }
  }
}

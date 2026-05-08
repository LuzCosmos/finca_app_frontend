import 'dart:convert';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

/// Cliente HTTP para los endpoints `/api/v1/devices/:deveui/remote-config/...`
/// y `/api/v1/device-configuration-profiles/...` del backend NestJS.
///
/// Diseño:
///  - Mantiene la convención del proyecto (BasicApiService, jsonDecode, manageNotSuccess).
///  - Indexa por `deveui` para alinear con el GET/PUT existentes.
///  - Lanza `ApiException` propagado por BasicApiService cuando el backend responde error.
class DeviceRemoteConfigApiService {
  static String get _baseUrl => BasicApiService.getApiBaseUrl();

  // ---------- Profiles ----------

  static Future<List<ConfigurationProfileModel>> listProfiles() async {
    final url = Uri.parse('$_baseUrl/device-configuration-profiles');
    final response = await BasicApiService.authorizedGet(url);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body
          .map((e) => ConfigurationProfileModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<ConfigurationProfileModel> createProfile(
    Map<String, dynamic> dto,
  ) async {
    final url = Uri.parse('$_baseUrl/device-configuration-profiles');
    final response = await BasicApiService.authorizedPost(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto),
    );
    if (response.statusCode == 201) {
      return ConfigurationProfileModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<ConfigurationProfileModel> updateProfile(
    String idProfile,
    Map<String, dynamic> dto,
  ) async {
    final url = Uri.parse('$_baseUrl/device-configuration-profiles/$idProfile');
    final response = await BasicApiService.authorizedPut(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto),
    );
    if (response.statusCode == 200) {
      return ConfigurationProfileModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<void> deleteProfile(String idProfile) async {
    final url = Uri.parse('$_baseUrl/device-configuration-profiles/$idProfile');
    final response = await BasicApiService.authorizedDelete(url);
    if (response.statusCode == 200) return;
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  // ---------- Remote configuration ----------

  static Future<RemoteConfigStatusModel?> getStatus(String deveui) async {
    final url = Uri.parse('$_baseUrl/devices/$deveui/remote-config');
    final response = await BasicApiService.authorizedGet(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final remote = body['remoteConfig'];
      if (remote == null) return null;
      return RemoteConfigStatusModel.fromJson(remote as Map<String, dynamic>);
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<DeviceCommandModel> applyProfile(
    String deveui,
    String idProfile,
  ) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/apply-profile'),
      body: {'idProfile': idProfile},
    );
  }

  static Future<DeviceCommandModel> configureParameters(
    String deveui,
    Map<String, dynamic> parameters,
  ) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/configure'),
      body: {'parameters': parameters},
    );
  }

  static Future<DeviceCommandModel> readParameters(
    String deveui,
    List<String> parameterNames,
  ) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/read'),
      body: {'parameterNames': parameterNames},
    );
  }

  /// Lectura masiva: todos los IDs del PDF no peligrosos (varios downlinks si hace falta).
  static Future<Map<String, dynamic>> readAllSafeParameters(String deveui) async {
    final url = Uri.parse(
      '$_baseUrl/devices/$deveui/remote-config/read-all-safe-parameters',
    );
    final response = await BasicApiService.authorizedPost(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  /// Plan de bloques para lectura segura (sin encolar). Misma partición que [readAllSafeParameters].
  static Future<ReadSafeParametersChunkPlanModel> getReadSafeParametersChunkPlan(
    String deveui,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/devices/$deveui/remote-config/read-safe-parameters-chunks',
    );
    final response = await BasicApiService.authorizedGet(url);
    if (response.statusCode == 200) {
      return ReadSafeParametersChunkPlanModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  /// Encola un solo Read con el bloque seguro `chunkIndex` (0-based).
  static Future<DeviceCommandModel> readSafeParametersChunk(
    String deveui,
    int chunkIndex,
  ) async {
    return _postCommand(
      Uri.parse(
        '$_baseUrl/devices/$deveui/remote-config/read-safe-parameters-chunk',
      ),
      body: {'chunkIndex': chunkIndex},
    );
  }

  static Future<DeviceCommandModel> requestPosition(String deveui) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/control/request-position'),
    );
  }

  static Future<DeviceCommandModel> requestBattery(String deveui) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/control/request-battery'),
    );
  }

  static Future<DeviceCommandModel> clearManDown(String deveui) async {
    return _postCommand(
      Uri.parse('$_baseUrl/devices/$deveui/remote-config/control/clear-man-down'),
    );
  }

  /// Apaga GPS / WiFi / BT en el collar y deja la posición a cargo del LNS LoRaWAN
  /// (TDOA/RSSI). Encola un único Configure con las 6 position-strategy en `0x00`.
  static Future<DeviceCommandModel> setLorawanOnlyPositioning(
    String deveui,
  ) async {
    return _postCommand(
      Uri.parse(
        '$_baseUrl/devices/$deveui/remote-config/positioning/lorawan-only',
      ),
    );
  }

  /// Activa el modo diagnóstico (silencia shock/man-down/tamper, heartbeat 300 s).
  /// Auto-restaura tras `ttlMinutes` (default backend: 30, rango [5..240]).
  static Future<Map<String, dynamic>> enableDiagnosticMode(
    String deveui, {
    int? ttlMinutes,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/devices/$deveui/remote-config/diagnostic-mode/enable',
    );
    final response = await BasicApiService.authorizedPost(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        if (ttlMinutes != null) 'ttlMinutes': ttlMinutes,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  /// Desactiva el modo diagnóstico restaurando los parámetros previos del device.
  static Future<Map<String, dynamic>> disableDiagnosticMode(String deveui) async {
    final url = Uri.parse(
      '$_baseUrl/devices/$deveui/remote-config/diagnostic-mode/disable',
    );
    final response = await BasicApiService.authorizedPost(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<DeviceCommandPage> listCommands(
    String deveui, {
    int limit = 50,
    int offset = 0,
    String? status,
  }) async {
    final params = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (status != null) 'status': status,
    };
    final url = Uri.parse(
      '$_baseUrl/devices/$deveui/remote-config/commands',
    ).replace(queryParameters: params);
    final response = await BasicApiService.authorizedGet(url);
    if (response.statusCode == 200) {
      return DeviceCommandPage.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<DeviceCommandModel> _postCommand(
    Uri url, {
    Map<String, dynamic>? body,
  }) async {
    final response = await BasicApiService.authorizedPost(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body == null ? null : jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 202) {
      final Map<String, dynamic> raw = jsonDecode(response.body);
      // El backend devuelve `{ command, payloadHex, queueItemId }`.
      final cmd = raw['command'] as Map<String, dynamic>? ?? raw;
      return DeviceCommandModel.fromJson(cmd);
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }
}

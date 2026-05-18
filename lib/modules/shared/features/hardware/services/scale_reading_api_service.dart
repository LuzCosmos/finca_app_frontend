import 'dart:convert';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/models/scale_reading_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScaleReadingApiService {
  static final String _baseUrl = BasicApiService.getApiBaseUrl();

  /// Orden: dart-define `SCALE_DEVICE_ID` → `.env` → `default-scale`.
  static String get defaultScaleId {
    const fromDefine = String.fromEnvironment('SCALE_DEVICE_ID');
    if (fromDefine.isNotEmpty) return fromDefine;
    try {
      final fromEnv = dotenv.env['SCALE_DEVICE_ID']?.trim();
      if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    } catch (_) {}
    return 'default-scale';
  }

  Uri _scaleUri(String scaleId, String suffix) {
    return Uri.parse(
      '$_baseUrl/hardware/scales/${Uri.encodeComponent(scaleId)}/$suffix',
    );
  }

  /// Registra el tenant del usuario JWT como destino de lecturas del bridge.
  Future<void> bindSession(String scaleId) async {
    final response = await BasicApiService.authorizedPost(
      _scaleUri(scaleId, 'session'),
      headers: const {'Content-Type': 'application/json'},
      body: '{}',
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<ScaleStatusModel> fetchStatus(String scaleId) async {
    final response = await BasicApiService.authorizedGet(
      _scaleUri(scaleId, 'status'),
    );
    if (response.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
    return ScaleStatusModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<ScaleReadingModel> fetchLatestReading(String scaleId) async {
    final response = await BasicApiService.authorizedGet(
      _scaleUri(scaleId, 'latest-reading'),
    );
    if (response.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
    return ScaleReadingModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<ScaleReadingModel> fetchLatestStableReading(String scaleId) async {
    final response = await BasicApiService.authorizedGet(
      _scaleUri(scaleId, 'latest-stable-reading'),
    );
    if (response.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
    return ScaleReadingModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}

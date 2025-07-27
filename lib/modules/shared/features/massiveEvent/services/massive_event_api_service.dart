import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_config.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

class MassiveEventApiService {
  // Obtén baseUrl directo de dotenv (asegúrate de tener cargado dotenv antes de usar)
  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// 👉 Crear un MassiveEvent en backend
  Future<String> createMassiveEvent({
    required String idTenant,
    required DateTime eventDate,
    required String createdBy,
  }) async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }

    final payload = {
      "idTenant": idTenant,
      "eventDate": eventDate.toIso8601String(),
      "status": "open",
      "createdBy": createdBy,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/massive-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final serverId = data['id'] as String;
      return serverId;
    } else {
      throw Exception(
        '❌ Error al crear MassiveEvent: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// 👉 Crear un SimpleEvent asociado a un MassiveEvent
  Future<void> createSimpleEvent({
    required String massiveEventServerId,
    required String idTenant,
    required SimpleEventConfig config,
  }) async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }

    // Construye el dataJson según el tipo
    Map<String, dynamic> dataJson;
    switch (config.type) {
      case EventType.medication:
        dataJson = {'name': config.name};
        break;
      case EventType.brand:
        dataJson = {'brandName': config.name};
        break;
      default:
        dataJson = {'name': config.name};
        break;
    }

    final payload = {
      "idTenant": idTenant,
      "massiveEventServerId": massiveEventServerId,
      "type": config.type,
      "dataJson": jsonEncode(dataJson),
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/simple-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        '❌ Error al crear SimpleEvent: ${response.statusCode} ${response.body}',
      );
    }
  }
}

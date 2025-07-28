import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import '../../../../../core/services/api_exception.dart';

class MassiveEventApiService {
  // Obtén baseUrl directo de dotenv (asegúrate de tener cargado dotenv antes de usar)
  static get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// 👉 Crear un MassiveEvent en backend
  static Future<String> createMassiveEvent({
    required DateTime eventDate,
    required List<SimpleEventModel> simpleEvents,
  }) async {
    //final idTenant = await SessionService.getIdTenant();
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }

    final payload = {
      //"idTenant": idTenant,
      "eventDate": eventDate.toIso8601String(),
      "simpleEvents": simpleEvents.map((e) => e.toJsonOnlineApi()).toList(),
      //"status": "open",
      //"createdBy": createdBy,
    };
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/massive-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final massiveEvent = MassiveEventModel.fromJson(data);
          //final serverId = data['id'] as String;
          //return serverId;
          return jsonEncode(massiveEvent.toJson());
        } catch (e) {
          throw Exception(
            '⚠️ Respuesta JSON inválida al crear MassiveEvent: $e',
          );
        }
      } else if (response.statusCode == 400) {
        throw ApiException('invalidData', 'Invalid data');
      } else if (response.statusCode == 401) {
        throw ApiException('unauthorized', 'Unauthorized');
      } else if (response.statusCode == 403) {
        throw ApiException('forbidden', 'Forbidden');
      } else if (response.statusCode == 500) {
        throw ApiException('serverError', 'Internal server error');
      } else {
        throw ApiException(
          'unknownError',
          '❌ Error al crear MassiveEvent: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        '🚨 Error al conectar con el servidor (MassiveEvent): $e',
      );
    }
  }

  /// 👉 Crear un SimpleEvent asociado a un MassiveEvent
  static Future<String> createSimpleEvent({
    required String massiveEventServerId,
    //required String idTenant,
    required SimpleEventModel simpleEvent,
  }) async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }
    dynamic decodedJson;
    if (simpleEvent.data != null) {
      try {
        decodedJson = jsonDecode(simpleEvent.data!);
      } catch (e) {
        throw Exception('⚠️ data inválido para SimpleEvent: $e');
      }
    }
    final payload = {
      "idMassiveEvent": massiveEventServerId,
      "type": simpleEvent.type,
      "data": decodedJson,
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/simple-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        '❌ Error al crear SimpleEvent: ${response.statusCode} ${response.body}',
      );
    }
  }
}

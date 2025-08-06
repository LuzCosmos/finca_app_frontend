import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/utils/logger.dart';
import 'dart:io';

class MassiveEventApiService {
  // Obtén baseUrl directo de dotenv (asegúrate de tener cargado dotenv antes de usar)
  static get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static Future<MassiveEventModel> createMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  }) async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }
    final payload = {
      "eventDate": massiveEvent.eventDate.toIso8601String(),
      "simpleEvents":
          massiveEvent.simpleEvents
              .map((e) => e.toJsonOnlineCreateApi())
              .toList(),
    };
    var response;
    try {
      response = await http.post(
        Uri.parse('$_baseUrl/massive-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al crear MassiveEvent: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al crear MassiveEvent: $e',
      );
    }
    if (response != null) {
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final massiveEventSaved = MassiveEventModel.fromJson(data);
          return massiveEventSaved;
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
          'savingObjectError',
          'Error al crear MassiveEvent: ${response.statusCode} ${response.body}',
        );
      }
    } else {
      throw ApiException(
        'savingObjectError',
        'Create MassiveEvent: Response is null.',
      );
    }
  }

  static Future<SimpleEventModel> createSimpleEvent({
    required String massiveEventServerId,
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
      "idMassiveEvent": simpleEvent.idMassiveEvent,
      "type": simpleEvent.type.name,
      "data": decodedJson,
    };
    var response;
    try {
      response = await http.post(
        Uri.parse('$_baseUrl/simple-events'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al crear MassiveEvent: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al crear MassiveEvent: $e',
      );
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final simpleEventSaved = SimpleEventModel.fromJson(data);
        return simpleEventSaved;
      } catch (e) {
        throw Exception('⚠️ Respuesta JSON inválida al crear SimpleEvent: $e');
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
        'Error al crear SimpleEvent: ${response.statusCode} ${response.body}',
      );
    }
  }
}

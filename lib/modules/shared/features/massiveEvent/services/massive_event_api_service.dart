import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/utils/logger.dart';
import 'dart:io';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class MassiveEventApiService {
  // Obtén baseUrl directo de dotenv (asegúrate de tener cargado dotenv antes de usar)
  static get _baseUrl => BasicApiService.baseUrl;

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
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
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
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  static Future<List<AnimalSimpleEventModel>> getAnimalSimpleEvents({
    required String idMassiveEvent,
  }) async {
    // TODO: implement getAnimalSimpleEvents
    throw UnimplementedError();
  }

  static Future<List<AnimalSimpleEventModel>> saveAnimalSimpleEvents({
    required List<AnimalSimpleEventModel> animalSimpleEvents,
    required String cattleNumber,
  }) async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }
    final payload = {
      'applied': {
        "idMassiveEvent": animalSimpleEvents.first.idMassiveEvent,
        "events":
            animalSimpleEvents
                .map((e) => e.toJsonOnlineCreateApiForSingleAnimal())
                .toList(),
      },
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/cattle/apply-events/$cattleNumber'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final List<dynamic> dataResponse = jsonDecode(response.body);
        final List<AnimalSimpleEventModel> animalSimpleEventsSaved =
            dataResponse
                .map<AnimalSimpleEventModel>(
                  (e) => AnimalSimpleEventModel.fromJson(e),
                )
                .toList();
        return animalSimpleEventsSaved;
      } catch (e) {
        throw Exception(
          '⚠️ Respuesta JSON inválida al crear AnimalSimpleEvent: $e',
        );
      }
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  static Future<void> closeMassiveEvent({
    required String idMassiveEvent,
  }) async {
    final token = await BasicApiService.getToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/massive-events/close/$idMassiveEvent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 204) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

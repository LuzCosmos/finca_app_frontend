import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'dart:io';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class MassiveEventsPageResult {
  MassiveEventsPageResult(
    this.page,
    this.limit,
    this.total,
    this.hasMore,
    this.items,
  );

  final int page;
  final int limit;
  final int total;
  final bool hasMore;
  final List<MassiveEventModel> items;
}

class MassiveEventApiService {
  static Future<MassiveEventModel> createMassiveEvent({
    required MassiveEventModel massiveEvent,
    required String idTenant,
  }) async {
    final String baseUrl = BasicApiService.getApiBaseUrl();
    final payload = {
      "eventDate": massiveEvent.eventDate.toIso8601String(),
      "simpleEvents":
          massiveEvent.simpleEvents
              .map((e) => e.toJsonOnlineCreateApi())
              .toList(),
    };
    var response;
    try {
      response = await BasicApiService.authorizedPost(
        Uri.parse('$baseUrl/massive-events'),
        headers: {
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
    final String baseUrl = BasicApiService.getApiBaseUrl();
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
      response = await BasicApiService.authorizedPost(
        Uri.parse('$baseUrl/simple-events'),
        headers: {
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
    final String baseUrl = BasicApiService.getApiBaseUrl();
    final payload = {
      'applied': {
        "idMassiveEvent": animalSimpleEvents.first.idMassiveEvent,
        "events":
            animalSimpleEvents
                .map((e) => e.toJsonOnlineCreateApiForSingleAnimal())
                .toList(),
      },
    };
    final response = await BasicApiService.authorizedPost(
      Uri.parse('$baseUrl/cattle/apply-events/$cattleNumber'),
      headers: {
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
    final String baseUrl = BasicApiService.getApiBaseUrl();
    final response = await BasicApiService.authorizedPut(
      Uri.parse('$baseUrl/massive-events/close/$idMassiveEvent'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 204) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  static Future<MassiveEventsPageResult> listStandaloneMassiveEventsPaged({
    required int page,
    required int limit,
    String? from,
    String? to,
    String? name,
    String status = 'all',
  }) async {
    final String baseUrl = BasicApiService.getApiBaseUrl();
    final uri = Uri.parse('$baseUrl/massive-events').replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (from != null && from.isNotEmpty) 'from': from,
        if (to != null && to.isNotEmpty) 'to': to,
        if (name != null && name.isNotEmpty) 'name': name,
        if (status.isNotEmpty) 'status': status,
      },
    );

    late http.Response response;
    try {
      response = await BasicApiService.authorizedGet(
        uri,
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al listar eventos masivos: $e',
        );
      }
      throw ApiException(
        'readingObjectError',
        'Error al listar eventos masivos: $e',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        'readingObjectError',
        'Formato de respuesta no soportado',
      );
    }
    final rawList = (decoded['items'] as List? ?? const []);
    final items =
        rawList
            .map<MassiveEventModel>(
              (e) => MassiveEventModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
    final outPage = int.tryParse('${decoded['page'] ?? page}') ?? page;
    final outLimit =
        int.tryParse('${decoded['limit'] ?? limit}') ?? limit;
    final outTotal =
        int.tryParse('${decoded['total'] ?? items.length}') ?? items.length;
    final outHasMore = decoded['hasMore'] == true;
    return MassiveEventsPageResult(
      outPage,
      outLimit,
      outTotal,
      outHasMore,
      items,
    );
  }

  /// Todas las páginas del listado autónomo (hasta 500 filas por petición).
  ///
  /// [from], [to], [name] y [status] se envían en cada página (misma semántica
  /// que en [listStandaloneMassiveEventsPaged]).
  static Future<List<MassiveEventModel>> listStandaloneMassiveEvents({
    String? from,
    String? to,
    String? name,
    String status = 'all',
  }) async {
    final merged = <MassiveEventModel>[];
    var page = 1;
    const batch = 500;
    const maxPages = 200;
    while (page <= maxPages) {
      final chunk = await listStandaloneMassiveEventsPaged(
        page: page,
        limit: batch,
        from: from,
        to: to,
        name: name,
        status: status,
      );
      merged.addAll(chunk.items);
      if (!chunk.hasMore) {
        break;
      }
      page++;
    }
    return merged;
  }

  static Future<SimpleEventModel> updateSimpleEvent({
    required SimpleEventModel simpleEvent,
    required String endpoint,
  }) async {
    final String baseUrl = BasicApiService.getApiBaseUrl();
    dynamic decodedJson;
    if (simpleEvent.data != null) {
      try {
        decodedJson = jsonDecode(simpleEvent.data!);
      } catch (e) {
        throw Exception('⚠️ data inválido para SimpleEvent: $e');
      }
    }
    final payload = {"data": decodedJson, "isActive": simpleEvent.isActive};
    var response;
    try {
      response = await BasicApiService.authorizedPut(
        Uri.parse('$baseUrl/$endpoint/${simpleEvent.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al actualizar SimpleEvent: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al actualizar SimpleEvent: $e',
      );
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final simpleEventSaved = SimpleEventModel.fromJson(data);
        return simpleEventSaved;
      } catch (e) {
        throw Exception(
          '⚠️ Respuesta JSON inválida al actualizar SimpleEvent: $e',
        );
      }
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

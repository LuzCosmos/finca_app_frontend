import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class CattlePageResult {
  final int page, limit, total;
  final bool hasMore;
  final List<Map<String, dynamic>> items;

  CattlePageResult(this.page, this.limit, this.total, this.hasMore, this.items);
}

class CattleMasterService {
  final String baseUrl = BasicApiService.getApiBaseUrl();

  /// Fetch all cattle for the tenant (paged)
  Future<CattlePageResult> getCattleList({int page = 1, int limit = 10}) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse(
      '$baseUrl/cattle',
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});
    var response;
    try {
      response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al listar ganado: $e',
        );
      }
      throw ApiException('readingObjectError', 'Error al listar ganado: $e');
    }
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Fallback si el backend aún devuelve lista plana (durante migración)
      if (decoded is List) {
        final list = decoded.cast<Map<String, dynamic>>();
        return CattlePageResult(1, list.length, list.length, false, list);
      }
      // Estructura PagedResponseDto
      final rawList = (decoded['items'] as List? ?? []);
      final items = rawList.cast<Map<String, dynamic>>();
      final outPage = int.tryParse('${decoded['page'] ?? page}') ?? 1;
      final outLimit = int.tryParse('${decoded['limit'] ?? limit}') ?? 10;
      final outTotal =
          int.tryParse('${decoded['total'] ?? items.length}') ?? items.length;
      final bool outHasMore =
          (outPage * outLimit) < outTotal; // O usar decoded['hasMore']
      return CattlePageResult(outPage, outLimit, outTotal, outHasMore, items);
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  /// Fetch all configured colors
  Future<List<String>> getColors() async {
    try {
      final token = await BasicApiService.getToken();
      final url = Uri.parse('$baseUrl/color-characteristics/color');
      var response;
      try {
        response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        if (e is SocketException || e is http.ClientException) {
          throw ApiException(
            'serverConnectionError',
            'Error al listar colores: $e',
          );
        }
        throw ApiException('readingObjectError', 'Error al listar colores: $e');
      }
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body.cast<String>();
        } else {
          print('Error: /color-characteristics/color returned non-list: $body');
        }
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      throw ApiException('readingObjectError', 'Error al listar colores: $e');
    }
    return [];
  }

  /// Fetch all configured characteristics
  Future<List<String>> getCharacteristics() async {
    try {
      final token = await BasicApiService.getToken();
      final url = Uri.parse('$baseUrl/color-characteristics/characteristic');
      var response;
      try {
        response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        if (e is SocketException || e is http.ClientException) {
          throw ApiException(
            'serverConnectionError',
            'Error al listar características: $e',
          );
        }
        throw ApiException(
          'readingObjectError',
          'Error al listar características: $e',
        );
      }

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body.cast<String>();
        } else {
          print(
            'Error: /color-characteristics/characteristic returned non-list: $body',
          );
        }
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      throw ApiException(
        'readingObjectError',
        'Error al listar características: $e',
      );
    }
    return [];
  }

  /// Update cattle data
  Future<Map<String, dynamic>?> updateCattle(
    String id,
    Map<String, dynamic> data,
  ) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle/$id');
    print('Updating cattle $id with data: $data');
    var response;
    try {
      response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al actualizar ganado: $e',
        );
      }
      throw ApiException('savingObjectError', 'Error al actualizar ganado: $e');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode != 204) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
    return null;
  }

  /// Add medication to cattle
  Future<Map<String, dynamic>?> addMedication(
    String id,
    Map<String, dynamic> data,
  ) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle/$id/medication');
    print('Adding medication to cattle $id with data: $data');
    var response;
    try {
      response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al agregar medicamento: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al agregar medicamento: $e',
      );
    }
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  /// Search cattle by query
  Future<List<Map<String, dynamic>>> searchCattle(String query) async {
    try {
      final token = await BasicApiService.getToken();
      final url = Uri.parse(
        '$baseUrl/cattle/search',
      ).replace(queryParameters: {'q': query});
      var response;
      try {
        response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        if (e is SocketException || e is http.ClientException) {
          throw ApiException(
            'serverConnectionError',
            'Error searching cattle: $e',
          );
        }
        throw ApiException('readingObjectError', 'Error searching cattle: $e');
      }
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.cast<Map<String, dynamic>>();
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } catch (e) {
      if (e is ApiException) throw e;
      throw ApiException('readingObjectError', 'Error searching cattle: $e');
    }
  }
}

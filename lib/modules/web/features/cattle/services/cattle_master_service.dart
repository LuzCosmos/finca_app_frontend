import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class CattlePageResult {
  final int page, limit, total;
  final bool hasMore;
  final List<Map<String, dynamic>> items;

  CattlePageResult(
    this.page,
    this.limit,
    this.total,
    this.hasMore,
    this.items,
  );
}

class CattleMasterService {
  final String baseUrl = BasicApiService.baseUrl;

  /// Fetch all cattle for the tenant (paged)
  Future<CattlePageResult> getCattleList({int page = 1, int limit = 10}) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle').replace(queryParameters: {
      'page': '$page',
      'limit': '$limit',
    });
    
    print('Fetching cattle from: $url');
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
      throw ApiException(
        'listingError',
        'Error al listar ganado: $e',
      );
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
      final outTotal = int.tryParse('${decoded['total'] ?? items.length}') ?? items.length;
      final bool outHasMore = (outPage * outLimit) < outTotal; // O usar decoded['hasMore']

      return CattlePageResult(
        outPage,
        outLimit,
        outTotal,
        outHasMore,
        items,
      );
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
      return CattlePageResult(page, limit, 0, false, []);
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
        throw ApiException(
          'listingError',
          'Error al listar colores: $e',
        );
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
      print('Exception fetching colors: $e');
    }
    return [];
  }

  /// Fetch all configured characteristics
  Future<List<String>> getCharacteristics() async {
    try {
      final token = await BasicApiService.getToken();
      final url = Uri.parse('$baseUrl/color-characteristics/characteristic');
      var response;
      response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body.cast<String>();
        } else {
            print('Error: /color-characteristics/characteristic returned non-list: $body');
        }
      } else {
         print('Error fetching characteristics: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
       print('Exception fetching characteristics: $e');
    }
    return [];
  }

  /// Update cattle data
  Future<Map<String, dynamic>?> updateCattle(String id, Map<String, dynamic> data) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle/$id');
    print('Updating cattle $id with data: $data');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode != 204) {
       print('Error updating cattle: ${response.statusCode} - ${response.body}');
       throw Exception('Failed to update cattle: ${response.body}');
    }
    return null;
  }

  /// Add medication to cattle
  Future<Map<String, dynamic>?> addMedication(String id, Map<String, dynamic> data) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle/$id/medication');
    print('Adding medication to cattle $id with data: $data');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
       print('Error adding medication: ${response.statusCode} - ${response.body}');
       throw Exception('Failed to add medication: ${response.body}');
    }
  }
}

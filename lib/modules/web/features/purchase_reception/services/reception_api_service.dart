import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class ReceptionApiService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}/purchase-receptions';
  final Map<String, String> defaultHeaders;

  ReceptionApiService({required this.defaultHeaders});

  Future<Map<String, dynamic>> getPurchaseReception(String purchaseId) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$baseUrl/$purchaseId');
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
          'Error al obtener purchase reception: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al obtener purchase reception: $e',
      );
    }
    if (response != null) {
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw ApiException(
            'savingObjectError',
            'Error al obtener purchase reception: $e',
          );
        }
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } else {
      throw ApiException(
        'savingObjectError',
        'Get purchase reception: Response is null.',
      );
    }
  }

  Future<Map<String, dynamic>> receiveOne({
    required String receptionId,
    required String purchaseId,
    required String number,
    double? weightKg,
    String? lotId,
    String? colorId,
    List<String>? characteristicsIds,
    String? eartag,
    String? trackerId,
    List<String>? simpleEventIds,
  }) async {
    final body = {
      'purchaseId': purchaseId,
      'number': number,
      if (weightKg != null) 'weightKg': weightKg,
      'lotId': lotId,
      'colorId': colorId,
      'characteristicsIds': characteristicsIds ?? [],
      'eartag': eartag,
      'trackerId': trackerId,
      'simpleEventIds': simpleEventIds ?? [],
    };
    final r = await http.post(
      Uri.parse('$baseUrl/$receptionId/receive'),
      headers: {...defaultHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (r.statusCode >= 400) throw Exception('Error receive: ${r.body}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<void> reassignLot({
    required String purchaseId,
    required String animalId,
    String? lotId,
  }) async {
    final r = await http.patch(
      Uri.parse('$baseUrl/$purchaseId/cattle/$animalId/lot'),
      headers: {...defaultHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode({'lotId': lotId}),
    );
    if (r.statusCode >= 400) throw Exception('Error reasignar lote: ${r.body}');
  }

  Future<List<Map<String, dynamic>>> listAnimalEvents(String animalId) async {
    final r = await http.get(
      Uri.parse('$baseUrl/animals/$animalId/simple-events'),
      headers: defaultHeaders,
    );
    if (r.statusCode >= 400) throw Exception('Error list events: ${r.body}');
    final data = jsonDecode(r.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> patchAnimalEvents({
    required String animalId,
    required String massEventId,
    List<String> addIds = const [],
    List<String> removeIds = const [],
  }) async {
    final r = await http.patch(
      Uri.parse('$baseUrl/animals/$animalId/simple-events'),
      headers: {...defaultHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'massEventId': massEventId,
        'addIds': addIds,
        'removeIds': removeIds,
      }),
    );
    if (r.statusCode >= 400) throw Exception('Error patch events: ${r.body}');
  }
}

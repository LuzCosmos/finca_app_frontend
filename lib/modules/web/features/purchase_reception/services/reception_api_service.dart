import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';

class ReceptionApiService {
  final String baseUrl =
      '${BasicApiService.getApiBaseUrl()}/purchase-receptions';
  ReceptionApiService();

  Future<List<DeviceModel>> searchDevices(String query) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/search-devices/by-query?q=$query');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => DeviceModel.fromJson(item)).toList();
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<bool> checkCattleNumberExists(String number) async {
    final token = await BasicApiService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/number-exists?number=$number'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] as bool;
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<bool> checkEartagExists(String eartag) async {
    final token = await BasicApiService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/eartag-exists?eartag=$eartag'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] as bool;
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<Map<String, dynamic>> getPurchaseReception(String purchaseId) async {
    final token = await BasicApiService.getToken();
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
    required String idPurchase,
    required String number,
    double? receivedWeight,
    double? purchaseWeight,
    double? purchasePrice,
    bool? hasHorn,
    bool? castrated,
    String? idLot,
    String? color,
    List<String>? characteristics,
    String? eartag,
    String? idDevice,
    String? idProvider,
    String? comments,
    String? gender,
    String? age,
    List<String>? idSimpleEvents,
  }) async {
    final token = await BasicApiService.getToken();
    final body = {
      'idPurchase': idPurchase,
      'number': number,
      if (receivedWeight != null) 'receivedWeight': receivedWeight,
      if (purchaseWeight != null) 'purchaseWeight': purchaseWeight,
      if (purchasePrice != null) 'purchasePrice': purchasePrice,
      'hasHorn': hasHorn,
      'castrated': castrated,
      'gender': gender,
      'age': age,
      'idLot': idLot,
      'color': color,
      'characteristics': characteristics ?? [],
      'eartag': eartag,
      'idDevice': idDevice,
      'idProvider': idProvider,
      'comments': comments,
      'idSimpleEvents': idSimpleEvents ?? [],
    };
    final r = await http.post(
      Uri.parse('$baseUrl/receive-cattle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (r.statusCode == 201 || r.statusCode == 200) {
      final responseBody = jsonDecode(r.body) as Map<String, dynamic>;
      return responseBody;
    }
    if (r.statusCode >= 400) {
      BasicApiService.manageNotSuccessResponseCode(r);
    }

    throw Exception('Unexpected status code: ${r.statusCode}');
  }

  Future<void> reassignLot({
    required String purchaseId,
    required String animalId,
    required String lotId,
  }) async {
    final token = await BasicApiService.getToken();
    final r = await http.patch(
      Uri.parse('$baseUrl/assign-lot-cattle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'idLot': lotId, 'idCattle': animalId}),
    );
    if (r.statusCode >= 400) throw Exception('Error reasignar lote: ${r.body}');
  }

  Future<List<Map<String, dynamic>>> listAnimalEvents(String animalId) async {
    final token = await BasicApiService.getToken();
    final r = await http.get(
      Uri.parse('$baseUrl/animals/$animalId/simple-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
    final token = await BasicApiService.getToken();
    final r = await http.patch(
      Uri.parse('$baseUrl/animals/$animalId/simple-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'massEventId': massEventId,
        'addIds': addIds,
        'removeIds': removeIds,
      }),
    );
    if (r.statusCode >= 400) throw Exception('Error patch events: ${r.body}');
  }

  Future<void> updateStatus(String purchaseId, String status) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse(
      '${BasicApiService.getApiBaseUrl()}/purchase-receptions/purchase-status/$purchaseId',
    );
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode >= 400) {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

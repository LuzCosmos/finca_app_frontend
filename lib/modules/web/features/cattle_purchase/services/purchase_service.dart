import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/services/api_exception.dart';

class PurchaseService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}/purchases';

  Future<void> createPurchase({
    required String idProvider,
    required DateTime purchaseDate,
    required List<Map<String, dynamic>> lots,
  }) async {
    final token = await SessionService.getToken();
    final url = Uri.parse(baseUrl);

    final body = jsonEncode({
      "idProvider": idProvider,
      "purchaseDate": purchaseDate.toIso8601String(),
      "lots": lots,
    });
    var response;
    try {
      response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
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
    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      throw ApiException('invalidData', 'Invalid data');
    } else if (response.statusCode == 401) {
      throw ApiException('unauthorized', 'Unauthorized');
    } else if (response.statusCode == 403) {
      throw ApiException('forbidden', 'Forbidden');
    } else if (response.statusCode == 500) {
      throw ApiException('serverError', 'Internal server error');
    } else {
      throw ApiException('unknownError', 'Unknown error');
    }
  }
}

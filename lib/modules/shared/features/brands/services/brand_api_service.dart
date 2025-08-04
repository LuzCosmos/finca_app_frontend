import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'dart:io';

class BrandApiService {
  static get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static Future<List<BrandModel>> loadBrands() async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }
    var response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/brands'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => BrandModel.fromJson(e)).toList();
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

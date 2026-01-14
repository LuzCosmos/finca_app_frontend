import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class CattleMasterService {
  final String baseUrl = BasicApiService.baseUrl;

  /// Fetch all cattle for the tenant
  Future<List<Map<String, dynamic>>> getCattleList() async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle'); // Assuming this endpoint exists or similar
    
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
      return [];
    }
  }

  /// Fetch all configured colors
  Future<List<Map<String, dynamic>>> getColors() async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/colors'); // Assuming /colors exists

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  /// Fetch all configured characteristics
  Future<List<Map<String, dynamic>>> getCharacteristics() async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/characteristics');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class CattleMasterService {
  final String baseUrl = BasicApiService.baseUrl;

  /// Fetch all cattle for the tenant
  Future<List<Map<String, dynamic>>> getCattleList() async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse('$baseUrl/cattle');
    
    print('Fetching cattle from: $url');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
      return [];
    }
  }

  /// Fetch all configured colors
  Future<List<String>> getColors() async {
    try {
      final token = await BasicApiService.getToken();
      final url = Uri.parse('$baseUrl/color-characteristics/color');

      final response = await http.get(
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
             print('Error: /color-characteristics/color returned non-list: $body');
        }
      } else {
         print('Error fetching colors: ${response.statusCode} - ${response.body}');
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

      final response = await http.get(
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
}

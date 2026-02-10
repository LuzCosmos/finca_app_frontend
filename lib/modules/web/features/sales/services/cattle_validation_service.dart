import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

/// Cattle Validation Service
///
/// Handles cattle validation and weight management API calls
class CattleValidationService {
  /// Validate cattle by number
  /// Returns cattle data if valid and ACTIVE
  /// Throws exception with user-friendly message if invalid
  static Future<Map<String, dynamic>> validateCattleByNumber(
    String number,
  ) async {
    final token = await SessionService.getToken();
    final baseUrl = BasicApiService.baseUrl;

    final response = await http.get(
      Uri.parse('$baseUrl/cattle/validate-number/$number'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      // Cattle validation failed (not found, not ACTIVE, etc.)
      final error = json.decode(response.body);
      throw Exception(error['message']);
    } else {
      throw Exception('Failed to validate cattle');
    }
  }

  /// Record weight in history
  static Future<void> recordWeightHistory({
    required String cattleId,
    required double weight,
    required DateTime measuredDate,
    String context = 'SALE',
  }) async {
    final token = await SessionService.getToken();
    final baseUrl = BasicApiService.baseUrl;

    final response = await http.post(
      Uri.parse('$baseUrl/cattle/$cattleId/weight-history'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'weight': weight,
        'measuredDate': measuredDate.toIso8601String(),
        'context': context,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to record weight history');
    }
  }

  /// Update cattle current weight
  static Future<void> updateCattleWeight({
    required String cattleId,
    required double weight,
  }) async {
    final token = await SessionService.getToken();
    final baseUrl = BasicApiService.baseUrl;

    final response = await http.put(
      Uri.parse('$baseUrl/cattle/$cattleId/weight'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'weight': weight}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cattle weight');
    }
  }

  /// Bulk update cattle status to SOLD
  static Future<Map<String, dynamic>> bulkUpdateCattleStatus({
    required List<String> cattleIds,
    required String status,
  }) async {
    final token = await SessionService.getToken();
    final baseUrl = BasicApiService.baseUrl;

    final response = await http.put(
      Uri.parse('$baseUrl/cattle/bulk-status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'cattleIds': cattleIds, 'status': status}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update cattle status');
    }
  }
}

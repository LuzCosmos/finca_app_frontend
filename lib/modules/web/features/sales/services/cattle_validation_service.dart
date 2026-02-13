import 'dart:convert';
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
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await BasicApiService.authorizedGet(
      Uri.parse('$baseUrl/cattle/validate-number/$number'),
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
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await BasicApiService.authorizedPost(
      Uri.parse('$baseUrl/cattle/$cattleId/weight-history'),
      headers: {
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
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await BasicApiService.authorizedPut(
      Uri.parse('$baseUrl/cattle/$cattleId/weight'),
      headers: {
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
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await BasicApiService.authorizedPut(
      Uri.parse('$baseUrl/cattle/bulk-status'),
      headers: {
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

import 'dart:convert';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/models/latest_cattle_location_model.dart';

class LocationsApiService {
  static final String _baseUrl = BasicApiService.getApiBaseUrl();

  static Future<List<LatestCattleLocationModel>> getLatestCattleLocations() async {
    final url = Uri.parse('$_baseUrl/locations/latest/cattle');

    final response = await BasicApiService.authorizedGet(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      return body
          .map((dynamic item) => LatestCattleLocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    BasicApiService.manageNotSuccessResponseCode(response);
    return [];
  }
}


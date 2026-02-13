import 'dart:convert';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';

class DeviceApiService {
  // Assuming the search endpoint is shared/accessible. Currently it is under 'purchase-receptions'.
  // However, looking at ReceptionController, it calls `receptionsService.searchDevices`.
  // Ideally, there should be a `devices` endpoint.
  // Analyzing `ReceptionController`: @Get('search-devices/by-query')
  // We can reuse this endpoint for now, or if a dedicated devices module exists in backend, use that.
  // The user prompt mentioned "changes in backend also if necessary".
  // For now, I will reuse the existing endpoint used by ReceiveCattleForm to ensure consistency as requested.
  // Endpoint: /purchase-receptions/search-devices/by-query?q=...

  // Wait, `BasicApiService.baseUrl` usually points to `/api`.
  // The reception service appended `/purchase-receptions`.
  // I should probably make this service generic enough or point to the correct endpoint.

  static final String _baseUrl = BasicApiService.getApiBaseUrl();

  static Future<List<DeviceModel>> searchDevices(String query) async {
    // Using the same endpoint as ReceptionApiService for now to ensure exact same behavior
    final url = Uri.parse(
      '$_baseUrl/purchase-receptions/search-devices/by-query?q=$query',
    );

    final response = await BasicApiService.authorizedGet(
      url,
      headers: {
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
}

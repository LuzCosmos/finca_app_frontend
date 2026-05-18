import 'dart:convert';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_list_item_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/import_lw001_result_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  /// Resumen para listado administrativo (`GET /devices/list-summary`).
  static Future<List<DeviceListItemModel>> listSummary() async {
    final url = Uri.parse('$_baseUrl/devices/list-summary');
    final response = await BasicApiService.authorizedGet(
      url,
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      return body
          .map(
            (dynamic item) =>
                DeviceListItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

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

  static Future<List<DeviceProfileOption>> listDeviceProfiles() async {
    final url = Uri.parse('$_baseUrl/device-profiles');
    final response = await BasicApiService.authorizedGet(
      url,
      headers: const {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      return body
          .map(
            (dynamic item) =>
                DeviceProfileOption.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }
    BasicApiService.manageNotSuccessResponseCode(response);
  }

  static Future<ImportLw001ResultModel> importLw001({
    required List<int> fileBytes,
    required String filename,
    String? deviceProfileId,
  }) async {
    final uri = Uri.parse('$_baseUrl/devices/import');
    final fields = <String, String>{};
    if (deviceProfileId != null && deviceProfileId.trim().isNotEmpty) {
      fields['deviceProfileId'] = deviceProfileId.trim();
    }

    final response = await BasicApiService.authorizedMultipart(
      buildRequest: (token) {
        final request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields.addAll(fields)
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              fileBytes,
              filename: filename,
              contentType: _guessMediaType(filename),
            ),
          );
        return request;
      },
    );

    final httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(httpResponse.body) as Map<String, dynamic>;
      return ImportLw001ResultModel.fromJson(body);
    }
    BasicApiService.manageNotSuccessResponseCode(httpResponse);
  }

  static MediaType _guessMediaType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.csv')) {
      return MediaType('text', 'csv');
    }
    if (lower.endsWith('.xls')) {
      return MediaType(
        'application',
        '/vnd.ms-excel',
      );
    }
    return MediaType(
      'application',
      'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/utils/logger.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class ProviderService {
  final String baseUrl = '${BasicApiService.baseUrl}/providers';

  Future<List<ProviderModel>> searchByNit(String query) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$baseUrl/search/by-nit?query=$query');
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
          'Error al crear MassiveEvent: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al crear MassiveEvent: $e',
      );
    }
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      final List<ProviderModel> providers =
          list.map((item) => ProviderModel.fromJson(item)).toList();
      return providers;
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<ProviderModel> create({
    required String name,
    required String nit,
  }) async {
    final token = await SessionService.getToken();
    final url = Uri.parse(baseUrl);
    var response;
    try {
      response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'nit': nit}),
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
      return ProviderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw ApiException('providerCreationDuplicateNit', 'Nit already exists');
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

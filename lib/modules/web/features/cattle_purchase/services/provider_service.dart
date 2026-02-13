import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/provider.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class ProviderService {
  final String baseUrl = '${BasicApiService.getApiBaseUrl()}/providers';

  Future<List<ProviderModel>> searchByNit(String query) async {
    final url = Uri.parse('$baseUrl/search/by-nit?query=$query');
    var response;
    try {
      response = await BasicApiService.authorizedGet(
        url,
        headers: {
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
    required String type,
  }) async {
    final url = Uri.parse(baseUrl);
    var response;
    try {
      response = await BasicApiService.authorizedPost(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'nit': nit, 'type': type}),
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

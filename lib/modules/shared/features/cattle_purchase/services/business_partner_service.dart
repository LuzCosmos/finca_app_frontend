import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class BusinessPartnerService {
  final String baseUrl = '${BasicApiService.getApiBaseUrl()}/business-partners';

  Future<List<BusinessPartnerModel>> searchByNit(String query) async {
    final url = Uri.parse('$baseUrl/search/by-nit?query=$query');
    http.Response response;
    try {
      response = await BasicApiService.authorizedGet(
        url,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException('serverConnectionError', 'Error de conexión: $e');
      }
      throw ApiException('savingObjectError', 'Error al buscar tercero: $e');
    }
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((item) => BusinessPartnerModel.fromJson(item)).toList();
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<BusinessPartnerModel> create({
    required String name,
    required String nit,
    required String role,
  }) async {
    final url = Uri.parse(baseUrl);
    http.Response response;
    try {
      response = await BasicApiService.authorizedPost(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'nit': nit, 'type': role}),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException('serverConnectionError', 'Error de conexión: $e');
      }
      throw ApiException('savingObjectError', 'Error al crear tercero: $e');
    }
    if (response.statusCode == 201) {
      return BusinessPartnerModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw ApiException(
        'providerCreationDuplicateNit',
        'Nit already exists',
      );
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

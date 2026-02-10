import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class SalesDataSourceWeb implements ISalesDataSource {
  final String baseUrl = BasicApiService.baseUrl;
  @override
  Future<void> fetchCatalogs() async {
    // No-op for web if we fetch on demand, or implement caching if needed.
  }

  @override
  Future<dynamic> getCattleByNumber(String number) async {
    // Web implementation: Call simple event or cattle find API
    // For now, stub or minimal implementation if Create Sale is used on Web
    return null;
  }

  @override
  Future<List> getProviders(String type) async {
    final token = await BasicApiService.getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/providers'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.where((p) => p['type'] == type).toList();
    }
    return [];
  }

  @override
  Future<List<SaleModel>> getUnsyncedSales() async {
    return []; // Web is always synced
  }

  @override
  Future<void> saveSale(SaleModel sale) async {
    final token = await BasicApiService.getToken();
    var response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/sales'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(sale.toJsonCreate()),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al obtener purchase reception: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al obtener purchase reception: $e',
      );
    }
    if (response != null) {
      if (response.statusCode != 201 && response.statusCode != 200) {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } else {
      throw ApiException('savingObjectError', 'Save sale: Response is null.');
    }
  }

  @override
  Future<void> syncSales() async {
    // No-op
  }

  @override
  Future<PaginatedSales> getSales(SalesQuery query) async {
    final token = await BasicApiService.getToken();
    final uri = Uri.parse(
      '$baseUrl/sales',
    ).replace(queryParameters: query.toQueryParameters());
    var response;
    try {
      response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al obtener sales: $e',
        );
      }
      throw ApiException('readingObjectError', 'Error al obtener sales: $e');
    }
    if (response != null) {
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          return PaginatedSales.fromJson(jsonDecode(response.body));
        } catch (e) {
          throw ApiException(
            'readingObjectError',
            'Error al obtener sales: $e',
          );
        }
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } else {
      throw ApiException(
        'readingObjectError',
        'Fail to fetch sales: Response is null.',
      );
    }
  }

  @override
  Future<void> updateSale(String id, Map<String, dynamic> updates) async {
    final baseUrl = BasicApiService.baseUrl;
    if (baseUrl.isEmpty) throw Exception('API_URL is not configured');

    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No session found. Please login.');
    }

    final res = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );
    if (res.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }
}

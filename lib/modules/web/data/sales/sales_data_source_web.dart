import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class SalesDataSourceWeb implements ISalesDataSource {
  final String baseUrl = BasicApiService.getApiBaseUrl();
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
  Future<List> getBusinessPartners(String type) async {
    final res = await BasicApiService.authorizedGet(
      Uri.parse('$baseUrl/business-partners'),
    );
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.where((p) => p['type'] == type).toList();
    }
    return [];
  }

  @override
  Future<void> saveSale(SaleModel sale) async {
    var response;
    try {
      response = await BasicApiService.authorizedPost(
        Uri.parse('$baseUrl/sales'),
        headers: {
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
  Future<PaginatedSales> getSales(SalesQuery query) async {
    final uri = Uri.parse(
      '$baseUrl/sales',
    ).replace(queryParameters: query.toQueryParameters());
    var response;
    try {
      response = await BasicApiService.authorizedGet(
        uri,
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
  Future<SaleModel> getSaleById(String id) async {
    var response;
    try {
      response = await BasicApiService.authorizedGet(
        Uri.parse('$baseUrl/sales/$id'),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al obtener venta: $e',
        );
      }
      throw ApiException('readingObjectError', 'Error al obtener venta: $e');
    }
    if (response == null) {
      throw ApiException('readingObjectError', 'Get sale: Response is null.');
    }
    if (response.statusCode == 200) {
      return SaleModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    BasicApiService.manageNotSuccessResponseCode(response);
    throw ApiException('readingObjectError', 'Failed to load sale');
  }

  @override
  Future<void> updateSale(String id, SaleModel sale) async {
    if (baseUrl.isEmpty) throw Exception('API_URL is not configured');

    final res = await BasicApiService.authorizedPut(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sale.toJsonCreate()),
    );
    if (res.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }
}

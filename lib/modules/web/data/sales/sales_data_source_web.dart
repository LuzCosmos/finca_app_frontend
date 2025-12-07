import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';

class SalesDataSourceWeb implements ISalesDataSource {
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
    final baseUrl = dotenv.env['API_BASE_URL'];
    final token = await SessionService.getToken();
    if (baseUrl == null || token == null) return [];

    final res = await http.get(Uri.parse('$baseUrl/providers'), 
      headers: {'Authorization': 'Bearer $token'});
    
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      // Filter by type if backend doesn't support query param? Backend returns all.
      // We filter locally.
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
    // Direct API call
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) throw Exception('API_URL is not configured');

    final token = await SessionService.getToken();
    if (token == null) throw Exception('No session found. Please login.');

    final res = await http.post(
      Uri.parse('$baseUrl/sales'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sale.toJson()), // SaleModel toJson structure must match Backend DTO
    );

    if (res.statusCode != 201) {
      if (res.statusCode == 401) throw Exception('Unauthorized (401)');
      throw Exception('Failed to save sale: ${res.body}');
    }
  }

  @override
  Future<void> syncSales() async {
    // No-op
  }

  @override
  Future<PaginatedSales> getSales(SalesQuery query) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) throw Exception('API_URL is not configured');
    
    final token = await SessionService.getToken();
    if (token == null) throw Exception('No session found. Please login.');

    final uri = Uri.parse('$baseUrl/sales').replace(queryParameters: query.toQueryParameters());
    final res = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (res.statusCode == 200) {
      return PaginatedSales.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 401) {
      throw Exception('Unauthorized (401)');
    } else {
      throw Exception('Failed to fetch sales: ${res.body}');
    }
  }

  @override
  Future<void> updateSale(String id, Map<String, dynamic> updates) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl == null) throw Exception('API_URL is not configured');

    final token = await SessionService.getToken();
    if (token == null) throw Exception('No session found. Please login.');

    final res = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );

    if (res.statusCode != 200) {
      if (res.statusCode == 401) throw Exception('Unauthorized (401)');
      throw Exception('Failed to update sale: ${res.body}');
    }
  }
}

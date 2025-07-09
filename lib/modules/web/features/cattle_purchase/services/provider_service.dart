import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/services/session_service.dart';
import '../models/provider.dart';
import '../../../../../core/services/exceptions.dart';

class ProviderService {
  static const String _baseUrl = 'http://localhost:3000/api/v1/providers';

  /// Busca proveedor por NIT. Retorna null si no existe.
  static Future<Map<String, dynamic>?> getByNit(String nit) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$_baseUrl/nit/$nit');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 404) {
      return null; // Proveedor no encontrado
    }
    throw Exception('Error fetching provider by NIT: ${response.body}');
  }

  static Future<List<ProviderModel>> searchByNit(String query) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$_baseUrl/search/by-nit?query=$query');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((item) => ProviderModel.fromJson(item)).toList();
    }
    throw Exception('Error searching providers: ${response.body}');
  }

  /// Crea un nuevo proveedor con nombre y nit
  static Future<Map<String, dynamic>> create({
    required String name,
    required String nit,
  }) async {
    final token = await SessionService.getToken();
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'nit': nit}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 409) {
      throw ProviderCreationException('providerCreationDuplicateNit');
    } else {
      throw ProviderCreationException('providerCreationGenericError');
    }
    //throw Exception('Error creating provider: ${response.body}');
  }
}

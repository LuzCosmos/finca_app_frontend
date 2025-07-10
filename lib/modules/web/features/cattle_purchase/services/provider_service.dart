import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/services/session_service.dart';
import '../models/provider.dart';
import '../../../../../core/services/exceptions.dart';

class ProviderService {
  final String baseUrl;

  ProviderService({this.baseUrl = 'http://localhost:3000/api/v1'});

  Future<List<ProviderModel>> searchByNit(String query) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$baseUrl/providers/search/by-nit?query=$query');
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
    } else {
      throw Exception('Failed to load providers');
      //throw Exception('Error searching providers: ${response.body}');
    }
  }

  Future<ProviderModel> create({
    required String name,
    required String nit,
  }) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$baseUrl/providers');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'nit': nit}),
    );
    if (response.statusCode == 201) {
      return ProviderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw ProviderCreationException('providerCreationDuplicateNit');
    } else {
      throw ProviderCreationException('providerCreationGenericError');
    }
  }
}

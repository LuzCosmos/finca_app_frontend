import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/services/session_service.dart';
import '../models/provider.dart';
import '../../../../../core/services/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProviderService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}/providers';

  Future<List<ProviderModel>> searchByNit(String query) async {
    final token = await SessionService.getToken();
    final url = Uri.parse('$baseUrl/search/by-nit?query=$query');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      final List<ProviderModel> providers =
          list.map((item) => ProviderModel.fromJson(item)).toList();
      return providers;
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
    final url = Uri.parse(baseUrl);
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

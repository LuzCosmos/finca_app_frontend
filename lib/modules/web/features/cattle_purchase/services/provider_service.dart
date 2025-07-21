import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/services/session_service.dart';
import '../models/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../core/services/api_exception.dart';
import '../../../../../core/utils/logger.dart';

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
    logger.d('url: $url');
    logger.d('token: $token');
    logger.d('response: ${response.statusCode}');
    logger.d('response: ${response.body}');
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      final List<ProviderModel> providers =
          list.map((item) => ProviderModel.fromJson(item)).toList();
      return providers;
    } else {
      if (response.statusCode == 401) {
        throw ApiException('unauthorized', 'Unauthorized');
      } else if (response.statusCode == 403) {
        throw ApiException('forbidden', 'Forbidden');
      } else {
        throw ApiException('unknownError', 'Unknown error');
      }
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
      throw ApiException('providerCreationDuplicateNit', 'Nit already exists');
    } else if (response.statusCode == 500) {
      throw ApiException('serverError', 'Internal server error');
    } else {
      logger.e('Unknown error: ${response.body}');
      throw ApiException('unknownError', 'Unknown error');
    }
  }
}

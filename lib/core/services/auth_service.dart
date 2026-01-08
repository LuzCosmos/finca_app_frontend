import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/models/user_model.dart';
import 'auth_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class AuthService {
  final http.Client client;
  AuthService({http.Client? client}) : client = client ?? http.Client();
  static String get _baseUrl => '${BasicApiService.baseUrl}/auth/login';

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'company_username': companyUsername,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      final token = data['access_token'];
      final permissions = data['permissions'];
      final idTenant = data['tenant_id'];
      return {
        'user': user,
        'token': token,
        'permissions': permissions,
        'idTenant': idTenant,
      };
    } else if (response.statusCode == 401) {
      throw AuthException('invalidCredentials');
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/models/user_model.dart';
import 'package:finca_app_frontend/core/services/auth_service.dart';

String _jwtWithExp(int expUnix) {
  final header = base64Url.encode(
    utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})),
  );
  final payload = base64Url.encode(
    utf8.encode(jsonEncode({'exp': expUnix})),
  );
  return '$header.$payload.dummy';
}

/// `AuthService` que no hace HTTP; devuelve sesión coherente para `LoginForm`.
class IntegrationFakeAuthService extends AuthService {
  IntegrationFakeAuthService() : super(client: http.Client());

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final token = _jwtWithExp(now + 86400);
    return {
      'user': User(
        id: 'u-integration-ui',
        username: username,
        firstName: 'Integration',
        lastName: 'UI',
        email: 'ui@integration.test',
        idTenant: 't-integration',
        roles: const <Role>[],
      ),
      'token': token,
      'refreshToken': 'rt-integration-ui',
      'permissions': {
        'MASSIVE_EVENTS': {'massive_events': true},
        'COMMERCE': {'purchases': true, 'sales': true},
        'EMP_MGMT': {'users': true},
        'FARM': {'cattle': true},
        'PROD_CENTER': {'devices': true},
      },
      'idTenant': 't-integration',
    };
  }
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/services/business_partner_service.dart';

String _jwtWithExp(int offsetSeconds) {
  final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + offsetSeconds;
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': exp})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

Future<void> _hydrateAuth() async {
  await SessionService.saveSession(
    token: _jwtWithExp(7200),
    permissions: {},
    idTenant: 'tid',
    idUser: 'u',
    refreshToken: 'rt',
  );
  BasicApiService.setBaseUrl('https://api-bp.test/api/v1');
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  group('BusinessPartnerService', () {
    test('searchByNit usa /business-partners/search/by-nit', () async {
      await _hydrateAuth();
      Uri? requested;

      await http.runWithClient(() async {
        final service = BusinessPartnerService();
        final list = await service.searchByNit('9001');
        expect(list, hasLength(1));
        expect(list.first.nit, '900123');
      }, () {
        return MockClient((req) async {
          requested = req.url;
          return http.Response(
            jsonEncode([
              {
                'id': 'bp-1',
                'name': 'Partner',
                'nit': '900123',
                'type': 'PROVIDER',
              },
            ]),
            200,
          );
        });
      });

      expect(requested!.path, contains('/business-partners/search/by-nit'));
      expect(requested!.queryParameters['query'], '9001');
    });

    test('create POST a /business-partners con type en body', () async {
      await _hydrateAuth();
      Map<String, dynamic>? body;

      await http.runWithClient(() async {
        final service = BusinessPartnerService();
        final created = await service.create(
          name: 'Nuevo',
          nit: '900555',
          role: 'PROVIDER',
        );
        expect(created.name, 'Nuevo');
      }, () {
        return MockClient((req) async {
          expect(req.method, 'POST');
          expect(req.url.path, endsWith('/business-partners'));
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'id': 'bp-new',
              'name': 'Nuevo',
              'nit': '900555',
              'type': 'PROVIDER',
            }),
            201,
          );
        });
      });

      expect(body!['type'], 'PROVIDER');
    });

    test('create 409 lanza ApiException providerCreationDuplicateNit', () async {
      await _hydrateAuth();

      await http.runWithClient(() async {
        final service = BusinessPartnerService();
        expect(
          () => service.create(name: 'X', nit: 'dup', role: 'BUYER'),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'providerCreationDuplicateNit'),
          ),
        );
      }, () {
        return MockClient((_) async => http.Response('conflict', 409));
      });
    });
  });
}

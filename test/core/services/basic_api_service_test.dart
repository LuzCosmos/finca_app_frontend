import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/basic_api_service_env_stub.dart'
    as web_env_stub;
import 'package:finca_app_frontend/core/services/session_service.dart';

// Bajo prueba:
// - lib/core/services/basic_api_service.dart
// - lib/core/services/basic_api_service_env_stub.dart (solo helpers window ENV en VM)
// - (interacción con lib/core/services/session_service.dart para token / refresh)

String _jwtWithExp(int expUnix) {
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': expUnix})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

Future<void> _saveValidSession(String token) async {
  await SessionService.saveSession(
    token: token,
    permissions: {},
    idTenant: 't',
    idUser: 'u',
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  group('BasicApiService.getApiBaseUrl', () {
    tearDown(dotenv.clean);

    test('con base ya fijada devuelve _baseUrl sin tocar dotenv', () {
      BasicApiService.setBaseUrl('https://fixed.test/api');
      dotenv.loadFromString(envString: 'API_BASE_URL=https://ignored.test');
      expect(BasicApiService.getApiBaseUrl(), 'https://fixed.test/api');
    });

    test(
      'dotenv: BACKEND_URL + API_BASE_URL relativo → URL absoluta concatenada',
      () {
        dotenv.loadFromString(
          envString: '''
BACKEND_URL=https://backend.test
API_BASE_URL=/api/v1
''',
        );
        expect(
          BasicApiService.getApiBaseUrl(),
          'https://backend.test/api/v1',
        );
      },
    );

    test('dotenv: solo API_BASE_URL absoluta sin BACKEND_URL', () {
      dotenv.loadFromString(
        envString: 'API_BASE_URL=https://api.only.test/v2',
      );
      expect(BasicApiService.getApiBaseUrl(), 'https://api.only.test/v2');
    });

    test(
      'dotenv: sin API_BASE_URL usa /api/v1 (y sin BACKEND_URL se asigna tal cual)',
      () {
        dotenv.loadFromString(envString: 'OTHER=1');
        expect(BasicApiService.getApiBaseUrl(), '/api/v1');
      },
    );

    test(
      'IO stub: readWebApiBaseUrlFromWindow es null (web real usa window.ENV)',
      () {
        expect(web_env_stub.readWebApiBaseUrlFromWindow(), isNull);
      },
    );
  });

  group('BasicApiService.getToken', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('sin sesión lanza ApiException unauthorized', () async {
      await expectLater(
        BasicApiService.getToken(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiExceptionCode.unauthorized.name,
          ),
        ),
      );
    });

    test('con JWT no expirado devuelve el mismo token', () async {
      final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
      final token = _jwtWithExp(exp);
      await _saveValidSession(token);
      final got = await BasicApiService.getToken();
      expect(got, token);
    });

    test(
      'con JWT expirado y refresh OK actualiza sesión y devuelve nuevo access',
      () async {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final expired = _jwtWithExp(now - 60);
        final fresh = _jwtWithExp(now + 3600);
        await SessionService.saveSession(
          token: expired,
          permissions: {},
          idTenant: 't',
          idUser: 'u',
          refreshToken: 'refresh-1',
        );

        await http.runWithClient(() async {
          final got = await BasicApiService.getToken();
          expect(got, fresh);
          expect(await SessionService.getToken(), fresh);
        }, () {
          return MockClient((request) async {
            expect(request.method, equals('POST'));
            expect(
              request.url.toString(),
              equals('https://test.example/auth/refresh'),
            );
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(body['refresh_token'], 'refresh-1');
            return http.Response(
              jsonEncode({
                'access_token': fresh,
                'refresh_token': 'refresh-2',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          });
        });
      },
    );

    test('refresh con error de red devuelve unauthorized', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expired = _jwtWithExp(now - 60);
      await SessionService.saveSession(
        token: expired,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'refresh-1',
      );

      await http.runWithClient(() async {
        await expectLater(
          BasicApiService.getToken(),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.unauthorized.name,
            ),
          ),
        );
      }, () {
        return MockClient((request) async {
          throw http.ClientException('sin red', request.url);
        });
      });
    });

    test('refresh con respuesta 500 devuelve unauthorized', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expired = _jwtWithExp(now - 60);
      await SessionService.saveSession(
        token: expired,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'r',
      );

      await http.runWithClient(() async {
        await expectLater(
          BasicApiService.getToken(),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.unauthorized.name,
            ),
          ),
        );
      }, () {
        return MockClient((request) async {
          return http.Response('err', 500);
        });
      });
    });
  });

  group('BasicApiService.authorizedGet', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('GET 200', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        final r = await BasicApiService.authorizedGet(
          Uri.parse('https://test.example/api/foo'),
        );
        expect(r.statusCode, 200);
        expect(r.body, 'ok');
      }, () {
        return MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.headers['Authorization'], 'Bearer $token');
          return http.Response('ok', 200);
        });
      });
    });

    test('401 en GET → refresh → segundo GET con nuevo bearer', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final initial = _jwtWithExp(now + 3600);
      final afterRefresh = _jwtWithExp(now + 7200);
      await SessionService.saveSession(
        token: initial,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );

      var getCount = 0;
      await http.runWithClient(() async {
        final r = await BasicApiService.authorizedGet(
          Uri.parse('https://test.example/api/foo'),
        );
        expect(r.statusCode, 200);
        expect(r.body, 'second');
        expect(getCount, 2);
      }, () {
        return MockClient((request) async {
          if (request.method == 'GET' &&
              request.url.path == '/api/foo') {
            getCount++;
            if (getCount == 1) {
              return http.Response('unauth', 401);
            }
            expect(request.headers['Authorization'], 'Bearer $afterRefresh');
            return http.Response('second', 200);
          }
          if (request.method == 'POST' &&
              request.url.path == '/auth/refresh') {
            return http.Response(
              jsonEncode({'access_token': afterRefresh}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          fail('request inesperado: ${request.method} ${request.url}');
        });
      });
    });

    test('ClientException en GET se propaga', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        await expectLater(
          BasicApiService.authorizedGet(Uri.parse('https://test.example/x')),
          throwsA(isA<http.ClientException>()),
        );
      }, () {
        return MockClient((request) async {
          throw http.ClientException('offline', request.url);
        });
      });
    });
  });

  group('BasicApiService authorizedPost / Patch / Put / Delete', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    Future<void> checkMethod(
      String method,
      Future<http.Response> Function() call,
    ) async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        final r = await call();
        expect(r.statusCode, 201);
        expect(r.body, 'created');
      }, () {
        return MockClient((request) async {
          expect(request.method, method);
          expect(request.headers['Authorization'], 'Bearer $token');
          if (method != 'DELETE') {
            expect(request.body, contains('payload'));
          }
          return http.Response('created', 201);
        });
      });
    }

    test('POST con body JSON', () async {
      await checkMethod(
        'POST',
        () => BasicApiService.authorizedPost(
          Uri.parse('https://test.example/res'),
          body: jsonEncode({'payload': true}),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('PATCH con body', () async {
      await checkMethod(
        'PATCH',
        () => BasicApiService.authorizedPatch(
          Uri.parse('https://test.example/res/1'),
          body: '{"payload":1}',
        ),
      );
    });

    test('PUT con body', () async {
      await checkMethod(
        'PUT',
        () => BasicApiService.authorizedPut(
          Uri.parse('https://test.example/res/1'),
          body: '{"payload":"put"}',
        ),
      );
    });

    test('DELETE sin body', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        final r = await BasicApiService.authorizedDelete(
          Uri.parse('https://test.example/res/1'),
        );
        expect(r.statusCode, 204);
      }, () {
        return MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.headers['Authorization'], 'Bearer $token');
          return http.Response('', 204);
        });
      });
    });

    test('POST propagates ClientException', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        await expectLater(
          BasicApiService.authorizedPost(
            Uri.parse('https://test.example/p'),
            body: '{}',
          ),
          throwsA(isA<http.ClientException>()),
        );
      }, () {
        return MockClient((request) async {
          throw http.ClientException('fail', request.url);
        });
      });
    });
  });

  group('BasicApiService.authorizedMultipart', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('MultipartRequest 200 con bearer del token', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await _saveValidSession(token);

      await http.runWithClient(() async {
        final streamed = await BasicApiService.authorizedMultipart(
          buildRequest: (t) {
            final req = http.MultipartRequest(
              'POST',
              Uri.parse('https://test.example/upload'),
            );
            req.headers['Authorization'] = 'Bearer $t';
            req.fields['name'] = 'file.txt';
            return req;
          },
        );
        expect(streamed.statusCode, 200);
      }, () {
        return MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/upload');
          return http.Response('ok', 200);
        });
      });
    });

    test('401 en multipart → refresh → segundo send', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final initial = _jwtWithExp(now + 3600);
      final afterRefresh = _jwtWithExp(now + 7200);
      await SessionService.saveSession(
        token: initial,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );

      var sends = 0;
      await http.runWithClient(() async {
        final streamed = await BasicApiService.authorizedMultipart(
          buildRequest: (t) {
            final req = http.MultipartRequest(
              'POST',
              Uri.parse('https://test.example/up'),
            );
            req.headers['Authorization'] = 'Bearer $t';
            return req;
          },
        );
        expect(streamed.statusCode, 200);
        expect(sends, 2);
      }, () {
        return MockClient((request) async {
          if (request.method == 'POST' && request.url.path == '/up') {
            sends++;
            if (sends == 1) {
              return http.Response('nope', 401);
            }
            expect(
              request.headers['Authorization'],
              'Bearer $afterRefresh',
            );
            return http.Response('fine', 200);
          }
          if (request.method == 'POST' &&
              request.url.path == '/auth/refresh') {
            return http.Response(
              jsonEncode({'access_token': afterRefresh}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          fail('unexpected ${request.method} ${request.url}');
        });
      });
    });
  });

  group('BasicApiService.manageNotSuccessResponseCode', () {
    test('400 → badRequest', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response(jsonEncode({'message': 'generic'}), 400),
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiExceptionCode.badRequest.name,
          ),
        ),
      );
    });

    test('400 cattleIsNotActive', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response(
            jsonEncode({'message': 'cattleIsNotActive'}),
            400,
          ),
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiExceptionCode.cattleIsNotActive.name,
          ),
        ),
      );
    });

    test('400 código de sync de ventas pasa como código ApiException', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response(
            jsonEncode({'message': 'INVALID_SALE_PRICE'}),
            400,
          ),
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'INVALID_SALE_PRICE',
          ),
        ),
      );
    });

    test('401, 403, 404, 409, 422, 423, 500 mapean a códigos esperados', () {
      final cases = <int, String>{
        401: ApiExceptionCode.unauthorized.name,
        403: ApiExceptionCode.forbidden.name,
        404: ApiExceptionCode.notFound.name,
        409: ApiExceptionCode.conflictError.name,
        422: ApiExceptionCode.unprocessableEntity.name,
        423: ApiExceptionCode.locked.name,
        500: ApiExceptionCode.serverError.name,
      };
      for (final e in cases.entries) {
        expect(
          () => BasicApiService.manageNotSuccessResponseCode(
            http.Response(jsonEncode({'message': 'm'}), e.key),
          ),
          throwsA(
            isA<ApiException>().having((ex) => ex.code, 'code', e.value),
          ),
          reason: 'status ${e.key}',
        );
      }
    });

    test('código HTTP no contemplado → unknownError', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response('body', 418),
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiExceptionCode.unknownError.name,
          ),
        ),
      );
    });

    test(
      'body no JSON en 400 lanza (comportamiento actual; ver §5.4 hardening)',
      () {
        expect(
          () => BasicApiService.manageNotSuccessResponseCode(
            http.Response('<html>', 400),
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}

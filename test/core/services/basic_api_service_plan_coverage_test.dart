import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

// Bajo prueba: lib/core/services/basic_api_service.dart (casos del plan llm-plan-completar-service-tests)

String _jwtWithExp(int expUnix) {
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': expUnix})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
    dotenv.clean();
  });

  group('BasicApiService getToken / refresh (plan)', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('expirado sin refreshToken → unauthorized', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now - 30),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
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

    test('refresh JSON no objeto → unauthorized', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now - 10),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
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
        return MockClient((_) async {
          return http.Response('[1,2]', 200);
        });
      });
    });

    test('refresh sin access_token ni token → unauthorized', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await SessionService.saveSession(
        token: _jwtWithExp(now - 10),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
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
        return MockClient((_) async {
          return http.Response(jsonEncode({'other': 1}), 200);
        });
      });
    });

    test('refresh usa campo token en lugar de access_token', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fresh = _jwtWithExp(now + 3600);
      await SessionService.saveSession(
        token: _jwtWithExp(now - 20),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      await http.runWithClient(() async {
        final got = await BasicApiService.getToken();
        expect(got, fresh);
      }, () {
        return MockClient((_) async {
          return http.Response(jsonEncode({'token': fresh}), 200);
        });
      });
    });

    test('refresh refreshToken camelCase', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fresh = _jwtWithExp(now + 4000);
      await SessionService.saveSession(
        token: _jwtWithExp(now - 15),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'old',
      );
      await http.runWithClient(() async {
        await BasicApiService.getToken();
        expect(await SessionService.getRefreshToken(), 'newRt');
      }, () {
        return MockClient((_) async {
          return http.Response(
            jsonEncode({
              'access_token': fresh,
              'refreshToken': 'newRt',
            }),
            200,
          );
        });
      });
    });

    test('refresh permissions Map<dynamic,dynamic> se normaliza', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fresh = _jwtWithExp(now + 5000);
      await SessionService.saveSession(
        token: _jwtWithExp(now - 12),
        permissions: {'OLD': {}},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      await http.runWithClient(() async {
        await BasicApiService.getToken();
        final p = await SessionService.getPermissions();
        expect(p['X'], isA<Map>());
        expect(await SessionService.hasPermission('X', 'y'), true);
      }, () {
        return MockClient((_) async {
          return http.Response(
            jsonEncode({
              'access_token': fresh,
              'permissions': <dynamic, dynamic>{
                'X': <dynamic, dynamic>{'y': '11111'},
              },
            }),
            200,
          );
        });
      });
    });

    test('dos getToken concurrentes con expirado hacen un solo POST refresh', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fresh = _jwtWithExp(now + 9000);
      await SessionService.saveSession(
        token: _jwtWithExp(now - 5),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      var refreshPosts = 0;
      await http.runWithClient(() async {
        final a = BasicApiService.getToken();
        final b = BasicApiService.getToken();
        final tokens = await Future.wait([a, b]);
        expect(tokens[0], fresh);
        expect(tokens[1], fresh);
        expect(refreshPosts, 1);
      }, () {
        return MockClient((request) async {
          if (request.url.path == '/auth/refresh') {
            refreshPosts++;
            return http.Response(jsonEncode({'access_token': fresh}), 200);
          }
          return http.Response('n', 404);
        });
      });
    });
  });

  group('BasicApiService refreshAccessToken público', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('sin refresh en sesión → null', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 200,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      expect(await BasicApiService.refreshAccessToken(), isNull);
    });

    test('éxito devuelve access', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final fresh = _jwtWithExp(now + 3000);
      await SessionService.saveSession(
        token: _jwtWithExp(now + 100),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      await http.runWithClient(() async {
        final t = await BasicApiService.refreshAccessToken();
        expect(t, fresh);
      }, () {
        return MockClient((_) async {
          return http.Response(jsonEncode({'access_token': fresh}), 200);
        });
      });
    });

    test('HTTP 500 → null', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 50,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      await http.runWithClient(() async {
        expect(await BasicApiService.refreshAccessToken(), isNull);
      }, () {
        return MockClient((_) async {
          return http.Response('e', 500);
        });
      });
    });

    test('red caída → null', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 50,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      await http.runWithClient(() async {
        expect(await BasicApiService.refreshAccessToken(), isNull);
      }, () {
        return MockClient((r) async {
          throw http.ClientException('x', r.url);
        });
      });
    });
  });

  group('BasicApiService 401 → refresh en todos los verbos', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    Future<void> assertVerbRetry(
      String verb,
      Future<http.Response> Function(String afterRefresh) call,
    ) async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final init = _jwtWithExp(now + 500);
      final after = _jwtWithExp(now + 5000);
      await SessionService.saveSession(
        token: init,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      var hits = 0;
      await http.runWithClient(() async {
        final res = await call(after);
        expect(res.statusCode, 200);
        expect(res.body, 'ok2');
        expect(hits, 2);
      }, () {
        return MockClient((request) async {
          if (request.url.path == '/auth/refresh') {
            return http.Response(jsonEncode({'access_token': after}), 200);
          }
          if (request.url.path == '/r') {
            hits++;
            expect(request.headers['X-Custom'], 'v');
            if (hits == 1) {
              expect(request.method, verb);
              return http.Response('u', 401);
            }
            expect(request.headers['Authorization'], 'Bearer $after');
            expect(request.body, contains('payload'));
            return http.Response('ok2', 200);
          }
          fail('${request.method} ${request.url}');
        });
      });
    }

    test('POST', () async {
      await assertVerbRetry('POST', (_) async {
        return BasicApiService.authorizedPost(
          Uri.parse('https://test.example/r'),
          headers: {'X-Custom': 'v'},
          body: jsonEncode({'payload': 1}),
        );
      });
    });

    test('PATCH', () async {
      await assertVerbRetry('PATCH', (_) async {
        return BasicApiService.authorizedPatch(
          Uri.parse('https://test.example/r'),
          headers: {'X-Custom': 'v'},
          body: '{"payload":1}',
        );
      });
    });

    test('PUT', () async {
      await assertVerbRetry('PUT', (_) async {
        return BasicApiService.authorizedPut(
          Uri.parse('https://test.example/r'),
          headers: {'X-Custom': 'v'},
          body: '{"payload":1}',
        );
      });
    });

    test('DELETE', () async {
      await assertVerbRetry('DELETE', (_) async {
        return BasicApiService.authorizedDelete(
          Uri.parse('https://test.example/r'),
          headers: {'X-Custom': 'v'},
          body: '{"payload":1}',
        );
      });
    });
  });

  group('BasicApiService headers y encoding', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('Authorization del caller es reemplazada por Bearer del servicio', () async {
      final tok = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3000,
      );
      await SessionService.saveSession(
        token: tok,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      await http.runWithClient(() async {
        await BasicApiService.authorizedGet(
          Uri.parse('https://test.example/z'),
          headers: {'Authorization': 'Bearer spoof'},
        );
      }, () {
        return MockClient((request) async {
          expect(request.headers['Authorization'], 'Bearer $tok');
          return http.Response('ok', 200);
        });
      });
    });

    test('DELETE con body', () async {
      final tok = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 2000,
      );
      await SessionService.saveSession(
        token: tok,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      await http.runWithClient(() async {
        final r = await BasicApiService.authorizedDelete(
          Uri.parse('https://test.example/d'),
          body: 'x=y',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        );
        expect(r.statusCode, 204);
      }, () {
        return MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.body, 'x=y');
          return http.Response('', 204);
        });
      });
    });
  });

  group('BasicApiService authorizedMultipart retryOnUnauthorized', () {
    setUp(() => BasicApiService.setBaseUrl('https://test.example'));

    test('retryOnUnauthorized false devuelve 401 sin refresh', () async {
      final tok = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 4000,
      );
      await SessionService.saveSession(
        token: tok,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      var builds = 0;
      await http.runWithClient(() async {
        final s = await BasicApiService.authorizedMultipart(
          retryOnUnauthorized: false,
          buildRequest: (t) {
            builds++;
            final m = http.MultipartRequest(
              'POST',
              Uri.parse('https://test.example/m'),
            );
            m.headers['Authorization'] = 'Bearer $t';
            return m;
          },
        );
        expect(s.statusCode, 401);
        expect(builds, 1);
      }, () {
        return MockClient((_) async {
          return http.Response('n', 401);
        });
      });
    });

    test('401 con refresh fallido conserva 401 (un solo buildRequest)', () async {
      final tok = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 1000,
      );
      await SessionService.saveSession(
        token: tok,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'rt',
      );
      var up = 0;
      await http.runWithClient(() async {
        final s = await BasicApiService.authorizedMultipart(
          buildRequest: (t) {
            up++;
            final m = http.MultipartRequest(
              'POST',
              Uri.parse('https://test.example/up'),
            );
            m.headers['Authorization'] = 'Bearer $t';
            return m;
          },
        );
        expect(s.statusCode, 401);
        expect(up, 1);
      }, () {
        return MockClient((req) async {
          if (req.url.path == '/up') {
            return http.Response('no', 401);
          }
          if (req.url.path == '/auth/refresh') {
            return http.Response('fail', 500);
          }
          return http.Response('x', 400);
        });
      });
    });
  });

  group('BasicApiService manageNotSuccessResponseCode ampliación', () {
    test('404/409/422 preservan message string', () {
      final cases = <(int, String, String)>[
        (404, ApiExceptionCode.notFound.name, 'my404'),
        (409, ApiExceptionCode.conflictError.name, 'my409'),
        (422, ApiExceptionCode.unprocessableEntity.name, 'my422'),
      ];
      for (final entry in cases) {
        expect(
          () => BasicApiService.manageNotSuccessResponseCode(
            http.Response(jsonEncode({'message': entry.$3}), entry.$1),
          ),
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', entry.$2)
                .having((e) => e.message.toString(), 'msg', contains(entry.$3)),
          ),
        );
      }
    });

    test('400 vacío → badRequest', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response(jsonEncode({'message': ''}), 400),
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

    test('400 cada sale-sync code listado en servicio', () async {
      const codes = [
        'SOLD_CATTLE_MISSING_SALE_DETAIL',
        'SALE_FIELDS_ONLY_FOR_SOLD_CATTLE',
        'INVALID_SALE_PRICE',
        'INVALID_SALE_WEIGHT',
      ];
      for (final c in codes) {
        expect(
          () => BasicApiService.manageNotSuccessResponseCode(
            http.Response(jsonEncode({'message': c}), 400),
          ),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', c),
          ),
        );
      }
    });

    test('404 body no JSON → FormatException', () {
      expect(
        () => BasicApiService.manageNotSuccessResponseCode(
          http.Response('<html>', 404),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

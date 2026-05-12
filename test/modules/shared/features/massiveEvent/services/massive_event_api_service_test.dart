import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/services/massive_event_api_service.dart
//   (listStandaloneMassiveEvents / listStandaloneMassiveEventsPaged)

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
  BasicApiService.setBaseUrl('https://api-massive-list.test/api/v1');
}

Map<String, dynamic> _standaloneJson({
  required String id,
  String? name,
  bool linkedToPurchaseReception = false,
}) {
  return {
    'id': id,
    'idTenant': 'tid',
    'name': name,
    'createdBy': 'u1',
    'createdByUsername': 'alice',
    'eventDate': '2024-05-10T00:00:00.000Z',
    'simpleEvents': <dynamic>[],
    'status': 'open',
    'createdAt': '2024-05-10T10:00:00.000Z',
    'updatedAt': '2024-05-11T12:00:00.000Z',
    'linkedToPurchaseReception': linkedToPurchaseReception,
  };
}

String _pagedBody(
  List<Map<String, dynamic>> items, {
  int page = 1,
  int limit = 10,
  int? total,
  bool hasMore = false,
}) {
  return jsonEncode({
    'items': items,
    'page': page,
    'limit': limit,
    'total': total ?? items.length,
    'hasMore': hasMore,
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  group('MassiveEventApiService.listStandaloneMassiveEventsPaged', () {
    test('200 + items vacíos', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final r = await MassiveEventApiService.listStandaloneMassiveEventsPaged(
          page: 1,
          limit: 10,
        );
        expect(r.items, isEmpty);
        expect(r.total, 0);
        expect(r.hasMore, false);
      }, () {
        return MockClient((req) async {
          expect(req.method, 'GET');
          expect(req.url.path, contains('massive-events'));
          expect(req.url.queryParameters['page'], '1');
          expect(req.url.queryParameters['limit'], '10');
          return http.Response(_pagedBody([]), 200);
        });
      });
    });

    test('200 + dos ítems parsea modelos', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final r = await MassiveEventApiService.listStandaloneMassiveEventsPaged(
          page: 1,
          limit: 10,
        );
        expect(r.items, hasLength(2));
        expect(r.items[0].id, 'a');
        expect(r.items[0].name, 'Uno');
        expect(r.items[0].createdByUsername, 'alice');
        expect(r.items[0].linkedToPurchaseReception, false);
        expect(r.items[1].id, 'b');
        expect(r.items[1].linkedToPurchaseReception, true);
      }, () {
        return MockClient((_) async {
          return http.Response(
            _pagedBody([
              _standaloneJson(id: 'a', name: 'Uno'),
              _standaloneJson(
                id: 'b',
                name: 'Dos',
                linkedToPurchaseReception: true,
              ),
            ]),
            200,
          );
        });
      });
    });

    test('200 + cuerpo que no es objeto → ApiException', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        await expectLater(
          MassiveEventApiService.listStandaloneMassiveEventsPaged(
            page: 1,
            limit: 10,
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.readingObjectError.name,
            ),
          ),
        );
      }, () {
        return MockClient((_) async => http.Response('[]', 200));
      });
    });

    test('403 → ApiException forbidden', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        await expectLater(
          MassiveEventApiService.listStandaloneMassiveEventsPaged(
            page: 1,
            limit: 10,
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.forbidden.name,
            ),
          ),
        );
      }, () {
        return MockClient(
          (_) async => http.Response('{"message":"no"}', 403),
        );
      });
    });

    test('401 → ApiException unauthorized', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        await expectLater(
          MassiveEventApiService.listStandaloneMassiveEventsPaged(
            page: 1,
            limit: 10,
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.unauthorized.name,
            ),
          ),
        );
      }, () {
        return MockClient((_) async => http.Response('{}', 401));
      });
    });

    test('500 → ApiException serverError', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        await expectLater(
          MassiveEventApiService.listStandaloneMassiveEventsPaged(
            page: 1,
            limit: 10,
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiExceptionCode.serverError.name,
            ),
          ),
        );
      }, () {
        return MockClient((_) async => http.Response('err', 500));
      });
    });
  });

  group('MassiveEventApiService.listStandaloneMassiveEvents', () {
    test('agrega páginas hasta hasMore false', () async {
      await _hydrateAuth();
      var calls = 0;
      await http.runWithClient(() async {
        final list = await MassiveEventApiService.listStandaloneMassiveEvents();
        expect(list, hasLength(3));
        expect(calls, 2);
      }, () {
        return MockClient((req) async {
          calls++;
          expect(req.method, 'GET');
          expect(req.url.queryParameters['limit'], '500');
          final page = int.tryParse(req.url.queryParameters['page'] ?? '1') ?? 1;
          if (page == 1) {
            return http.Response(
              _pagedBody(
                [
                  _standaloneJson(id: '1'),
                  _standaloneJson(id: '2'),
                ],
                page: 1,
                limit: 500,
                total: 3,
                hasMore: true,
              ),
              200,
            );
          }
          expect(page, 2);
          return http.Response(
            _pagedBody(
              [_standaloneJson(id: '3')],
              page: 2,
              limit: 500,
              total: 3,
              hasMore: false,
            ),
            200,
          );
        });
      });
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';

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
  BasicApiService.setBaseUrl('https://api-reception.test/api/v1');
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
    BasicApiService.resetForTesting();
  });

  group('ReceptionApiService.updateReceivedCattle', () {
    test('PATCH 200 envía body completo al endpoint correcto', () async {
      await _hydrateAuth();
      Map<String, dynamic>? capturedBody;
      await http.runWithClient(() async {
        final api = ReceptionApiService();
        await api.updateReceivedCattle(
          cattleId: 'cattle-uuid',
          body: {
            'receivedWeight': 410.5,
            'idLot': 'lot-1',
            'hasHorn': true,
            'castrated': false,
            'gender': 'FEMALE',
            'color': 'BLACK',
            'characteristics': ['SPOTTED'],
            'eartagLeft': 'L1',
            'eartagRight': 'R1',
            'comments': 'ok',
            'idDevice': null,
            'birthDateAprx': '2019-01-01',
          },
        );
      }, () {
        return MockClient((req) async {
          expect(req.method, 'PATCH');
          expect(
            req.url.toString(),
            contains('/purchase-receptions/received-cattle/cattle-uuid'),
          );
          capturedBody = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response('{}', 200);
        });
      });
      expect(capturedBody!['receivedWeight'], 410.5);
      expect(capturedBody!['idLot'], 'lot-1');
      expect(capturedBody!['characteristics'], ['SPOTTED']);
      expect(capturedBody!['idDevice'], isNull);
    });

    test('PATCH 409 propaga ApiException', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final api = ReceptionApiService();
        expect(
          () => api.updateReceivedCattle(
            cattleId: 'c1',
            body: {'eartagLeft': 'DUP'},
          ),
          throwsA(isA<ApiException>()),
        );
      }, () {
        return MockClient((_) async {
          return http.Response(
            jsonEncode({
              'statusCode': 409,
              'message': 'Eartag DUP is already assigned',
              'code': 'conflictError',
            }),
            409,
            headers: {'content-type': 'application/json'},
          );
        });
      });
    });

    test('PATCH 404 propaga error gestionado', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final api = ReceptionApiService();
        expect(
          () => api.updateReceivedCattle(
            cattleId: 'missing',
            body: {'receivedWeight': 1},
          ),
          throwsA(isA<ApiException>()),
        );
      }, () {
        return MockClient((_) async {
          return http.Response(
            jsonEncode({
              'statusCode': 404,
              'message': 'Cattle not found',
              'code': 'notFound',
            }),
            404,
            headers: {'content-type': 'application/json'},
          );
        });
      });
    });

    test('PATCH 500 lanza excepción', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final api = ReceptionApiService();
        expect(
          () => api.updateReceivedCattle(
            cattleId: 'c1',
            body: {'receivedWeight': 300},
          ),
          throwsA(isA<ApiException>()),
        );
      }, () {
        return MockClient((_) async => http.Response('error', 500));
      });
    });
  });

  group('ReceptionApiService.checkEartagExists', () {
    test('200 exists true/false', () async {
      await _hydrateAuth();
      await http.runWithClient(() async {
        final api = ReceptionApiService();
        expect(await api.checkEartagExists('E-1'), isTrue);
      }, () {
        return MockClient((_) async {
          return http.Response(jsonEncode({'exists': true}), 200);
        });
      });
    });
  });
}

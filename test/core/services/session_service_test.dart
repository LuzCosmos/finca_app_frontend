import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';

// Bajo prueba:
// - lib/core/services/session_service.dart

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
  });

  group('SessionService', () {
    test('sin hydrate: hasValidTokenSync es false', () {
      expect(SessionService.hasValidTokenSync(), false);
    });

    test('hydrateFromStorage vacío: hasValidTokenSync y getters async', () async {
      await SessionService.hydrateFromStorage();
      expect(SessionService.hasValidTokenSync(), false);
      expect(await SessionService.getToken(), isNull);
      expect(await SessionService.getRefreshToken(), isNull);
      expect(await SessionService.getPermissions(), <String, dynamic>{});
      expect(await SessionService.getIdTenant(), isNull);
      expect(await SessionService.getIdUser(), isNull);
    });

    test('saveSession persiste y hydrateFromStorage coherente con sync', () async {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final token = _jwtWithExp(now + 3600);
      await SessionService.saveSession(
        token: token,
        permissions: {'FARM': {'cattle': '11111'}},
        idTenant: 't1',
        idUser: 'u1',
        refreshToken: 'rt1',
      );
      expect(await SessionService.getToken(), token);
      expect(await SessionService.getRefreshToken(), 'rt1');
      expect(await SessionService.getIdTenant(), 't1');
      expect(await SessionService.getIdUser(), 'u1');
      final perms = await SessionService.getPermissions();
      expect(perms['FARM'], isA<Map>());
      SessionService.resetForTesting();
      SharedPreferences.setMockInitialValues({
        'access_token': token,
        'refresh_token': 'rt1',
        'user_permissions': jsonEncode({'FARM': {'cattle': '11111'}}),
        'id_tenant': 't1',
        'id_user': 'u1',
      });
      await SessionService.hydrateFromStorage();
      expect(SessionService.hasValidTokenSync(), true);
      expect(await SessionService.getToken(), token);
    });

    test('hydrateFromStorage con permissions JSON inválido → mapa vacío', () async {
      SharedPreferences.setMockInitialValues({
        'user_permissions': 'not-json',
      });
      SessionService.resetForTesting();
      await SessionService.hydrateFromStorage();
      expect(await SessionService.getPermissions(), <String, dynamic>{});
    });

    test('cleanSession borra claves y cache', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await SessionService.saveSession(
        token: token,
        permissions: {'A': {}},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'r',
      );
      await SessionService.cleanSession();
      expect(await SessionService.getToken(), isNull);
      expect(await SessionService.getRefreshToken(), isNull);
      expect(await SessionService.getPermissions(), <String, dynamic>{});
      expect(await SessionService.getIdTenant(), isNull);
      expect(await SessionService.getIdUser(), isNull);
      expect(SessionService.hasValidTokenSync(), false);
    });

    test('updateSessionTokens actualiza access y opcionales', () async {
      final t1 = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      );
      await SessionService.saveSession(
        token: t1,
        permissions: {'m': {}},
        idTenant: 't',
        idUser: 'u',
      );
      final t2 = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 7200,
      );
      await SessionService.updateSessionTokens(
        accessToken: t2,
        refreshToken: 'nr',
        permissions: {'m': {'r': '11000'}},
      );
      expect(await SessionService.getToken(), t2);
      expect(await SessionService.getRefreshToken(), 'nr');
      expect(
        await SessionService.hasActionPermission('m', 'r', 'read'),
        true,
      );
    });

    test('hasPermission y hasActionPermission', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 60,
        ),
        permissions: {
          'COMMERCE': {'sales': '11101'},
        },
        idTenant: 't',
        idUser: 'u',
      );
      expect(await SessionService.hasPermission('COMMERCE', 'sales'), true);
      expect(await SessionService.hasPermission('OTHER', 'x'), false);
      expect(
        await SessionService.hasActionPermission('COMMERCE', 'sales', 'read'),
        true,
      );
      expect(
        await SessionService.hasActionPermission('COMMERCE', 'sales', 'delete'),
        false,
      );
    });

    test('token expirado: hasValidTokenSync false con skew', () async {
      final past = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 100;
      final token = _jwtWithExp(past);
      await SessionService.saveSession(
        token: token,
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      expect(
        SessionService.isTokenExpired(token, skewSeconds: 0),
        true,
      );
      expect(SessionService.hasValidTokenSync(), false);
    });

    test('logout devuelve true tras sesión válida', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 120,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      expect(await SessionService.logout(), true);
      expect(await SessionService.getToken(), isNull);
    });
  });
}

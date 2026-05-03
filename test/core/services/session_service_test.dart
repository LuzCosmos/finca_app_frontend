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

/// JWT con payload JSON arbitrario (firma dummy).
String _jwtFromPayload(Map<String, dynamic> payload) {
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none'})))
      .replaceAll('=', '');
  final p = base64Url
      .encode(utf8.encode(jsonEncode(payload)))
      .replaceAll('=', '');
  return '$header.$p.sig';
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

  group('SessionService getTokenExpirationUnix', () {
    test('exp entero', () {
      final exp = 1700000000;
      final unix = SessionService.getTokenExpirationUnix(
        _jwtFromPayload({'exp': exp}),
      );
      expect(unix, exp);
    });

    test('exp string numérico', () {
      final exp = 1700000000;
      final unix = SessionService.getTokenExpirationUnix(
        _jwtFromPayload({'exp': '$exp'}),
      );
      expect(unix, exp);
    });

    test('sin exp retorna null', () {
      expect(SessionService.getTokenExpirationUnix(_jwtFromPayload({})), isNull);
    });

    test('payload inválido (no JSON al decodificar) retorna null', () {
      final header = base64Url.encode(utf8.encode('{}')).replaceAll('=', '');
      final badPayload = base64Url.encode(utf8.encode('not-json')).replaceAll('=', '');
      expect(
        SessionService.getTokenExpirationUnix('$header.$badPayload.sig'),
        isNull,
      );
    });

    test('menos de 3 partes retorna null', () {
      expect(SessionService.getTokenExpirationUnix('a.b'), isNull);
    });

    test('más de 3 partes retorna null', () {
      expect(SessionService.getTokenExpirationUnix('a.b.c.d'), isNull);
    });

    test('exp tipo inválido retorna null', () {
      expect(
        SessionService.getTokenExpirationUnix(_jwtFromPayload({'exp': true})),
        isNull,
      );
    });
  });

  group('SessionService isTokenExpired (skew y opaco)', () {
    test('sin exp no expira', () {
      expect(SessionService.isTokenExpired(_jwtFromPayload({})), false);
    });

    test('futuro → false', () {
      final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 10000;
      expect(SessionService.isTokenExpired(_jwtWithExp(exp), skewSeconds: 0), false);
    });

    test('vencimiento dentro de skew → true', () {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final exp = now + 10;
      expect(
        SessionService.isTokenExpired(_jwtWithExp(exp), skewSeconds: 30),
        true,
      );
    });

    test('pasado sin skew → true', () {
      final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 10;
      expect(SessionService.isTokenExpired(_jwtWithExp(exp), skewSeconds: 0), true);
    });
  });

  group('SessionService hasValidToken e isAuthenticated', () {
    test('sin token → false', () async {
      expect(await SessionService.hasValidToken(), false);
      expect(await SessionService.isAuthenticated(), false);
    });

    test('con token (aunque expirado) → true (solo existencia)', () async {
      final past = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 100;
      await SessionService.saveSession(
        token: _jwtWithExp(past),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      expect(await SessionService.hasValidToken(), true);
      expect(await SessionService.isAuthenticated(), true);
    });
  });

  group('SessionService updateSessionTokens preservación', () {
    test('refreshToken null conserva refresh anterior', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 1000,
        ),
        permissions: {'m': {}},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'keep-me',
      );
      final newAccess = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 2000,
      );
      await SessionService.updateSessionTokens(accessToken: newAccess);
      expect(await SessionService.getRefreshToken(), 'keep-me');
    });

    test('permissions null conserva mapa anterior', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 500,
        ),
        permissions: {'A': {'x': '11111'}},
        idTenant: 't',
        idUser: 'u',
      );
      final newAccess = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
      );
      await SessionService.updateSessionTokens(accessToken: newAccess);
      final p = await SessionService.getPermissions();
      expect(p['A'], isA<Map>());
      expect(await SessionService.hasPermission('A', 'x'), true);
    });

    test('refreshToken vacío no actualiza prefs ni borra explícito', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 400,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'prev',
      );
      final next = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 800,
      );
      await SessionService.updateSessionTokens(
        accessToken: next,
        refreshToken: '',
      );
      expect(await SessionService.getRefreshToken(), 'prev');
    });
  });

  group('SessionService saveSession refresh opcional', () {
    test('refresh null elimina refresh en prefs', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'x',
      );
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 901,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
      );
      expect(await SessionService.getRefreshToken(), isNull);
    });

    test('refresh vacío no persiste refresh (caché puede quedar string vacío)', () async {
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 902,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: 'x',
      );
      await SessionService.saveSession(
        token: _jwtWithExp(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + 903,
        ),
        permissions: {},
        idTenant: 't',
        idUser: 'u',
        refreshToken: '',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('refresh_token'), isNull);
      expect(await SessionService.getRefreshToken(), '');
    });
  });

  group('SessionService cleanSession y persistencia', () {
    test('cleanSession + reset + hydrate sin datos', () async {
      final token = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 5000,
      );
      await SessionService.saveSession(
        token: token,
        permissions: {'K': {}},
        idTenant: 'ta',
        idUser: 'ua',
        refreshToken: 'rr',
      );
      await SessionService.cleanSession();
      SessionService.resetForTesting();
      await SessionService.hydrateFromStorage();
      expect(await SessionService.getToken(), isNull);
      expect(await SessionService.getRefreshToken(), isNull);
      expect(await SessionService.getIdTenant(), isNull);
      expect(SessionService.hasValidTokenSync(), false);
    });
  });

  group('SessionService hasActionPermission casos límite', () {
    setUp(() async {
      final tok = _jwtWithExp(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 8000,
      );
      await SessionService.saveSession(
        token: tok,
        permissions: {
          'M': {'r': '11111', 'short': '10', 'zero': '00000', 'x': 'nope'},
          'NOT_MAP': 'x',
          'BAD_MASK': {'x': 1},
        },
        idTenant: 't',
        idUser: 'u',
      );
    });

    test('acciones READ / Read / read equivalentes', () async {
      expect(
        await SessionService.hasActionPermission('M', 'r', 'READ'),
        true,
      );
      expect(
        await SessionService.hasActionPermission('M', 'r', 'Read'),
        true,
      );
      expect(
        await SessionService.hasActionPermission('M', 'r', 'read'),
        true,
      );
    });

    test('acción desconocida', () async {
      expect(
        await SessionService.hasActionPermission('M', 'r', 'purge'),
        false,
      );
    });

    test('módulo inexistente', () async {
      expect(
        await SessionService.hasActionPermission('Z', 'r', 'read'),
        false,
      );
    });

    test('resource inexistente', () async {
      expect(
        await SessionService.hasActionPermission('M', 'missing', 'read'),
        false,
      );
    });

    test('módulo no es Map', () async {
      expect(
        await SessionService.hasActionPermission('NOT_MAP', 'r', 'read'),
        false,
      );
    });

    test('máscara no es String', () async {
      expect(
        await SessionService.hasActionPermission('BAD_MASK', 'x', 'read'),
        false,
      );
    });

    test('máscara corta', () async {
      expect(
        await SessionService.hasActionPermission('M', 'short', 'read'),
        false,
      );
    });

    test('00000 todo false', () async {
      for (final a in ['create', 'read', 'update', 'delete', 'list']) {
        expect(
          await SessionService.hasActionPermission('M', 'zero', a),
          false,
        );
      }
    });

    test('11111 todo true', () async {
      for (final a in ['create', 'read', 'update', 'delete', 'list']) {
        expect(await SessionService.hasActionPermission('M', 'r', a), true);
      }
    });
  });
}

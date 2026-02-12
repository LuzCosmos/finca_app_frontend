import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _permissionsKey = 'user_permissions';
  static const _idTenantKey = 'id_tenant';
  static const _idUserKey = 'id_user';
  static Future<SharedPreferences>? _prefsFuture;
  static String? _cachedToken;
  static String? _cachedRefreshToken;
  static Map<String, dynamic>? _cachedPermissions;
  static String? _cachedIdTenant;
  static String? _cachedIdUser;
  static bool _tokenLoaded = false;
  static bool _refreshTokenLoaded = false;
  static bool _permissionsLoaded = false;
  static bool _idTenantLoaded = false;
  static bool _idUserLoaded = false;

  static Future<SharedPreferences> _prefs() {
    _prefsFuture ??= SharedPreferences.getInstance();
    return _prefsFuture!;
  }

  static Future<void> saveSession({
    required String token,
    required Map<String, dynamic> permissions,
    required String idTenant,
    required String idUser,
    String? refreshToken,
  }) async {
    final prefs = await _prefs();
    await prefs.setString(_tokenKey, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    } else {
      await prefs.remove(_refreshTokenKey);
    }
    await prefs.setString(_permissionsKey, jsonEncode(permissions));
    await prefs.setString(_idTenantKey, idTenant);
    await prefs.setString(_idUserKey, idUser);

    _cachedToken = token;
    _cachedRefreshToken = refreshToken;
    _cachedPermissions = Map<String, dynamic>.from(permissions);
    _cachedIdTenant = idTenant;
    _cachedIdUser = idUser;
    _tokenLoaded = true;
    _refreshTokenLoaded = true;
    _permissionsLoaded = true;
    _idTenantLoaded = true;
    _idUserLoaded = true;
  }

  static Future<String?> getToken() async {
    if (_tokenLoaded) return _cachedToken;
    final prefs = await _prefs();
    _cachedToken = prefs.getString(_tokenKey);
    _tokenLoaded = true;
    return _cachedToken;
  }

  static Future<String?> getRefreshToken() async {
    if (_refreshTokenLoaded) return _cachedRefreshToken;
    final prefs = await _prefs();
    _cachedRefreshToken = prefs.getString(_refreshTokenKey);
    _refreshTokenLoaded = true;
    return _cachedRefreshToken;
  }

  static Future<void> updateSessionTokens({
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? permissions,
  }) async {
    final prefs = await _prefs();
    await prefs.setString(_tokenKey, accessToken);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_refreshTokenKey, refreshToken);
      _cachedRefreshToken = refreshToken;
      _refreshTokenLoaded = true;
    }

    if (permissions != null) {
      await prefs.setString(_permissionsKey, jsonEncode(permissions));
      _cachedPermissions = Map<String, dynamic>.from(permissions);
      _permissionsLoaded = true;
    }

    _cachedToken = accessToken;
    _tokenLoaded = true;
  }

  static Future<Map<String, dynamic>> getPermissions() async {
    if (_permissionsLoaded) {
      return _cachedPermissions == null
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(_cachedPermissions!);
    }

    final prefs = await _prefs();
    final jsonString = prefs.getString(_permissionsKey);
    if (jsonString == null) {
      _cachedPermissions = <String, dynamic>{};
      _permissionsLoaded = true;
      return <String, dynamic>{};
    }

    try {
      _cachedPermissions = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      _cachedPermissions = <String, dynamic>{};
    }
    _permissionsLoaded = true;
    return Map<String, dynamic>.from(_cachedPermissions!);
  }

  static Future<String?> getIdTenant() async {
    if (_idTenantLoaded) return _cachedIdTenant;
    final prefs = await _prefs();
    _cachedIdTenant = prefs.getString(_idTenantKey);
    _idTenantLoaded = true;
    return _cachedIdTenant;
  }

  static Future<String?> getIdUser() async {
    if (_idUserLoaded) return _cachedIdUser;
    final prefs = await _prefs();
    _cachedIdUser = prefs.getString(_idUserKey);
    _idUserLoaded = true;
    return _cachedIdUser;
  }

  static Future<bool> hasPermission(String module, String resource) async {
    final permissions = await getPermissions();
    if (permissions[module] == null) return false;
    final moduleData = permissions[module];
    return moduleData is Map && moduleData.containsKey(resource);
  }

  static const Map<String, int> _actionIndex = {
    'create': 0,
    'read': 1,
    'update': 2,
    'delete': 3,
    'list': 4,
  };

  static Future<bool> hasActionPermission(
    String module,
    String resource,
    String action,
  ) async {
    final permissions = await getPermissions();
    final moduleValue = permissions[module];
    if (moduleValue is! Map) return false;
    final rawMask = moduleValue[resource];
    if (rawMask is! String) return false;
    final idx = _actionIndex[action.toLowerCase()];
    if (idx == null) return false;
    if (rawMask.length < 5) return false;
    return rawMask[idx] == '1';
  }

  static Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static int? getTokenExpirationUnix(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadJson = jsonDecode(decoded);
      if (payloadJson is! Map<String, dynamic>) return null;
      final exp = payloadJson['exp'];
      if (exp is int) return exp;
      if (exp is String) return int.tryParse(exp);
      return null;
    } catch (_) {
      return null;
    }
  }

  static bool isTokenExpired(String token, {int skewSeconds = 0}) {
    final exp = getTokenExpirationUnix(token);
    // If token is opaque or has no exp, keep current behavior (consider valid).
    if (exp == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= (exp - skewSeconds);
  }

  static Future<void> cleanSession() async {
    final prefs = await _prefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_permissionsKey);
    await prefs.remove(_idTenantKey);
    await prefs.remove(_idUserKey);
    _cachedToken = null;
    _cachedRefreshToken = null;
    _cachedPermissions = <String, dynamic>{};
    _cachedIdTenant = null;
    _cachedIdUser = null;
    _tokenLoaded = true;
    _refreshTokenLoaded = true;
    _permissionsLoaded = true;
    _idTenantLoaded = true;
    _idUserLoaded = true;
  }

  static Future<bool> logout() async {
    try {
      await cleanSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isAuthenticated() async {
    return await hasValidToken();
  }
}

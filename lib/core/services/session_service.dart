import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'access_token';
  static const _permissionsKey = 'user_permissions';
  static const _idTenantKey = 'id_tenant';
  static const _idUserKey = 'id_user';

  static Future<void> saveSession({
    required String token,
    required Map<String, dynamic> permissions,
    required String idTenant,
    required String idUser,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_permissionsKey, jsonEncode(permissions));
    await prefs.setString(_idTenantKey, idTenant);
    await prefs.setString(_idUserKey, idUser);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>> getPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_permissionsKey);
    if (jsonString == null) return {};
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Future<String?> getIdTenant() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idTenantKey);
  }

  static Future<String?> getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idUserKey);
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

  static Future<void> cleanSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_permissionsKey);
    await prefs.remove(_idTenantKey);
    await prefs.remove(_idUserKey);
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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'access_token';
  static const _permissionsKey = 'user_permissions';

  static Future<void> saveSession({
    required String token,
    required Map<String, dynamic> permissions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_permissionsKey, jsonEncode(permissions));
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

  static Future<bool> hasPermission(String module, String resource) async {
    final permissions = await getPermissions();
    if (permissions[module] == null) return false;
    final moduleData = permissions[module];
    return moduleData is Map && moduleData.containsKey(resource);
  }

  static Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_permissionsKey);
  }
}

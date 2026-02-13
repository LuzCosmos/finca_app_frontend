import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'dart:convert';
import 'dart:async';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BasicApiService {
  static String _baseUrl = '';
  static Future<String?>? _refreshTokenFuture;

  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static String getApiBaseUrl() {
    if (_baseUrl.isNotEmpty) {
      return _baseUrl;
    }
    if (kIsWeb) {
      if (js.context.hasProperty('ENV')) {
        final env = js.context['ENV'];
        // Verify if it is a JsObject (standard valid case)
        if (env is js.JsObject) {
          if (env.hasProperty('API_BASE_URL')) {
            final val = env['API_BASE_URL'];
            if (val != null &&
                val.toString().toLowerCase() != 'null' &&
                val.toString().trim().isNotEmpty) {
              setBaseUrl(val.toString());
              return _baseUrl;
            }
          } else {
            print(
              'BasicApiService: ENV object found but no API_BASE_URL property',
            );
          }
        } else {
          // Fallback for some browsers/compilers treating it as a Map/dynamic
          print('BasicApiService: ENV is not JsObject, trying dynamic read...');
          try {
            final val = (env as dynamic)['API_BASE_URL'];
            print('BasicApiService: dynamic read result: $val');
            if (val != null &&
                val.toString().toLowerCase() != 'null' &&
                val.toString().trim().isNotEmpty) {
              setBaseUrl(val.toString());
              return _baseUrl;
            }
          } catch (e) {
            print('BasicApiService: dynamic read failed: $e');
          }
        }
      } else {
        print('BasicApiService: window.ENV not found');
      }
    }
    // Fallback a dotenv (Development local o Mobile)
    setBaseUrl(dotenv.env['API_BASE_URL'] ?? '/api/v1');
    return _baseUrl;
  }

  static Future<String> getToken() async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw ApiException(ApiExceptionCode.unauthorized.name, 'Unauthorized');
    }
    if (!SessionService.isTokenExpired(token, skewSeconds: 30)) {
      return token;
    }

    final refreshedToken = await _refreshAccessToken();
    if (refreshedToken != null && refreshedToken.isNotEmpty) {
      return refreshedToken;
    }

    throw ApiException(ApiExceptionCode.unauthorized.name, 'Unauthorized');
  }

  static Future<http.Response> authorizedGet(
    Uri uri, {
    Map<String, String>? headers,
  }) {
    return _authorizedRequest(
      method: 'GET',
      uri: uri,
      headers: headers,
    );
  }

  static Future<http.Response> authorizedPost(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _authorizedRequest(
      method: 'POST',
      uri: uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  static Future<http.Response> authorizedPatch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _authorizedRequest(
      method: 'PATCH',
      uri: uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  static Future<http.Response> authorizedPut(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _authorizedRequest(
      method: 'PUT',
      uri: uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  static Future<http.Response> authorizedDelete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _authorizedRequest(
      method: 'DELETE',
      uri: uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  static Future<http.Response> _authorizedRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOnUnauthorized = true,
  }) async {
    final token = await getToken();
    final response = await _send(
      method: method,
      uri: uri,
      token: token,
      headers: headers,
      body: body,
      encoding: encoding,
    );

    if (response.statusCode == 401 && retryOnUnauthorized) {
      final refreshedToken = await _refreshAccessToken();
      if (refreshedToken != null && refreshedToken.isNotEmpty) {
        return _send(
          method: method,
          uri: uri,
          token: refreshedToken,
          headers: headers,
          body: body,
          encoding: encoding,
        );
      }
    }

    return response;
  }

  static Future<http.Response> _send({
    required String method,
    required Uri uri,
    required String token,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final requestHeaders = <String, String>{
      ...?headers,
      'Authorization': 'Bearer $token',
    };

    switch (method) {
      case 'GET':
        return http.get(uri, headers: requestHeaders);
      case 'POST':
        return http.post(
          uri,
          headers: requestHeaders,
          body: body,
          encoding: encoding,
        );
      case 'PATCH':
        return http.patch(
          uri,
          headers: requestHeaders,
          body: body,
          encoding: encoding,
        );
      case 'PUT':
        return http.put(
          uri,
          headers: requestHeaders,
          body: body,
          encoding: encoding,
        );
      case 'DELETE':
        return http.delete(
          uri,
          headers: requestHeaders,
          body: body,
          encoding: encoding,
        );
      default:
        throw ApiException(
          ApiExceptionCode.unknownError.name,
          'Unsupported HTTP method: $method',
        );
    }
  }

  static Future<http.StreamedResponse> authorizedMultipart({
    required http.MultipartRequest Function(String token) buildRequest,
    bool retryOnUnauthorized = true,
  }) async {
    final token = await getToken();
    var response = await buildRequest(token).send();
    if (response.statusCode == 401 && retryOnUnauthorized) {
      final refreshedToken = await _refreshAccessToken();
      if (refreshedToken != null && refreshedToken.isNotEmpty) {
        response = await buildRequest(refreshedToken).send();
      }
    }
    return response;
  }

  static Future<String?> _refreshAccessToken() async {
    if (_refreshTokenFuture != null) {
      return _refreshTokenFuture;
    }

    final refreshFuture = _performRefreshAccessToken();
    _refreshTokenFuture = refreshFuture;
    try {
      return await refreshFuture;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  static Future<String?> refreshAccessToken() {
    return _refreshAccessToken();
  }

  static Future<String?> _performRefreshAccessToken() async {
    final refreshToken = await SessionService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await http
          .post(
            Uri.parse('${getApiBaseUrl()}/auth/refresh'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        return null;
      }

      final newAccessToken = data['access_token'] ?? data['token'];
      if (newAccessToken is! String || newAccessToken.isEmpty) {
        return null;
      }

      final newRefreshToken = data['refresh_token'] ?? data['refreshToken'];
      final rawPermissions = data['permissions'];
      final updatedPermissions =
          rawPermissions is Map<String, dynamic>
              ? rawPermissions
              : (rawPermissions is Map
                  ? rawPermissions.map(
                    (key, value) => MapEntry(key.toString(), value),
                  )
                  : null);

      await SessionService.updateSessionTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken is String ? newRefreshToken : null,
        permissions: updatedPermissions,
      );
      return newAccessToken;
    } catch (_) {
      return null;
    }
  }

  static Never manageNotSuccessResponseCode(http.Response response) {
    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Bad request';
      if (message.isNotEmpty && message == 'cattleIsNotActive') {
        throw ApiException(
          ApiExceptionCode.cattleIsNotActive.name,
          'Cattle is not Active',
        );
      }
      throw ApiException(ApiExceptionCode.badRequest.name, 'Invalid data');
    } else if (response.statusCode == 401) {
      throw ApiException(ApiExceptionCode.unauthorized.name, 'Unauthorized');
    } else if (response.statusCode == 403) {
      throw ApiException(ApiExceptionCode.forbidden.name, 'Forbidden');
    } else if (response.statusCode == 404) {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Not found';
      throw ApiException(ApiExceptionCode.notFound.name, message);
    } else if (response.statusCode == 409) {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Conflict';
      throw ApiException(ApiExceptionCode.conflictError.name, message);
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Unprocessable entity';
      throw ApiException(ApiExceptionCode.unprocessableEntity.name, message);
    } else if (response.statusCode == 423) {
      throw ApiException(ApiExceptionCode.locked.name, 'Locked');
    } else if (response.statusCode == 500) {
      throw ApiException(
        ApiExceptionCode.serverError.name,
        'Internal server error',
      );
    }
    throw ApiException(
      ApiExceptionCode.unknownError.name,
      'Error in the request: ${response.statusCode} ${response.body}',
    );
  }
}

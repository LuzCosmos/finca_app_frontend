import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:http/http.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'dart:convert';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BasicApiService {
  static String _baseUrl = '';

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
    return token;
  }

  static Never manageNotSuccessResponseCode(Response response) {
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

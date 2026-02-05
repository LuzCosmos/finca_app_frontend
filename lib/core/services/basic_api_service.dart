import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:http/http.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BasicApiService {

  static String get baseUrl {
    if (kIsWeb) {
      if (js.context.hasProperty('ENV')) {
         print('BasicApiService: check ENV property...');
         final env = js.context['ENV'];
         // Verify if it is a JsObject (standard valid case)
         if (env is js.JsObject) {
            if (env.hasProperty('API_BASE_URL')) {
               final val = env['API_BASE_URL'];
               print('BasicApiService: ENV.API_BASE_URL found: $val');
               if (val != null && val.toString().toLowerCase() != 'null' && val.toString().trim().isNotEmpty) {
                 return val.toString();
               }
            } else {
               print('BasicApiService: ENV object found but no API_BASE_URL property');
            }
         } else {
            // Fallback for some browsers/compilers treating it as a Map/dynamic
             print('BasicApiService: ENV is not JsObject, trying dynamic read...');
             try {
                final val = (env as dynamic)['API_BASE_URL'];
                print('BasicApiService: dynamic read result: $val');
                if (val != null && val.toString().toLowerCase() != 'null' && val.toString().trim().isNotEmpty) {
                   return val.toString();
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
    return dotenv.env['API_BASE_URL'] ?? '/api/v1';
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
      ApiExceptionCode.savingObjectError.name,
      'Error in the request: ${response.statusCode} ${response.body}',
    );
  }
}

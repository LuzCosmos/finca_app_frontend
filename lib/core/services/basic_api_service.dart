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
      // En Web, usamos universal_html/js.dart para acceder al contexto global (window)
      // de forma segura y compatible con el compilador.
      if (js.context.hasProperty('ENV')) {
         print('BasicApiService: Found ENV in window');
         final env = js.context['ENV'];
         
         // 1. Try as simple dynamic map access (most common in universal_html)
         try {
            final val = (env as dynamic)['API_BASE_URL'];
            if (val != null) {
               print('BasicApiService: Found API_BASE_URL via dynamic access: $val');
               return val.toString();
            }
         } catch (e) {
            print('BasicApiService: Dynamic access failed: $e');
         }

         // 2. Try as JsObject
         if (env is js.JsObject && env.hasProperty('API_BASE_URL')) {
           print('BasicApiService: Found API_BASE_URL via JsObject');
           return env['API_BASE_URL']; 
         } 
      } else {
         print('BasicApiService: ENV not found in window');
      }
    }
    // Fallback a dotenv (Development local o Mobile)
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';
  }


  static Future<String> getToken() async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw ApiException(ApiExceptionCode.unauthorized.name, 'Unauthorized');
      //throw Exception('⚠️ No se encontró token de sesión');
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
      throw ApiException(ApiExceptionCode.conflictError.name, 'Conflict');
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

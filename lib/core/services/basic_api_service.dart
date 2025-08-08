import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:http/http.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

class BasicApiService {
  static Future<String> getToken() async {
    final token = await SessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('⚠️ No se encontró token de sesión');
    }
    return token;
  }

  static Never manageNotSuccessResponseCode(Response response) {
    if (response.statusCode == 400) {
      throw ApiException(ApiExceptionCode.invalidData.name, 'Invalid data');
    } else if (response.statusCode == 401) {
      throw ApiException(ApiExceptionCode.unauthorized.name, 'Unauthorized');
    } else if (response.statusCode == 403) {
      throw ApiException(ApiExceptionCode.forbidden.name, 'Forbidden');
    } else if (response.statusCode == 404) {
      throw ApiException(ApiExceptionCode.notFound.name, 'Not found');
    } else if (response.statusCode == 409) {
      throw ApiException(ApiExceptionCode.conflictError.name, 'Conflict');
    } else if (response.statusCode == 500) {
      throw ApiException(
        ApiExceptionCode.serverError.name,
        'Internal server error',
      );
    }
    throw ApiException(
      ApiExceptionCode.savingObjectError.name,
      'Error al realizar la petición: ${response.statusCode} ${response.body}',
    );
  }
}

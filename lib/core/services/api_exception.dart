import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum ApiExceptionCode {
  invalidData,
  unauthorized,
  forbidden,
  serverError,
  unknownError,
}

extension ApiExceptionCodeL10n on ApiExceptionCode {
  String asText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ApiExceptionCode.invalidData:
        return l10n.error_invalidData;
      case ApiExceptionCode.unauthorized:
        return l10n.error_unauthorized;
      case ApiExceptionCode.forbidden:
        return l10n.error_forbidden;
      case ApiExceptionCode.serverError:
        return l10n.error_server;
      case ApiExceptionCode.unknownError:
        return l10n.login_unexpectedError;
    }
  }
}

class ApiException implements Exception {
  final String code; // ejemplo: 'forbidden', 'invalidData'
  final String message; // mensaje opcional, puede venir del backend

  ApiException(this.code, [this.message = '']);

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

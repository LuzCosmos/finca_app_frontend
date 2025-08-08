import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum ApiExceptionCode {
  invalidData,
  unauthorized,
  forbidden,
  conflictError,
  serverError,
  savingObjectError,
  unknownError,
  serverConnectionError,
  notFound,
}

extension ApiExceptionCodeL10n on ApiExceptionCode {
  String asText(BuildContext context, {String? objectName}) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ApiExceptionCode.invalidData:
        return l10n.error_invalidData;
      case ApiExceptionCode.unauthorized:
        return l10n.error_unauthorized;
      case ApiExceptionCode.forbidden:
        return l10n.error_forbidden;
      case ApiExceptionCode.conflictError:
        return l10n.error_conflict;
      case ApiExceptionCode.serverError:
        return l10n.error_server;
      case ApiExceptionCode.unknownError:
        return l10n.error_generic;
      case ApiExceptionCode.serverConnectionError:
        return l10n.error_serverConnection;
      case ApiExceptionCode.savingObjectError:
        return l10n.error_savingObject +
            (objectName != null ? " $objectName" : "");
      case ApiExceptionCode.notFound:
        return l10n.error_notFound(objectName ?? "");
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

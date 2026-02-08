import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum ApiExceptionCode {
  badRequest,
  unauthorized,
  forbidden,
  conflictError,
  serverError,
  savingObjectError,
  readingObjectError,
  unknownError,
  serverConnectionError,
  notFound,
  unprocessableEntity,
  locked;

  String asText(BuildContext context, {String? objectName}) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ApiExceptionCode.badRequest:
        return l10n.error_badRequest;
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
      case ApiExceptionCode.readingObjectError:
        return l10n.error_readingObject +
            (objectName != null ? " $objectName" : "");
      case ApiExceptionCode.notFound:
        return l10n.error_notFound(objectName ?? "");
      case ApiExceptionCode.unprocessableEntity:
        return l10n.error_unprocessableEntity;
      case ApiExceptionCode.locked:
        return l10n.error_locked;
    }
  }

  static ApiExceptionCode fromString(String value) {
    return ApiExceptionCode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApiExceptionCode.unknownError,
    );
  }
}

class ApiException implements Exception {
  final String code; // ejemplo: 'forbidden', 'badRequest'
  final String message; // mensaje opcional, puede venir del backend

  ApiException(this.code, [this.message = '']);

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

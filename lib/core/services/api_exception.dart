import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum ApiExceptionCode {
  badRequest,
  cattleIsNotActive,
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
  locked,
  // Sale sync when editing sold cattle
  soldCattleMissingSaleDetail,
  saleFieldsOnlyForSoldCattle,
  invalidSalePrice,
  invalidSaleWeight;

  String asText(BuildContext context, {String? objectName}) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ApiExceptionCode.badRequest:
        return l10n.error_badRequest;
      case ApiExceptionCode.cattleIsNotActive:
        return l10n.error_cattleIsNotActive;
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
      case ApiExceptionCode.soldCattleMissingSaleDetail:
        return l10n.error_soldCattleMissingSaleDetail;
      case ApiExceptionCode.saleFieldsOnlyForSoldCattle:
        return l10n.error_saleFieldsOnlyForSoldCattle;
      case ApiExceptionCode.invalidSalePrice:
        return l10n.error_invalidSalePrice;
      case ApiExceptionCode.invalidSaleWeight:
        return l10n.error_invalidSaleWeight;
    }
  }

  static ApiExceptionCode fromString(String value) {
    // Map backend error codes (SCREAMING_SNAKE_CASE) to enum
    final backendCodeMap = <String, ApiExceptionCode>{
      'SOLD_CATTLE_MISSING_SALE_DETAIL': ApiExceptionCode.soldCattleMissingSaleDetail,
      'SALE_FIELDS_ONLY_FOR_SOLD_CATTLE': ApiExceptionCode.saleFieldsOnlyForSoldCattle,
      'INVALID_SALE_PRICE': ApiExceptionCode.invalidSalePrice,
      'INVALID_SALE_WEIGHT': ApiExceptionCode.invalidSaleWeight,
    };
    final mapped = backendCodeMap[value];
    if (mapped != null) return mapped;
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

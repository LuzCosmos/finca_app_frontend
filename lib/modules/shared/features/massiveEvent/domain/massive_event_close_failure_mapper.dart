import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:http/http.dart' as http;

/// Resultado de clasificar un fallo al cerrar el masivo (solo dominio; la UI traduce a L10n).
enum MassiveEventCloseFailureKind {
  /// Sin conexión, timeout o transporte.
  network,

  /// Backend indica masivo ya cerrado.
  alreadyClosed,

  /// Backend: no quedan simple events aplicados tras limpieza.
  noSimpleEventsApplied,

  /// Masivo ligado a recepción de compra (`MASSIVE_EVENT_FROM_PURCHASE_RECEPTION`).
  purchaseReceptionBlocked,

  forbidden,
  notFound,

  /// 422 con mensaje no mapeado a un caso de negocio conocido.
  unprocessableEntityGeneric,

  serverError,

  /// Incluye códigos de [ApiException] ya alineados con [ApiExceptionCode] (p. ej. `badRequest`).
  apiExceptionCode,

  /// Cualquier otro error no clasificado.
  unknown,
}

/// Resultado de [mapMassiveEventCloseFailure]: tipo + excepción opcional para `apiExceptionCode`.
class MassiveEventCloseFailureResult {
  final MassiveEventCloseFailureKind kind;
  final ApiException? apiException;

  const MassiveEventCloseFailureResult(this.kind, [this.apiException]);
}

/// Normaliza el campo `message` de respuestas JSON (string u objeto Nest).
String normalizeBackendMessageField(Object? raw) {
  if (raw == null) return '';
  if (raw is String) return raw;
  if (raw is Map) {
    final code = raw['code']?.toString() ?? '';
    final msg = raw['message']?.toString() ?? '';
    if (code.isNotEmpty && msg.isNotEmpty) {
      return '$code: $msg';
    }
    if (msg.isNotEmpty) return msg;
    if (code.isNotEmpty) return code;
    try {
      return jsonEncode(raw);
    } catch (_) {
      return raw.toString();
    }
  }
  return raw.toString();
}

/// Clasifica errores de `closeMassiveEvent` para mensajes de usuario coherentes (Fase A UH).
MassiveEventCloseFailureResult mapMassiveEventCloseFailure(Object error) {
  if (error is SocketException) {
    return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.network);
  }
  if (error is TimeoutException) {
    return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.network);
  }
  if (error is http.ClientException) {
    return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.network);
  }
  if (error is ApiException) {
    return _mapApiException(error);
  }
  return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.unknown);
}

MassiveEventCloseFailureResult _mapApiException(ApiException e) {
  if (e.code == ApiExceptionCode.serverConnectionError.name) {
    return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.network);
  }
  if (e.code == ApiExceptionCode.forbidden.name) {
    return MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.forbidden, e);
  }
  if (e.code == ApiExceptionCode.notFound.name) {
    return MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.notFound, e);
  }
  if (e.code == ApiExceptionCode.serverError.name) {
    return MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.serverError, e);
  }

  if (e.code == ApiExceptionCode.unprocessableEntity.name) {
    final m = normalizeBackendMessageField(e.message).toLowerCase();
    if (m.contains('closed')) {
      return const MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.alreadyClosed);
    }
    if (m.contains('no simple events') || m.contains('no simple event')) {
      return const MassiveEventCloseFailureResult(
        MassiveEventCloseFailureKind.noSimpleEventsApplied,
      );
    }
    if (m.contains('massive_event_from_purchase_reception') ||
        m.contains('purchase reception')) {
      return const MassiveEventCloseFailureResult(
        MassiveEventCloseFailureKind.purchaseReceptionBlocked,
      );
    }
    return MassiveEventCloseFailureResult(
      MassiveEventCloseFailureKind.unprocessableEntityGeneric,
      e,
    );
  }

  final codeEnum = ApiExceptionCode.fromString(e.code);
  if (codeEnum != ApiExceptionCode.unknownError) {
    return MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.apiExceptionCode, e);
  }

  return MassiveEventCloseFailureResult(MassiveEventCloseFailureKind.unknown, e);
}

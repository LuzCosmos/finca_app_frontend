import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_close_failure_mapper.dart';
import 'package:http/http.dart' as http;

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/domain/massive_event_close_failure_mapper.dart

void main() {
  group('normalizeBackendMessageField', () {
    test('null → cadena vacía', () {
      expect(normalizeBackendMessageField(null), '');
    });

    test('string → se conserva', () {
      expect(normalizeBackendMessageField('No simple events applied'), 'No simple events applied');
    });

    test('map con code y message → compuesto legible', () {
      expect(
        normalizeBackendMessageField(<String, dynamic>{
          'code': 'MASSIVE_EVENT_FROM_PURCHASE_RECEPTION',
          'message': 'Cannot close',
        }),
        'MASSIVE_EVENT_FROM_PURCHASE_RECEPTION: Cannot close',
      );
    });
  });

  group('mapMassiveEventCloseFailure', () {
    test('SocketException → network', () {
      final r = mapMassiveEventCloseFailure(const SocketException('failed'));
      expect(r.kind, MassiveEventCloseFailureKind.network);
    });

    test('TimeoutException → network', () {
      final r = mapMassiveEventCloseFailure(TimeoutException('t'));
      expect(r.kind, MassiveEventCloseFailureKind.network);
    });

    test('ClientException → network', () {
      final r = mapMassiveEventCloseFailure(http.ClientException('x'));
      expect(r.kind, MassiveEventCloseFailureKind.network);
    });

    test('ApiException serverConnectionError → network', () {
      final r = mapMassiveEventCloseFailure(
        ApiException(ApiExceptionCode.serverConnectionError.name, ''),
      );
      expect(r.kind, MassiveEventCloseFailureKind.network);
    });

    test('422 mensaje closed → alreadyClosed', () {
      final r = mapMassiveEventCloseFailure(
        ApiException(ApiExceptionCode.unprocessableEntity.name, 'Massive event already closed'),
      );
      expect(r.kind, MassiveEventCloseFailureKind.alreadyClosed);
    });

    test('422 sin simple events → noSimpleEventsApplied', () {
      final r = mapMassiveEventCloseFailure(
        ApiException(ApiExceptionCode.unprocessableEntity.name, 'No simple events applied'),
      );
      expect(r.kind, MassiveEventCloseFailureKind.noSimpleEventsApplied);
    });

    test('422 recepción compra → purchaseReceptionBlocked', () {
      final r = mapMassiveEventCloseFailure(
        ApiException(
          ApiExceptionCode.unprocessableEntity.name,
          'MASSIVE_EVENT_FROM_PURCHASE_RECEPTION: blocked',
        ),
      );
      expect(r.kind, MassiveEventCloseFailureKind.purchaseReceptionBlocked);
    });

    test('422 genérico → unprocessableEntityGeneric + api', () {
      final ex = ApiException(ApiExceptionCode.unprocessableEntity.name, 'Other business rule');
      final r = mapMassiveEventCloseFailure(ex);
      expect(r.kind, MassiveEventCloseFailureKind.unprocessableEntityGeneric);
      expect(r.apiException, same(ex));
    });

    test('forbidden → forbidden', () {
      final ex = ApiException(ApiExceptionCode.forbidden.name, '');
      final r = mapMassiveEventCloseFailure(ex);
      expect(r.kind, MassiveEventCloseFailureKind.forbidden);
      expect(r.apiException, same(ex));
    });

    test('desconocido → unknown', () {
      final r = mapMassiveEventCloseFailure(Exception('x'));
      expect(r.kind, MassiveEventCloseFailureKind.unknown);
    });
  });
}

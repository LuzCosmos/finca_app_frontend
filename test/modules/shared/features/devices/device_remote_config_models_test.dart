import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

// Bajo prueba: lib/modules/shared/features/devices/models/device_remote_config_models.dart

void main() {
  group('ConfigurationProfileModel', () {
    test('parsea perfil global del sistema', () {
      final m = ConfigurationProfileModel.fromJson({
        'id': 'p-1',
        'idTenant': null,
        'code': 'NORMAL_1H',
        'name': 'Normal 1h',
        'description': 'Reporte horario',
        'parameters': {
          'workingMode': 'periodic',
          'heartbeatInterval': 720,
        },
        'isSystem': true,
        'isActive': true,
      });

      expect(m.id, 'p-1');
      expect(m.idTenant, isNull);
      expect(m.code, 'NORMAL_1H');
      expect(m.isSystem, isTrue);
      expect(m.parameters['workingMode'], 'periodic');
      expect(m.parameters['heartbeatInterval'], 720);
    });

    test('aplica defaults cuando faltan campos', () {
      final m = ConfigurationProfileModel.fromJson({
        'id': 'p-2',
        'code': 'X',
        'name': 'X',
      });
      expect(m.idTenant, isNull);
      expect(m.description, isNull);
      expect(m.parameters, isEmpty);
      expect(m.isSystem, isFalse);
      expect(m.isActive, isTrue);
    });
  });

  group('RemoteConfigStatusModel.isInSync', () {
    RemoteConfigStatusModel build({
      List<String> divergent = const [],
      int desiredVersion = 1,
      int confirmedVersion = 1,
    }) {
      return RemoteConfigStatusModel.fromJson({
        'idDevice': 'd1',
        'idProfile': null,
        'profileSnapshot': {},
        'desired': {},
        'confirmed': {},
        'divergent': divergent,
        'desiredVersion': desiredVersion,
        'confirmedVersion': confirmedVersion,
        'lastPushedAt': null,
        'lastConfirmedAt': null,
      });
    }

    test('true cuando no hay divergent y versiones empatan', () {
      expect(build().isInSync, isTrue);
    });

    test('false cuando hay parámetros divergentes', () {
      expect(build(divergent: ['workingMode']).isInSync, isFalse);
    });

    test('false cuando desiredVersion > confirmedVersion', () {
      expect(build(desiredVersion: 5, confirmedVersion: 3).isInSync, isFalse);
    });
  });

  group('DiagnosticStateModel & RemoteConfigStatusModel.isDiagnosticActive', () {
    test('parsea diagnostic_state cuando viene en el JSON', () {
      final future = DateTime.now().toUtc().add(const Duration(minutes: 10));
      final model = RemoteConfigStatusModel.fromJson({
        'idDevice': 'd1',
        'idProfile': null,
        'profileSnapshot': {},
        'desired': {},
        'confirmed': {},
        'divergent': [],
        'desiredVersion': 1,
        'confirmedVersion': 1,
        'lastPushedAt': null,
        'lastConfirmedAt': null,
        'diagnosticState': {
          'active': true,
          'enabledAt': DateTime.now().toUtc().toIso8601String(),
          'expiresAt': future.toIso8601String(),
          'ttlMinutes': 30,
          'enabledByUserId': 'u-1',
          'previous': {
            'shockDetectionSwitch': true,
            'manDownDetectionSwitch': true,
            'tamperAlarmSwitch': true,
            'heartbeatInterval': 720,
          },
        },
      });
      expect(model.diagnosticState, isNotNull);
      expect(model.isDiagnosticActive, isTrue);
      expect(model.diagnosticState!.ttlMinutes, 30);
      expect(model.diagnosticState!.previous['heartbeatInterval'], 720);
      // Restante > 0 porque expiresAt está en el futuro.
      expect(model.diagnosticState!.remaining.inSeconds, greaterThan(0));
    });

    test('isDiagnosticActive es false cuando expiresAt ya pasó', () {
      final past = DateTime.now().toUtc().subtract(const Duration(minutes: 1));
      final model = RemoteConfigStatusModel.fromJson({
        'idDevice': 'd1',
        'idProfile': null,
        'profileSnapshot': {},
        'desired': {},
        'confirmed': {},
        'divergent': [],
        'desiredVersion': 1,
        'confirmedVersion': 1,
        'lastPushedAt': null,
        'lastConfirmedAt': null,
        'diagnosticState': {
          'active': true,
          'enabledAt': past.subtract(const Duration(minutes: 30)).toIso8601String(),
          'expiresAt': past.toIso8601String(),
          'ttlMinutes': 30,
          'enabledByUserId': null,
          'previous': {
            'shockDetectionSwitch': true,
            'manDownDetectionSwitch': true,
            'tamperAlarmSwitch': true,
            'heartbeatInterval': 720,
          },
        },
      });
      expect(model.diagnosticState, isNotNull);
      expect(model.isDiagnosticActive, isFalse);
      expect(model.diagnosticState!.isExpired, isTrue);
    });

    test('diagnosticState es null cuando no viene en el JSON', () {
      final model = RemoteConfigStatusModel.fromJson({
        'idDevice': 'd1',
        'idProfile': null,
        'profileSnapshot': {},
        'desired': {},
        'confirmed': {},
        'divergent': [],
        'desiredVersion': 0,
        'confirmedVersion': 0,
        'lastPushedAt': null,
        'lastConfirmedAt': null,
      });
      expect(model.diagnosticState, isNull);
      expect(model.isDiagnosticActive, isFalse);
    });
  });

  group('DeviceCommandModel & DeviceCommandPage', () {
    test('parsea fechas ISO y enums correctamente', () {
      final cmd = DeviceCommandModel.fromJson({
        'id': 'c1',
        'idDevice': 'd1',
        'type': 'CONFIGURE',
        'action': 'applyProfile:NORMAL_1H',
        'fPort': 10,
        'payloadHex': '02 02 06 02',
        'status': 'PENDING_VERIFICATION',
        'parameters': {'workingMode': 'periodic'},
        'createdAt': '2024-08-16T14:30:00Z',
        'queuedAt': '2024-08-16T14:30:01Z',
        'errorMessage': null,
      });
      expect(cmd.id, 'c1');
      expect(cmd.type, 'CONFIGURE');
      expect(cmd.fPort, 10);
      expect(cmd.status, 'PENDING_VERIFICATION');
      expect(cmd.createdAt.year, 2024);
      expect(cmd.queuedAt, isNotNull);
      expect(cmd.verifiedAt, isNull);
    });

    test('DeviceCommandPage parsea lista vacía correctamente', () {
      final page = DeviceCommandPage.fromJson({'items': [], 'total': 0});
      expect(page.items, isEmpty);
      expect(page.total, 0);
    });

    test('DeviceCommandPage parsea total y mantiene orden', () {
      final page = DeviceCommandPage.fromJson({
        'items': [
          {
            'id': 'c1',
            'idDevice': 'd',
            'type': 'CONTROL',
            'action': 'reboot',
            'fPort': 10,
            'status': 'QUEUED_IN_CHIRPSTACK',
            'createdAt': '2024-08-16T14:30:00Z',
          },
          {
            'id': 'c2',
            'idDevice': 'd',
            'type': 'CONFIGURE',
            'action': 'configure:heartbeatInterval',
            'fPort': 10,
            'status': 'APPLIED',
            'createdAt': '2024-08-16T15:00:00Z',
          },
        ],
        'total': 2,
      });
      expect(page.total, 2);
      expect(page.items.first.id, 'c1');
      expect(page.items.last.status, 'APPLIED');
    });
  });
}

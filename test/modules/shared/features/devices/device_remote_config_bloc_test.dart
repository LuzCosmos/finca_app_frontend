import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_event.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_state.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

class MockDataSource extends Mock implements DeviceRemoteConfigDataSource {}

DeviceCommandModel _fakeCmd(String id) => DeviceCommandModel(
      id: id,
      idDevice: 'd1',
      type: 'CONTROL',
      action: 'control:reboot',
      fPort: 10,
      payloadHex: '0000',
      status: 'QUEUED_IN_CHIRPSTACK',
      errorMessage: null,
      parameters: const {},
      chirpstackQueueItemId: 'q1',
      createdAt: DateTime.utc(2024, 8, 16),
      queuedAt: DateTime.utc(2024, 8, 16),
      sentAt: null,
      verifiedAt: null,
    );

ConfigurationProfileModel _profile(String code) => ConfigurationProfileModel(
      id: 'p-$code',
      idTenant: null,
      code: code,
      name: code,
      description: null,
      parameters: const {'workingMode': 'periodic'},
      isSystem: true,
      isActive: true,
    );

RemoteConfigStatusModel _status({List<String> divergent = const []}) {
  return RemoteConfigStatusModel(
    idDevice: 'd1',
    idProfile: null,
    profileSnapshot: const {},
    desired: const {},
    confirmed: const {},
    divergent: divergent,
    desiredVersion: 0,
    confirmedVersion: 0,
    lastPushedAt: null,
    lastConfirmedAt: null,
    diagnosticState: null,
  );
}

void main() {
  late MockDataSource dataSource;
  const deveui = '0102030405060708';

  setUp(() {
    dataSource = MockDataSource();

    when(() => dataSource.getStatus(any())).thenAnswer((_) async => _status());
    when(() => dataSource.listProfiles()).thenAnswer(
      (_) async => [_profile('NORMAL_1H')],
    );
    when(
      () => dataSource.listCommands(any(), limit: any(named: 'limit'), offset: any(named: 'offset')),
    ).thenAnswer((_) async => DeviceCommandPage(items: [_fakeCmd('c1')], total: 1));
    when(() => dataSource.applyProfile(any(), any()))
        .thenAnswer((_) async => _fakeCmd('c-apply'));
    when(() => dataSource.requestPosition(any()))
        .thenAnswer((_) async => _fakeCmd('c-pos'));
    when(() => dataSource.requestBattery(any()))
        .thenAnswer((_) async => _fakeCmd('c-bat'));
    when(() => dataSource.clearManDown(any()))
        .thenAnswer((_) async => _fakeCmd('c-md'));
    when(() => dataSource.readParameters(any(), any()))
        .thenAnswer((_) async => _fakeCmd('c-read'));
    when(() => dataSource.readAllSafeParameters(any())).thenAnswer(
      (_) async => <String, dynamic>{
        'chunksEnqueued': 3,
        'totalParameterIds': 75,
      },
    );
    when(() => dataSource.getReadSafeParametersChunkPlan(any())).thenAnswer(
      (_) async => ReadSafeParametersChunkPlanModel(
        totalParameterIds: 75,
        maxPerFrame: 32,
        totalChunks: 3,
        chunks: [
          ReadSafeParametersChunkItemModel(
            chunkIndex: 0,
            count: 32,
            parameterNames: const ['workingMode'],
          ),
          ReadSafeParametersChunkItemModel(
            chunkIndex: 1,
            count: 32,
            parameterNames: const ['heartbeatInterval'],
          ),
          ReadSafeParametersChunkItemModel(
            chunkIndex: 2,
            count: 11,
            parameterNames: const ['tamperAlarmSwitch'],
          ),
        ],
      ),
    );
    when(() => dataSource.readSafeParametersChunk(any(), any()))
        .thenAnswer((_) async => _fakeCmd('c-chunk'));
    when(() => dataSource.configureParameters(any(), any()))
        .thenAnswer((_) async => _fakeCmd('c-cfg'));
    when(
      () => dataSource.enableDiagnosticMode(any(), ttlMinutes: any(named: 'ttlMinutes')),
    ).thenAnswer((_) async => <String, dynamic>{
          'diagnosticState': {
            'enabledAt': DateTime.utc(2026, 5, 7, 22).toIso8601String(),
            'expiresAt': DateTime.utc(2026, 5, 7, 22, 30).toIso8601String(),
            'ttlMinutes': 30,
            'previous': {
              'shockDetectionSwitch': true,
              'manDownDetectionSwitch': true,
              'tamperAlarmSwitch': true,
              'heartbeatInterval': 720,
            },
          },
        });
    when(() => dataSource.disableDiagnosticMode(any()))
        .thenAnswer((_) async => <String, dynamic>{'restoredFrom': null});
  });

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'LoadDeviceRemoteConfig: pasa de loading a listo con status, profiles y commandPage',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const LoadDeviceRemoteConfig(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isLoading, 'isLoading', isTrue)
          .having((s) => s.deveui, 'deveui', deveui),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.profiles.length, 'profiles.length', 1)
          .having((s) => s.status, 'status', isNotNull)
          .having((s) => s.commandPage?.items.length, 'commands.length', 1)
          .having((s) => s.readSafeChunkPlan?.totalChunks, 'chunkPlan', 3),
    ],
    verify: (_) {
      verify(() => dataSource.getStatus(deveui)).called(1);
      verify(() => dataSource.listProfiles()).called(1);
      verify(() => dataSource.listCommands(deveui,
          limit: any(named: 'limit'), offset: any(named: 'offset'))).called(1);
      verify(() => dataSource.getReadSafeParametersChunkPlan(deveui)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'LoadDeviceRemoteConfig: si data source falla, emite error y desactiva loading',
    build: () {
      when(() => dataSource.getStatus(any())).thenThrow(Exception('boom'));
      return DeviceRemoteConfigBloc(dataSource: dataSource);
    },
    act: (b) => b.add(const LoadDeviceRemoteConfig(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.errorMessage, 'errorMessage', contains('boom')),
    ],
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ApplyConfigurationProfileRequested: success emite isApplyingProfile true y luego success message',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(
      const ApplyConfigurationProfileRequested(deveui: deveui, idProfile: 'p1'),
    ),
    expect: () => [
      isA<DeviceRemoteConfigState>().having(
        (s) => s.isApplyingProfile,
        'isApplyingProfile',
        isTrue,
      ),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isApplyingProfile, 'isApplyingProfile', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('aplicado')),
      // El bloc dispara LoadDeviceRemoteConfig automáticamente; aceptamos cualquier loading
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'isLoading', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.applyProfile(deveui, 'p1')).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ApplyConfigurationProfileRequested: si falla mantiene isApplyingProfile=false y reporta error',
    build: () {
      when(() => dataSource.applyProfile(any(), any())).thenThrow(Exception('forbidden'));
      return DeviceRemoteConfigBloc(dataSource: dataSource);
    },
    act: (b) => b.add(
      const ApplyConfigurationProfileRequested(deveui: deveui, idProfile: 'p1'),
    ),
    expect: () => [
      isA<DeviceRemoteConfigState>().having(
        (s) => s.isApplyingProfile,
        'isApplyingProfile',
        isTrue,
      ),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isApplyingProfile, 'isApplyingProfile', isFalse)
          .having((s) => s.errorMessage, 'errorMessage', contains('forbidden')),
    ],
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'RequestDevicePositionEvent: dispara success y refresca status',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const RequestDevicePositionEvent(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>().having((s) => s.isRequestingPosition, 'pos', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isRequestingPosition, 'pos', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('Posición')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.requestPosition(deveui)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ClearManDownRequested: encadena clear + refresh',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const ClearManDownRequested(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>().having((s) => s.isClearingManDown, 'isClearing', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isClearingManDown, 'isClearing', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('man-down')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ConfigureDeviceParametersRequested: pasa parámetros al data source y reporta éxito',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(
      const ConfigureDeviceParametersRequested(
        deveui: deveui,
        parameters: {'heartbeatInterval': 3600},
      ),
    ),
    expect: () => [
      isA<DeviceRemoteConfigState>().having((s) => s.isConfiguring, 'cfg', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isConfiguring, 'cfg', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('Parámetros')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.configureParameters(
            deveui,
            {'heartbeatInterval': 3600},
          )).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ReadDeviceParametersRequested: pasa nombres y dispara reload',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(
      const ReadDeviceParametersRequested(
        deveui: deveui,
        parameterNames: ['workingMode', 'heartbeatInterval'],
      ),
    ),
    expect: () => [
      isA<DeviceRemoteConfigState>().having((s) => s.isReading, 'reading', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isReading, 'reading', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('lectura')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.readParameters(
            deveui,
            ['workingMode', 'heartbeatInterval'],
          )).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ReadAllSafeParametersRequested: llama readAll y muestra resumen con chunks/total',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const ReadAllSafeParametersRequested(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isReadingAllSafeParameters, 'readingAll', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isReadingAllSafeParameters, 'readingAll', isFalse)
          .having((s) => s.lastSuccessMessage, 'success', contains('3'))
          .having((s) => s.lastSuccessMessage, 'success', contains('75')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.readAllSafeParameters(deveui)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'ReadSafeParametersChunkRequested: encola un bloque y dispara reload',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(
          const ReadSafeParametersChunkRequested(deveui: deveui, chunkIndex: 0),
        ),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.readingSafeChunkIndex, 'readingChunk', 0),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.readingSafeChunkIndex, 'readingChunk', isNull)
          .having((s) => s.lastSuccessMessage, 'success', contains('Bloque')),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.readSafeParametersChunk(deveui, 0)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'EnableDiagnosticModeRequested: pasa a busy, llama API y refresca status',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const EnableDiagnosticModeRequested(deveui: deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isFalse)
          .having(
            (s) => s.lastSuccessMessage,
            'success',
            contains('diagnóstico'),
          ),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.enableDiagnosticMode(deveui)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'EnableDiagnosticModeRequested: si la API falla mantiene busy=false y emite error',
    build: () {
      when(() => dataSource.enableDiagnosticMode(any(),
              ttlMinutes: any(named: 'ttlMinutes')))
          .thenThrow(Exception('forbidden'));
      return DeviceRemoteConfigBloc(dataSource: dataSource);
    },
    act: (b) => b.add(const EnableDiagnosticModeRequested(deveui: deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isFalse)
          .having((s) => s.errorMessage, 'error', contains('forbidden')),
    ],
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'DisableDiagnosticModeRequested: llama API y dispara reload',
    build: () => DeviceRemoteConfigBloc(dataSource: dataSource),
    act: (b) => b.add(const DisableDiagnosticModeRequested(deveui)),
    expect: () => [
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isTrue),
      isA<DeviceRemoteConfigState>()
          .having((s) => s.isTogglingDiagnosticMode, 'busy', isFalse)
          .having(
            (s) => s.lastSuccessMessage,
            'success',
            contains('diagnóstico'),
          ),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isTrue),
      isA<DeviceRemoteConfigState>().having((s) => s.isLoading, 'reload', isFalse),
    ],
    verify: (_) {
      verify(() => dataSource.disableDiagnosticMode(deveui)).called(1);
    },
  );

  blocTest<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
    'LoadCommandHistoryEvent: actualiza solo commandPage sin tocar status/profiles',
    build: () {
      when(() => dataSource.listCommands(any(),
          limit: any(named: 'limit'), offset: any(named: 'offset'))).thenAnswer(
        (_) async => DeviceCommandPage(
          items: [_fakeCmd('cmd-x')],
          total: 99,
        ),
      );
      return DeviceRemoteConfigBloc(dataSource: dataSource);
    },
    act: (b) => b.add(const LoadCommandHistoryEvent(
      deveui: deveui,
      limit: 10,
      offset: 20,
    )),
    expect: () => [
      isA<DeviceRemoteConfigState>().having(
        (s) => s.commandPage?.total,
        'total',
        99,
      ),
    ],
    verify: (_) {
      verify(() => dataSource.listCommands(deveui, limit: 10, offset: 20))
          .called(1);
    },
  );
}

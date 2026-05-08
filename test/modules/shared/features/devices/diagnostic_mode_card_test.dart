import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_event.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_state.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/widgets/diagnostic_mode_card.dart';

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

DiagnosticStateModel _activeDiag({
  required DateTime expiresAt,
  DateTime? enabledAt,
}) {
  return DiagnosticStateModel(
    enabledAt: enabledAt ?? DateTime.utc(2026, 5, 7, 22, 0),
    expiresAt: expiresAt,
    ttlMinutes: 30,
    enabledByUserId: 'u-1',
    previous: const {
      'shockDetectionSwitch': true,
      'manDownDetectionSwitch': true,
      'tamperAlarmSwitch': true,
      'heartbeatInterval': 720,
    },
  );
}

RemoteConfigStatusModel _statusWithDiag(DiagnosticStateModel? diag) {
  return RemoteConfigStatusModel(
    idDevice: 'd1',
    idProfile: null,
    profileSnapshot: const {},
    desired: const {},
    confirmed: const {},
    divergent: const [],
    desiredVersion: 0,
    confirmedVersion: 0,
    lastPushedAt: null,
    lastConfirmedAt: null,
    diagnosticState: diag,
  );
}

/// Helper para envolver el card en `MaterialApp` con localizaciones y un bloc real
/// alimentado con un dataSource mockeado. Necesitamos un bloc real (no fake) porque
/// el widget hace `context.read<DeviceRemoteConfigBloc>()` sobre el provider.
Widget _hostWith(
  DeviceRemoteConfigState seedState,
  MockDataSource ds, {
  DateTime Function()? clock,
}) {
  final bloc = _SeededBloc(seedState, ds);
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: BlocProvider<DeviceRemoteConfigBloc>.value(
      value: bloc,
      child: Scaffold(
        body: DiagnosticModeCard(deveui: '0102030405060708', clock: clock),
      ),
    ),
  );
}

/// Bloc con un estado inicial inyectado para tests; usa un dataSource mockeado para
/// las llamadas que dispara el widget al pulsar los botones.
class _SeededBloc extends DeviceRemoteConfigBloc {
  _SeededBloc(DeviceRemoteConfigState initial, DeviceRemoteConfigDataSource ds)
      : super(dataSource: ds) {
    emit(initial);
  }
}

void main() {
  setUpAll(() {
    // mocktail necesita "fallback values" para `EnableDiagnosticModeRequested.ttlMinutes`
    // cuando el matcher es `any(named: 'ttlMinutes')`. Como aquí no usamos named matchers
    // sobre ttlMinutes (el widget llama sin argumento), no hace falta fallback.
  });

  group('DiagnosticModeCard · estado inactivo', () {
    testWidgets('muestra texto inactivo y botón "Activar"', (tester) async {
      final ds = MockDataSource();
      when(() => ds.enableDiagnosticMode(any(), ttlMinutes: any(named: 'ttlMinutes')))
          .thenAnswer((_) async => <String, dynamic>{});

      const initial = DeviceRemoteConfigState();

      await tester.pumpWidget(_hostWith(initial, ds));
      await tester.pump();

      expect(find.byKey(const Key('diagnosticModeCard.inactiveStatus')), findsOneWidget);
      expect(find.byKey(const Key('diagnosticModeCard.enableButton')), findsOneWidget);
      expect(find.byKey(const Key('diagnosticModeCard.disableButton')), findsNothing);
      expect(find.byKey(const Key('diagnosticModeCard.activeStatus')), findsNothing);
    });

    testWidgets('al pulsar "Activar" dispara EnableDiagnosticModeRequested', (tester) async {
      final ds = MockDataSource();
      when(() => ds.enableDiagnosticMode(any(), ttlMinutes: any(named: 'ttlMinutes')))
          .thenAnswer((_) async => <String, dynamic>{});
      when(() => ds.getStatus(any())).thenAnswer((_) async => _statusWithDiag(null));
      when(() => ds.listProfiles()).thenAnswer((_) async => const []);
      when(
        () => ds.listCommands(any(),
            limit: any(named: 'limit'), offset: any(named: 'offset')),
      ).thenAnswer(
        (_) async => DeviceCommandPage(items: [_fakeCmd('c-1')], total: 1),
      );
      when(() => ds.getReadSafeParametersChunkPlan(any())).thenAnswer(
        (_) async => ReadSafeParametersChunkPlanModel(
          totalParameterIds: 1,
          maxPerFrame: 32,
          totalChunks: 1,
          chunks: [
            ReadSafeParametersChunkItemModel(
              chunkIndex: 0,
              count: 1,
              parameterNames: const ['workingMode'],
            ),
          ],
        ),
      );

      await tester.pumpWidget(_hostWith(const DeviceRemoteConfigState(), ds));
      await tester.pump();

      await tester.tap(find.byKey(const Key('diagnosticModeCard.enableButton')));
      await tester.pump();

      verify(() => ds.enableDiagnosticMode('0102030405060708',
          ttlMinutes: null)).called(1);
    });
  });

  group('DiagnosticModeCard · estado activo', () {
    testWidgets(
      'muestra cuenta regresiva mm:ss y botón "Desactivar"',
      (tester) async {
        final ds = MockDataSource();

        // expiresAt = now + 7 min 23 s; con clock determinístico el contador debe
        // decirlo exactamente.
        final fakeNow = DateTime.utc(2026, 5, 7, 22, 0, 0);
        final expiresAt = fakeNow.add(const Duration(minutes: 7, seconds: 23));

        final initial = const DeviceRemoteConfigState().copyWith(
          status: _statusWithDiag(_activeDiag(expiresAt: expiresAt, enabledAt: fakeNow)),
        );

        await tester.pumpWidget(_hostWith(initial, ds, clock: () => fakeNow));
        await tester.pump();

        expect(find.byKey(const Key('diagnosticModeCard.activeStatus')), findsOneWidget);
        expect(find.byKey(const Key('diagnosticModeCard.disableButton')), findsOneWidget);
        expect(find.byKey(const Key('diagnosticModeCard.enableButton')), findsNothing);
        // El formato l10n `es` del template "{minutes} min {seconds} s" debe
        // contener el valor exacto restante.
        expect(find.textContaining('7 min 23 s'), findsOneWidget);
      },
    );

    testWidgets('si expiresAt ya pasó, vuelve al estado inactivo', (tester) async {
      final ds = MockDataSource();

      final fakeNow = DateTime.utc(2026, 5, 7, 22, 0, 0);
      // expiresAt en el pasado.
      final expiresAt = fakeNow.subtract(const Duration(seconds: 1));

      final initial = const DeviceRemoteConfigState().copyWith(
        status: _statusWithDiag(_activeDiag(expiresAt: expiresAt, enabledAt: fakeNow)),
      );

      await tester.pumpWidget(_hostWith(initial, ds, clock: () => fakeNow));
      await tester.pump();

      expect(find.byKey(const Key('diagnosticModeCard.inactiveStatus')), findsOneWidget);
      expect(find.byKey(const Key('diagnosticModeCard.enableButton')), findsOneWidget);
      expect(find.byKey(const Key('diagnosticModeCard.activeStatus')), findsNothing);
    });

    testWidgets(
      'al pulsar "Desactivar" dispara DisableDiagnosticModeRequested',
      (tester) async {
        final ds = MockDataSource();
        when(() => ds.disableDiagnosticMode(any()))
            .thenAnswer((_) async => <String, dynamic>{});
        when(() => ds.getStatus(any())).thenAnswer((_) async => _statusWithDiag(null));
        when(() => ds.listProfiles()).thenAnswer((_) async => const []);
        when(
          () => ds.listCommands(any(),
              limit: any(named: 'limit'), offset: any(named: 'offset')),
        ).thenAnswer(
          (_) async => DeviceCommandPage(items: const [], total: 0),
        );
        when(() => ds.getReadSafeParametersChunkPlan(any())).thenAnswer(
          (_) async => ReadSafeParametersChunkPlanModel(
            totalParameterIds: 1,
            maxPerFrame: 32,
            totalChunks: 1,
            chunks: [
              ReadSafeParametersChunkItemModel(
                chunkIndex: 0,
                count: 1,
                parameterNames: const ['workingMode'],
              ),
            ],
          ),
        );

        final fakeNow = DateTime.utc(2026, 5, 7, 22, 0, 0);
        final expiresAt = fakeNow.add(const Duration(minutes: 5));

        final initial = const DeviceRemoteConfigState().copyWith(
          status: _statusWithDiag(_activeDiag(expiresAt: expiresAt, enabledAt: fakeNow)),
        );

        await tester.pumpWidget(_hostWith(initial, ds, clock: () => fakeNow));
        await tester.pump();

        await tester.tap(find.byKey(const Key('diagnosticModeCard.disableButton')));
        await tester.pump();

        verify(() => ds.disableDiagnosticMode('0102030405060708')).called(1);
      },
    );
  });
}

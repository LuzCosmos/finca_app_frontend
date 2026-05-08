import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'device_remote_config_event.dart';
import 'device_remote_config_state.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Adapter sobre `DeviceRemoteConfigApiService` para que el BLoC sea testeable
/// sin tocar HTTP. Cada método encapsula una llamada del backend.
abstract class DeviceRemoteConfigDataSource {
  Future<RemoteConfigStatusModel?> getStatus(String deveui);
  Future<List<ConfigurationProfileModel>> listProfiles();
  Future<DeviceCommandPage> listCommands(
    String deveui, {
    int limit,
    int offset,
  });
  Future<DeviceCommandModel> applyProfile(String deveui, String idProfile);
  Future<DeviceCommandModel> requestPosition(String deveui);
  Future<DeviceCommandModel> requestBattery(String deveui);
  Future<DeviceCommandModel> clearManDown(String deveui);
  Future<DeviceCommandModel> readParameters(
    String deveui,
    List<String> parameterNames,
  );
  Future<Map<String, dynamic>> readAllSafeParameters(String deveui);
  Future<ReadSafeParametersChunkPlanModel> getReadSafeParametersChunkPlan(
    String deveui,
  );
  Future<DeviceCommandModel> readSafeParametersChunk(
    String deveui,
    int chunkIndex,
  );
  Future<DeviceCommandModel> configureParameters(
    String deveui,
    Map<String, dynamic> parameters,
  );
  Future<Map<String, dynamic>> enableDiagnosticMode(
    String deveui, {
    int? ttlMinutes,
  });
  Future<Map<String, dynamic>> disableDiagnosticMode(String deveui);

  /// Apaga GPS/WiFi/BT en el collar (6 position strategies = 0x00) para que la
  /// posición la determine el LNS LoRaWAN.
  Future<DeviceCommandModel> setLorawanOnlyPositioning(String deveui);
}

class DeviceRemoteConfigBloc
    extends Bloc<DeviceRemoteConfigEvent, DeviceRemoteConfigState> {
  final DeviceRemoteConfigDataSource dataSource;
  final AppLocalizations? l10n;

  DeviceRemoteConfigBloc({required this.dataSource, this.l10n})
      : super(const DeviceRemoteConfigState()) {
    on<LoadDeviceRemoteConfig>(_onLoad);
    on<ApplyConfigurationProfileRequested>(_onApplyProfile);
    on<RequestDevicePositionEvent>(_onRequestPosition);
    on<RequestBatteryConsumptionEvent>(_onRequestBattery);
    on<ClearManDownRequested>(_onClearManDown);
    on<ReadDeviceParametersRequested>(_onReadParameters);
    on<ReadAllSafeParametersRequested>(_onReadAllSafeParameters);
    on<LoadReadSafeChunkPlanRequested>(_onLoadReadSafeChunkPlan);
    on<ReadSafeParametersChunkRequested>(_onReadSafeParametersChunk);
    on<ConfigureDeviceParametersRequested>(_onConfigure);
    on<LoadCommandHistoryEvent>(_onLoadCommandHistory);
    on<EnableDiagnosticModeRequested>(_onEnableDiagnosticMode);
    on<DisableDiagnosticModeRequested>(_onDisableDiagnosticMode);
    on<SetLorawanOnlyPositioningRequested>(_onSetLorawanOnlyPositioning);
  }

  Future<void> _onLoad(
    LoadDeviceRemoteConfig event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      deveui: event.deveui,
      isLoading: true,
      clearError: true,
      clearSuccess: true,
      clearReadSafeChunkPlan: true,
      clearReadSafeChunkPlanError: true,
      isLoadingReadSafeChunkPlan: true,
      clearReadingChunk: true,
    ));
    try {
      final results = await Future.wait([
        dataSource.getStatus(event.deveui),
        dataSource.listProfiles(),
        dataSource.listCommands(event.deveui, limit: 50, offset: 0),
      ]);
      ReadSafeParametersChunkPlanModel? chunkPlan;
      String? planError;
      try {
        chunkPlan = await dataSource.getReadSafeParametersChunkPlan(event.deveui);
      } catch (e) {
        planError = e.toString();
      }
      emit(state.copyWith(
        isLoading: false,
        status: results[0] as RemoteConfigStatusModel?,
        profiles: results[1] as List<ConfigurationProfileModel>,
        commandPage: results[2] as DeviceCommandPage,
        readSafeChunkPlan: chunkPlan,
        readSafeChunkPlanError: planError,
        isLoadingReadSafeChunkPlan: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isLoadingReadSafeChunkPlan: false,
      ));
    }
  }

  Future<void> _onLoadReadSafeChunkPlan(
    LoadReadSafeChunkPlanRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingReadSafeChunkPlan: true,
      clearReadSafeChunkPlanError: true,
    ));
    try {
      final plan =
          await dataSource.getReadSafeParametersChunkPlan(event.deveui);
      emit(state.copyWith(
        isLoadingReadSafeChunkPlan: false,
        readSafeChunkPlan: plan,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingReadSafeChunkPlan: false,
        readSafeChunkPlanError: e.toString(),
      ));
    }
  }

  Future<void> _onApplyProfile(
    ApplyConfigurationProfileRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isApplyingProfile: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.applyProfile(event.deveui, event.idProfile);
      emit(state.copyWith(
        isApplyingProfile: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_profileApplied ??
            'Perfil aplicado. Esperando confirmación del collar.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(isApplyingProfile: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRequestPosition(
    RequestDevicePositionEvent event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isRequestingPosition: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.requestPosition(event.deveui);
      emit(state.copyWith(
        isRequestingPosition: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_positionRequested ??
            'Posición solicitada al collar.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isRequestingPosition: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRequestBattery(
    RequestBatteryConsumptionEvent event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isRequestingBattery: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.requestBattery(event.deveui);
      emit(state.copyWith(
        isRequestingBattery: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_batteryRequested ??
            'Reporte de batería solicitado.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isRequestingBattery: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onClearManDown(
    ClearManDownRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isClearingManDown: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.clearManDown(event.deveui);
      emit(state.copyWith(
        isClearingManDown: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_manDownCleared ??
            'Estado man-down limpiado.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isClearingManDown: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onReadParameters(
    ReadDeviceParametersRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(isReading: true, clearError: true, clearSuccess: true));
    try {
      await dataSource.readParameters(event.deveui, event.parameterNames);
      emit(state.copyWith(
        isReading: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_readRequested ??
            'Solicitud de lectura enviada. Aparecerá en el próximo uplink.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(isReading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onReadAllSafeParameters(
    ReadAllSafeParametersRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isReadingAllSafeParameters: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      final body = await dataSource.readAllSafeParameters(event.deveui);
      final chunks = (body['chunksEnqueued'] as num?)?.toInt() ?? 0;
      final total = (body['totalParameterIds'] as num?)?.toInt() ?? 0;
      emit(state.copyWith(
        isReadingAllSafeParameters: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_readAllSent(chunks, total) ??
            'Se enviaron $chunks tramas de lectura ($total parámetros).',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isReadingAllSafeParameters: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onReadSafeParametersChunk(
    ReadSafeParametersChunkRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      readingSafeChunkIndex: event.chunkIndex,
      clearError: true,
      clearSuccess: true,
    ));
    final planSnapshot = state.readSafeChunkPlan;
    try {
      await dataSource.readSafeParametersChunk(event.deveui, event.chunkIndex);
      var count = 0;
      if (planSnapshot != null) {
        for (final c in planSnapshot.chunks) {
          if (c.chunkIndex == event.chunkIndex) {
            count = c.count;
            break;
          }
        }
      }
      emit(state.copyWith(
        clearReadingChunk: true,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_readChunkSent(
              event.chunkIndex + 1,
              planSnapshot?.totalChunks ?? event.chunkIndex + 1,
              count,
            ) ??
            'Bloque ${event.chunkIndex + 1} encolado.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        clearReadingChunk: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onConfigure(
    ConfigureDeviceParametersRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isConfiguring: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.configureParameters(event.deveui, event.parameters);
      emit(state.copyWith(
        isConfiguring: false,
        lastSuccessMessage: l10n?.deviceRemoteConfig_snackbar_configureSent ??
            'Parámetros enviados. Esperando confirmación.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(isConfiguring: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadCommandHistory(
    LoadCommandHistoryEvent event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    try {
      final page = await dataSource.listCommands(
        event.deveui,
        limit: event.limit,
        offset: event.offset,
      );
      emit(state.copyWith(commandPage: page));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onEnableDiagnosticMode(
    EnableDiagnosticModeRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isTogglingDiagnosticMode: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.enableDiagnosticMode(
        event.deveui,
        ttlMinutes: event.ttlMinutes,
      );
      emit(state.copyWith(
        isTogglingDiagnosticMode: false,
        lastSuccessMessage:
            l10n?.deviceRemoteConfig_snackbar_diagnosticEnabled ??
                'Modo diagnóstico activado. Se restaurará automáticamente.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isTogglingDiagnosticMode: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDisableDiagnosticMode(
    DisableDiagnosticModeRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isTogglingDiagnosticMode: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.disableDiagnosticMode(event.deveui);
      emit(state.copyWith(
        isTogglingDiagnosticMode: false,
        lastSuccessMessage:
            l10n?.deviceRemoteConfig_snackbar_diagnosticDisabled ??
                'Modo diagnóstico desactivado. Restaurando parámetros previos.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isTogglingDiagnosticMode: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetLorawanOnlyPositioning(
    SetLorawanOnlyPositioningRequested event,
    Emitter<DeviceRemoteConfigState> emit,
  ) async {
    emit(state.copyWith(
      isConfiguring: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await dataSource.setLorawanOnlyPositioning(event.deveui);
      emit(state.copyWith(
        isConfiguring: false,
        lastSuccessMessage:
            l10n?.deviceRemoteConfig_snackbar_lorawanOnlySent ??
                'Configuración «Solo LoRaWAN» enviada. Esperando confirmación.',
      ));
      add(LoadDeviceRemoteConfig(event.deveui));
    } catch (e) {
      emit(state.copyWith(
        isConfiguring: false,
        errorMessage: e.toString(),
      ));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';

/// Estado del flujo de configuración remota.
///
/// Conserva los catálogos cargados (perfiles, status, historial) en una sola estructura
/// inmutable y muestra banderas para mostrar spinners locales (`isApplyingProfile`,
/// `isRequestingPosition`, etc.) sin perder los datos.
class DeviceRemoteConfigState extends Equatable {
  final String? deveui;
  final RemoteConfigStatusModel? status;
  final List<ConfigurationProfileModel> profiles;
  final DeviceCommandPage? commandPage;
  final bool isLoading;
  final bool isApplyingProfile;
  final bool isRequestingPosition;
  final bool isRequestingBattery;
  final bool isClearingManDown;
  final bool isReading;
  final bool isReadingAllSafeParameters;
  final ReadSafeParametersChunkPlanModel? readSafeChunkPlan;
  final String? readSafeChunkPlanError;
  final bool isLoadingReadSafeChunkPlan;
  final int? readingSafeChunkIndex;
  final bool isConfiguring;
  final bool isTogglingDiagnosticMode;
  final String? errorMessage;
  final String? lastSuccessMessage;

  const DeviceRemoteConfigState({
    this.deveui,
    this.status,
    this.profiles = const [],
    this.commandPage,
    this.isLoading = false,
    this.isApplyingProfile = false,
    this.isRequestingPosition = false,
    this.isRequestingBattery = false,
    this.isClearingManDown = false,
    this.isReading = false,
    this.isReadingAllSafeParameters = false,
    this.readSafeChunkPlan,
    this.readSafeChunkPlanError,
    this.isLoadingReadSafeChunkPlan = false,
    this.readingSafeChunkIndex,
    this.isConfiguring = false,
    this.isTogglingDiagnosticMode = false,
    this.errorMessage,
    this.lastSuccessMessage,
  });

  DeviceRemoteConfigState copyWith({
    String? deveui,
    RemoteConfigStatusModel? status,
    bool clearStatus = false,
    List<ConfigurationProfileModel>? profiles,
    DeviceCommandPage? commandPage,
    bool clearCommandPage = false,
    bool? isLoading,
    bool? isApplyingProfile,
    bool? isRequestingPosition,
    bool? isRequestingBattery,
    bool? isClearingManDown,
    bool? isReading,
    bool? isReadingAllSafeParameters,
    ReadSafeParametersChunkPlanModel? readSafeChunkPlan,
    bool clearReadSafeChunkPlan = false,
    String? readSafeChunkPlanError,
    bool clearReadSafeChunkPlanError = false,
    bool? isLoadingReadSafeChunkPlan,
    int? readingSafeChunkIndex,
    bool clearReadingChunk = false,
    bool? isConfiguring,
    bool? isTogglingDiagnosticMode,
    String? errorMessage,
    bool clearError = false,
    String? lastSuccessMessage,
    bool clearSuccess = false,
  }) {
    return DeviceRemoteConfigState(
      deveui: deveui ?? this.deveui,
      status: clearStatus ? null : (status ?? this.status),
      profiles: profiles ?? this.profiles,
      commandPage: clearCommandPage ? null : (commandPage ?? this.commandPage),
      isLoading: isLoading ?? this.isLoading,
      isApplyingProfile: isApplyingProfile ?? this.isApplyingProfile,
      isRequestingPosition: isRequestingPosition ?? this.isRequestingPosition,
      isRequestingBattery: isRequestingBattery ?? this.isRequestingBattery,
      isClearingManDown: isClearingManDown ?? this.isClearingManDown,
      isReading: isReading ?? this.isReading,
      isReadingAllSafeParameters:
          isReadingAllSafeParameters ?? this.isReadingAllSafeParameters,
      readSafeChunkPlan: clearReadSafeChunkPlan
          ? null
          : (readSafeChunkPlan ?? this.readSafeChunkPlan),
      readSafeChunkPlanError: clearReadSafeChunkPlanError
          ? null
          : (readSafeChunkPlanError ?? this.readSafeChunkPlanError),
      isLoadingReadSafeChunkPlan:
          isLoadingReadSafeChunkPlan ?? this.isLoadingReadSafeChunkPlan,
      readingSafeChunkIndex: clearReadingChunk
          ? null
          : (readingSafeChunkIndex ?? this.readingSafeChunkIndex),
      isConfiguring: isConfiguring ?? this.isConfiguring,
      isTogglingDiagnosticMode:
          isTogglingDiagnosticMode ?? this.isTogglingDiagnosticMode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSuccessMessage:
          clearSuccess ? null : (lastSuccessMessage ?? this.lastSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
        deveui,
        status,
        profiles,
        commandPage,
        isLoading,
        isApplyingProfile,
        isRequestingPosition,
        isRequestingBattery,
        isClearingManDown,
        isReading,
        isReadingAllSafeParameters,
        readSafeChunkPlan,
        readSafeChunkPlanError,
        isLoadingReadSafeChunkPlan,
        readingSafeChunkIndex,
        isConfiguring,
        isTogglingDiagnosticMode,
        errorMessage,
        lastSuccessMessage,
      ];
}

import 'package:equatable/equatable.dart';

abstract class DeviceRemoteConfigEvent extends Equatable {
  const DeviceRemoteConfigEvent();
  @override
  List<Object?> get props => const [];
}

class LoadDeviceRemoteConfig extends DeviceRemoteConfigEvent {
  final String deveui;
  const LoadDeviceRemoteConfig(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

class ApplyConfigurationProfileRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  final String idProfile;
  const ApplyConfigurationProfileRequested({
    required this.deveui,
    required this.idProfile,
  });
  @override
  List<Object?> get props => [deveui, idProfile];
}

class RequestDevicePositionEvent extends DeviceRemoteConfigEvent {
  final String deveui;
  const RequestDevicePositionEvent(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

class RequestBatteryConsumptionEvent extends DeviceRemoteConfigEvent {
  final String deveui;
  const RequestBatteryConsumptionEvent(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

class ClearManDownRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  const ClearManDownRequested(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

class ReadDeviceParametersRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  final List<String> parameterNames;
  const ReadDeviceParametersRequested({
    required this.deveui,
    required this.parameterNames,
  });
  @override
  List<Object?> get props => [deveui, parameterNames];
}

class ReadAllSafeParametersRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  const ReadAllSafeParametersRequested(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

/// Re-intenta cargar el plan de bloques de lectura segura.
class LoadReadSafeChunkPlanRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  const LoadReadSafeChunkPlanRequested(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

/// Encola un solo downlink Read con el bloque seguro `chunkIndex` (0-based).
class ReadSafeParametersChunkRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  final int chunkIndex;
  const ReadSafeParametersChunkRequested({
    required this.deveui,
    required this.chunkIndex,
  });
  @override
  List<Object?> get props => [deveui, chunkIndex];
}

class ConfigureDeviceParametersRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  final Map<String, dynamic> parameters;
  const ConfigureDeviceParametersRequested({
    required this.deveui,
    required this.parameters,
  });
  @override
  List<Object?> get props => [deveui, parameters];
}

class LoadCommandHistoryEvent extends DeviceRemoteConfigEvent {
  final String deveui;
  final int limit;
  final int offset;
  const LoadCommandHistoryEvent({
    required this.deveui,
    this.limit = 50,
    this.offset = 0,
  });
  @override
  List<Object?> get props => [deveui, limit, offset];
}

class EnableDiagnosticModeRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  final int? ttlMinutes;
  const EnableDiagnosticModeRequested({required this.deveui, this.ttlMinutes});
  @override
  List<Object?> get props => [deveui, ttlMinutes];
}

class DisableDiagnosticModeRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  const DisableDiagnosticModeRequested(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

/// Apaga GPS / WiFi / BT en el collar (las 6 position strategies a 0x00)
/// para que la posición se calcule solo por LoRaWAN (TDOA/RSSI desde gateways).
class SetLorawanOnlyPositioningRequested extends DeviceRemoteConfigEvent {
  final String deveui;
  const SetLorawanOnlyPositioningRequested(this.deveui);
  @override
  List<Object?> get props => [deveui];
}

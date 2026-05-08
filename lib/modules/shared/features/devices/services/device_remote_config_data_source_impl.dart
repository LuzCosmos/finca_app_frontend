import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_remote_config_api_service.dart';

/// Implementación HTTP del data source que usa `DeviceRemoteConfigApiService`.
/// Mantiene el BLoC desacoplado de HTTP para tests con mocks puros.
class DeviceRemoteConfigApiDataSource implements DeviceRemoteConfigDataSource {
  const DeviceRemoteConfigApiDataSource();

  @override
  Future<RemoteConfigStatusModel?> getStatus(String deveui) =>
      DeviceRemoteConfigApiService.getStatus(deveui);

  @override
  Future<List<ConfigurationProfileModel>> listProfiles() =>
      DeviceRemoteConfigApiService.listProfiles();

  @override
  Future<DeviceCommandPage> listCommands(
    String deveui, {
    int limit = 50,
    int offset = 0,
  }) {
    return DeviceRemoteConfigApiService.listCommands(
      deveui,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<DeviceCommandModel> applyProfile(String deveui, String idProfile) =>
      DeviceRemoteConfigApiService.applyProfile(deveui, idProfile);

  @override
  Future<DeviceCommandModel> requestPosition(String deveui) =>
      DeviceRemoteConfigApiService.requestPosition(deveui);

  @override
  Future<DeviceCommandModel> requestBattery(String deveui) =>
      DeviceRemoteConfigApiService.requestBattery(deveui);

  @override
  Future<DeviceCommandModel> clearManDown(String deveui) =>
      DeviceRemoteConfigApiService.clearManDown(deveui);

  @override
  Future<DeviceCommandModel> readParameters(
    String deveui,
    List<String> parameterNames,
  ) {
    return DeviceRemoteConfigApiService.readParameters(deveui, parameterNames);
  }

  @override
  Future<Map<String, dynamic>> readAllSafeParameters(String deveui) =>
      DeviceRemoteConfigApiService.readAllSafeParameters(deveui);

  @override
  Future<ReadSafeParametersChunkPlanModel> getReadSafeParametersChunkPlan(
    String deveui,
  ) {
    return DeviceRemoteConfigApiService.getReadSafeParametersChunkPlan(deveui);
  }

  @override
  Future<DeviceCommandModel> readSafeParametersChunk(
    String deveui,
    int chunkIndex,
  ) {
    return DeviceRemoteConfigApiService.readSafeParametersChunk(deveui, chunkIndex);
  }

  @override
  Future<DeviceCommandModel> configureParameters(
    String deveui,
    Map<String, dynamic> parameters,
  ) {
    return DeviceRemoteConfigApiService.configureParameters(deveui, parameters);
  }

  @override
  Future<Map<String, dynamic>> enableDiagnosticMode(
    String deveui, {
    int? ttlMinutes,
  }) {
    return DeviceRemoteConfigApiService.enableDiagnosticMode(
      deveui,
      ttlMinutes: ttlMinutes,
    );
  }

  @override
  Future<Map<String, dynamic>> disableDiagnosticMode(String deveui) =>
      DeviceRemoteConfigApiService.disableDiagnosticMode(deveui);

  @override
  Future<DeviceCommandModel> setLorawanOnlyPositioning(String deveui) =>
      DeviceRemoteConfigApiService.setLorawanOnlyPositioning(deveui);
}

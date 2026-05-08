// Modelos para configuración remota de collares MOKO LW001-BG PRO.
//
// Mapean los DTOs/entidades del backend NestJS:
//  - DeviceConfigurationProfile
//  - DeviceRemoteConfiguration
//  - DeviceDownlinkCommand

class ConfigurationProfileModel {
  final String id;
  final String? idTenant;
  final String code;
  final String name;
  final String? description;
  final Map<String, dynamic> parameters;
  final bool isSystem;
  final bool isActive;

  ConfigurationProfileModel({
    required this.id,
    required this.idTenant,
    required this.code,
    required this.name,
    required this.description,
    required this.parameters,
    required this.isSystem,
    required this.isActive,
  });

  factory ConfigurationProfileModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationProfileModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String?,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      parameters: Map<String, dynamic>.from(
        (json['parameters'] as Map?) ?? const {},
      ),
      isSystem: json['isSystem'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Snapshot del modo diagnóstico activo (silencia shock/man-down/tamper +
/// heartbeat al mínimo MOKO 300 s, con auto-restauración por TTL).
///
/// Mapea la columna `device_remote_configurations.diagnostic_state` del backend.
class DiagnosticStateModel {
  final DateTime enabledAt;
  final DateTime expiresAt;
  final int ttlMinutes;
  final String? enabledByUserId;

  /// Valores que el modo diagnóstico pisó al activarse, listos para restaurar.
  final Map<String, dynamic> previous;

  DiagnosticStateModel({
    required this.enabledAt,
    required this.expiresAt,
    required this.ttlMinutes,
    required this.enabledByUserId,
    required this.previous,
  });

  factory DiagnosticStateModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticStateModel(
      enabledAt: _parseDate(json['enabledAt']) ?? DateTime.now(),
      expiresAt: _parseDate(json['expiresAt']) ?? DateTime.now(),
      ttlMinutes: (json['ttlMinutes'] as num?)?.toInt() ?? 30,
      enabledByUserId: json['enabledByUserId'] as String?,
      previous: Map<String, dynamic>.from(
        (json['previous'] as Map?) ?? const {},
      ),
    );
  }

  Duration get remaining {
    final delta = expiresAt.difference(DateTime.now());
    return delta.isNegative ? Duration.zero : delta;
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class RemoteConfigStatusModel {
  final String idDevice;
  final String? idProfile;
  final Map<String, dynamic> profileSnapshot;
  final Map<String, dynamic> desired;
  final Map<String, dynamic> confirmed;
  final List<String> divergent;
  final int desiredVersion;
  final int confirmedVersion;
  final DateTime? lastPushedAt;
  final DateTime? lastConfirmedAt;
  final DiagnosticStateModel? diagnosticState;

  RemoteConfigStatusModel({
    required this.idDevice,
    required this.idProfile,
    required this.profileSnapshot,
    required this.desired,
    required this.confirmed,
    required this.divergent,
    required this.desiredVersion,
    required this.confirmedVersion,
    required this.lastPushedAt,
    required this.lastConfirmedAt,
    required this.diagnosticState,
  });

  bool get isInSync => divergent.isEmpty && desiredVersion <= confirmedVersion;

  bool get isDiagnosticActive =>
      diagnosticState != null && !diagnosticState!.isExpired;

  factory RemoteConfigStatusModel.fromJson(Map<String, dynamic> json) {
    final rawDiag = json['diagnosticState'];
    return RemoteConfigStatusModel(
      idDevice: json['idDevice'] as String,
      idProfile: json['idProfile'] as String?,
      profileSnapshot: Map<String, dynamic>.from(
        (json['profileSnapshot'] as Map?) ?? const {},
      ),
      desired: Map<String, dynamic>.from((json['desired'] as Map?) ?? const {}),
      confirmed: Map<String, dynamic>.from(
        (json['confirmed'] as Map?) ?? const {},
      ),
      divergent: List<String>.from(
        (json['divergent'] as List?) ?? const <String>[],
      ),
      desiredVersion: (json['desiredVersion'] as num?)?.toInt() ?? 0,
      confirmedVersion: (json['confirmedVersion'] as num?)?.toInt() ?? 0,
      lastPushedAt: _parseDate(json['lastPushedAt']),
      lastConfirmedAt: _parseDate(json['lastConfirmedAt']),
      diagnosticState: rawDiag is Map<String, dynamic>
          ? DiagnosticStateModel.fromJson(rawDiag)
          : null,
    );
  }
}

class DeviceCommandModel {
  final String id;
  final String idDevice;
  final String type;
  final String action;
  final int fPort;
  final String payloadHex;
  final String status;
  final String? errorMessage;
  final Map<String, dynamic> parameters;
  final String? chirpstackQueueItemId;
  final DateTime createdAt;
  final DateTime? queuedAt;
  final DateTime? sentAt;
  final DateTime? verifiedAt;

  DeviceCommandModel({
    required this.id,
    required this.idDevice,
    required this.type,
    required this.action,
    required this.fPort,
    required this.payloadHex,
    required this.status,
    required this.errorMessage,
    required this.parameters,
    required this.chirpstackQueueItemId,
    required this.createdAt,
    required this.queuedAt,
    required this.sentAt,
    required this.verifiedAt,
  });

  factory DeviceCommandModel.fromJson(Map<String, dynamic> json) {
    return DeviceCommandModel(
      id: json['id'] as String,
      idDevice: json['idDevice'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      fPort: (json['fPort'] as num).toInt(),
      payloadHex: json['payloadHex'] as String? ?? '',
      status: json['status'] as String,
      errorMessage: json['errorMessage'] as String?,
      parameters: Map<String, dynamic>.from(
        (json['parameters'] as Map?) ?? const {},
      ),
      chirpstackQueueItemId: json['chirpstackQueueItemId'] as String?,
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      queuedAt: _parseDate(json['queuedAt']),
      sentAt: _parseDate(json['sentAt']),
      verifiedAt: _parseDate(json['verifiedAt']),
    );
  }
}

class DeviceCommandPage {
  final List<DeviceCommandModel> items;
  final int total;

  DeviceCommandPage({required this.items, required this.total});

  factory DeviceCommandPage.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List?) ?? const [];
    return DeviceCommandPage(
      items: raw
          .map((e) => DeviceCommandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Un bloque del plan de lectura masiva segura (misma partición que el backend).
class ReadSafeParametersChunkItemModel {
  final int chunkIndex;
  final int count;
  final List<String> parameterNames;

  ReadSafeParametersChunkItemModel({
    required this.chunkIndex,
    required this.count,
    required this.parameterNames,
  });

  factory ReadSafeParametersChunkItemModel.fromJson(Map<String, dynamic> json) {
    return ReadSafeParametersChunkItemModel(
      chunkIndex: (json['chunkIndex'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      parameterNames: List<String>.from(
        (json['parameterNames'] as List?) ?? const <String>[],
      ),
    );
  }
}

/// Respuesta de `GET …/read-safe-parameters-chunks` (sin encolar downlinks).
class ReadSafeParametersChunkPlanModel {
  final int totalParameterIds;
  final int maxPerFrame;
  final int totalChunks;
  final List<ReadSafeParametersChunkItemModel> chunks;

  ReadSafeParametersChunkPlanModel({
    required this.totalParameterIds,
    required this.maxPerFrame,
    required this.totalChunks,
    required this.chunks,
  });

  factory ReadSafeParametersChunkPlanModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['chunks'] as List?) ?? const [];
    return ReadSafeParametersChunkPlanModel(
      totalParameterIds: (json['totalParameterIds'] as num).toInt(),
      maxPerFrame: (json['maxPerFrame'] as num).toInt(),
      totalChunks: (json['totalChunks'] as num).toInt(),
      chunks: raw
          .map((e) => ReadSafeParametersChunkItemModel.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is String) return DateTime.tryParse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return null;
}

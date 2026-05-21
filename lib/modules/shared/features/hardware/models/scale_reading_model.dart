class ScaleReadingModel {
  final String deviceId;
  final String tenantId;
  final double? weight;
  final String? unit;
  final bool isStable;
  final String? stabilityReason;
  final DateTime observedAt;
  final int sequence;

  const ScaleReadingModel({
    required this.deviceId,
    required this.tenantId,
    required this.weight,
    required this.unit,
    required this.isStable,
    this.stabilityReason,
    required this.observedAt,
    required this.sequence,
  });

  factory ScaleReadingModel.fromJson(Map<String, dynamic> json) {
    return ScaleReadingModel(
      deviceId: json['deviceId']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      weight: json['weight'] == null
          ? null
          : (json['weight'] is num
              ? (json['weight'] as num).toDouble()
              : double.tryParse(json['weight'].toString())),
      unit: json['unit']?.toString(),
      isStable: json['isStable'] == true,
      stabilityReason: json['stabilityReason']?.toString(),
      observedAt: DateTime.tryParse(json['observedAt']?.toString() ?? '') ??
          DateTime.now(),
      sequence: json['sequence'] is int
          ? json['sequence'] as int
          : int.tryParse(json['sequence']?.toString() ?? '0') ?? 0,
    );
  }
}

enum ScaleConnectionStatus {
  connected,
  disconnected,
  reconnecting,
  error,
}

class ScaleStatusModel {
  final String scaleId;
  final String tenantId;
  final ScaleConnectionStatus status;
  final DateTime updatedAt;

  const ScaleStatusModel({
    required this.scaleId,
    required this.tenantId,
    required this.status,
    required this.updatedAt,
  });

  factory ScaleStatusModel.fromJson(Map<String, dynamic> json) {
    final raw = json['status']?.toString() ?? 'disconnected';
    ScaleConnectionStatus status;
    switch (raw) {
      case 'connected':
        status = ScaleConnectionStatus.connected;
        break;
      case 'reconnecting':
        status = ScaleConnectionStatus.reconnecting;
        break;
      case 'error':
        status = ScaleConnectionStatus.error;
        break;
      default:
        status = ScaleConnectionStatus.disconnected;
    }
    return ScaleStatusModel(
      scaleId: json['scaleId']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      status: status,
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class ScaleReadingState {
  final ScaleConnectionStatus status;
  final ScaleReadingModel? latestReading;
  final ScaleReadingModel? latestStableReading;

  const ScaleReadingState({
    required this.status,
    this.latestReading,
    this.latestStableReading,
  });

  static const empty = ScaleReadingState(
    status: ScaleConnectionStatus.disconnected,
  );
}

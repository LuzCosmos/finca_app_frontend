class LatestCattleLocationModel {
  final String idTenant;
  final String idDevice;
  final String idCattle;
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime time;
  final String cattleNumber;

  const LatestCattleLocationModel({
    required this.idTenant,
    required this.idDevice,
    required this.idCattle,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.time,
    required this.cattleNumber,
  });

  static double _asDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.parse(v);
    throw ArgumentError('Invalid numeric value: $v');
  }

  factory LatestCattleLocationModel.fromJson(Map<String, dynamic> json) {
    return LatestCattleLocationModel(
      idTenant: (json['id_tenant'] ?? json['idTenant']) as String,
      idDevice: (json['id_device'] ?? json['idDevice']) as String,
      idCattle: (json['id_cattle'] ?? json['idCattle']) as String,
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      altitude: json['altitude'] == null ? null : _asDouble(json['altitude']),
      time: DateTime.parse(json['time'] as String),
      cattleNumber: (json['cattle_number'] ?? json['cattleNumber']) as String,
    );
  }
}


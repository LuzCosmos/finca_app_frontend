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

  static String _asString(dynamic v) {
    if (v == null) {
      throw ArgumentError('Invalid string value: $v');
    }
    return v.toString();
  }

  factory LatestCattleLocationModel.fromJson(Map<String, dynamic> json) {
    return LatestCattleLocationModel(
      idTenant: _asString(json['id_tenant'] ?? json['idTenant']),
      idDevice: _asString(json['id_device'] ?? json['idDevice']),
      idCattle: _asString(json['id_cattle'] ?? json['idCattle']),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      altitude: json['altitude'] == null ? null : _asDouble(json['altitude']),
      time: DateTime.parse(_asString(json['time'])),
      cattleNumber: _asString(json['cattle_number'] ?? json['cattleNumber']),
    );
  }
}

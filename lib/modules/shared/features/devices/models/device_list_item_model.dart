class DeviceListItemModel {
  const DeviceListItemModel({
    required this.id,
    required this.name,
    required this.deveui,
    required this.isActive,
    this.batteryStatus,
    this.deviceProfileName,
  });

  final String id;
  final String name;
  final String deveui;
  final bool isActive;
  final String? batteryStatus;
  final String? deviceProfileName;

  factory DeviceListItemModel.fromJson(Map<String, dynamic> json) {
    return DeviceListItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      deveui: json['deveui'] as String,
      isActive: json['isActive'] as bool? ?? true,
      batteryStatus: json['batteryStatus'] as String?,
      deviceProfileName: json['deviceProfileName'] as String?,
    );
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) || deveui.toLowerCase().contains(q);
  }
}

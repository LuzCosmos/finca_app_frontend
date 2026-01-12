class DeviceModel {
  final String id;
  final String name;
  final String deveui;

  DeviceModel({
    required this.id,
    required this.name,
    required this.deveui,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      deveui: json['deveui'] as String,
    );
  }

  @override
  String toString() => '$name ($deveui)';
}

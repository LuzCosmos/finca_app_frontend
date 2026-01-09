class RoleModel {
  final String id;
  final String code;
  final String name;

  RoleModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }
}

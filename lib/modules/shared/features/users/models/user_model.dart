import 'role_model.dart';

class UserModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? tenantId;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.tenantId,
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      tenantId: json['tenantId'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Nombres de rol para tablas: separados por coma, o raya (—) si no hay datos útiles.
  String get rolesTableCellText {
    const dash = '\u2014';
    if (roles.isEmpty) return dash;
    final names = roles
        .map((r) => r.name.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    if (names.isEmpty) return dash;
    return names.join(', ');
  }
}

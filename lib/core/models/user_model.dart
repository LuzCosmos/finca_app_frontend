class Role {
  final String id;
  final String code;
  final String name;
  final String description;

  Role({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    description: json['description'],
  );
}

class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String idTenant;
  final List<Role> roles;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.idTenant,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    email: json['email'],
    idTenant: json['tenant_id'],
    roles: (json['roles'] as List).map((r) => Role.fromJson(r)).toList(),
  );
}

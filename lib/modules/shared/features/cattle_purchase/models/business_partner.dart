enum BusinessPartnerRole {
  BUYER,
  TRANSPORTER,
  PROVIDER,
}

class BusinessPartnerModel {
  final String id;
  final String name;
  final String nit;
  final BusinessPartnerRole role;

  BusinessPartnerModel({
    required this.id,
    required this.name,
    required this.nit,
    required this.role,
  });

  factory BusinessPartnerModel.fromJson(Map<String, dynamic> json) {
    return BusinessPartnerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nit: json['nit'] as String,
      role: BusinessPartnerRole.values.firstWhere(
        (t) => t.name == json['type'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nit': nit, 'type': role.name};
  }

  @override
  String toString() => '$name ($nit)';
}

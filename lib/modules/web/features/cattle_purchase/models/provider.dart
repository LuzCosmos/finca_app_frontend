enum ProviderType {
  BUYER,
  TRANSPORTER,
  PROVIDER,
}

class ProviderModel {
  final String id;
  final String name;
  final String nit;
  final ProviderType type;

  ProviderModel({required this.id, required this.name, required this.nit, required this.type});

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nit: json['nit'] as String,
      type: ProviderType.values.firstWhere((t) => t.name == json['type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nit': nit, 'type': type.name};
  }

  @override
  String toString() => '$name ($nit)';
}


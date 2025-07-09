class ProviderModel {
  final String id;
  final String name;
  final String nit;

  ProviderModel({required this.id, required this.name, required this.nit});

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nit: json['nit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nit': nit};
  }

  @override
  String toString() => '$name ($nit)';
}

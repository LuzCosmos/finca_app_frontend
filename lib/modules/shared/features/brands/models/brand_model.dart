class BrandModel {
  final String id;
  final String idTenant;
  final String name;
  final String imageMimeType;
  final String imageBase64;

  BrandModel({
    required this.id,
    required this.idTenant,
    required this.name,
    required this.imageMimeType,
    required this.imageBase64,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      idTenant: json['idTenant'],
      name: json['name'],
      imageMimeType: json['imageMimeType'],
      imageBase64: json['imageBase64'],
    );
  }
}

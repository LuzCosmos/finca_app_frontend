import 'dart:typed_data';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class BrandModel {
  final String id;
  final String? idTenant;
  final String name;
  final String imageMimeType;
  Uint8List? imageBytes;
  final String imageBase64;

  BrandModel({
    required this.id,
    this.idTenant,
    required this.name,
    required this.imageMimeType,
    required this.imageBase64,
    this.imageBytes,
  });
  factory BrandModel.create({
    String? id,
    String? idTenant,
    required String name,
    required String imageMimeType,
    required String imageBase64,
    Uint8List? imageBytes,
  }) {
    return BrandModel(
      id: id ?? const Uuid().v4(),
      idTenant: idTenant,
      name: name,
      imageMimeType: imageMimeType,
      imageBase64: imageBase64,
      imageBytes: imageBytes,
    );
  }

  /*Map<String, dynamic> toJsonOnlineCreateApi() {
    return {
      'name': id,
      'idTenant': idTenant,
      'eventDate': formattedDate,
      'simpleEvents': simpleEvents.map((e) => e.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }*/

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    // Convertir base64 a binario
    final base64Data = json['imageBase64'] as String;
    final imageBytes = base64.decode(base64Data.split(',').last);
    return BrandModel(
      id: json['id'],
      idTenant: json['idTenant'],
      name: json['name'],
      imageMimeType: json['imageMimeType'],
      imageBase64: json['imageBase64'],
      imageBytes: imageBytes,
    );
  }
}

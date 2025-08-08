import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'dart:convert';

class AnimalSimpleEventModel {
  String? id;
  String? idTenant;
  final String? idAnimal;
  final String animalNumber;
  final SimpleEventType type;
  final String? data;
  final DateTime appliedAt;
  String? appliedBy;
  final String idMassiveEvent;
  final String idSimpleEvent;

  AnimalSimpleEventModel({
    this.id,
    this.idTenant,
    this.idAnimal,
    required this.animalNumber,
    required this.type,
    this.data,
    required this.appliedAt,
    this.appliedBy,
    required this.idMassiveEvent,
    required this.idSimpleEvent,
  });

  factory AnimalSimpleEventModel.fromJson(Map<String, dynamic> json) {
    return AnimalSimpleEventModel(
      id: json['id'],
      idTenant: json['idTenant'],
      idAnimal: json['idAnimal'],
      animalNumber: json['animalNumber'],
      type: SimpleEventType.values.firstWhere((e) => e.name == json['type']),
      appliedAt: DateTime.parse(json['appliedAt']),
      appliedBy: json['appliedBy'],
      idMassiveEvent: json['idMassiveEvent'],
      idSimpleEvent: json['idSimpleEvent'],
      data: json['data'] != null ? jsonEncode(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTenant': idTenant,
      'animalNumber': animalNumber,
      'type': type.name,
      'data': data != null ? jsonDecode(data!) : {},
      'appliedAt': appliedAt.toIso8601String(),
      'appliedBy': appliedBy,
      'idMassiveEvent': idMassiveEvent,
      'idSimpleEvent': idSimpleEvent,
    };
  }

  Map<String, dynamic> toJsonOnlineCreateApiForSingleAnimal() {
    return {
      'type': type.name,
      'data': data != null ? jsonDecode(data!) : {},
      'appliedBy': appliedBy,
      'idSimpleEvent': idSimpleEvent,
    };
  }
}

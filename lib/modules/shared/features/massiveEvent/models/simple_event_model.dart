import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

class SimpleEventModel {
  final String id; // UUID
  String? idTenant; // UUID
  String? idMassiveEvent;
  final SimpleEventType type; // tipo: medication, brand, weight, etc.
  final String? data; // datos adicionales en formato JSON
  final DateTime createdAt;
  final bool isActive; // si está activo para aplicar a nuevas reses

  SimpleEventModel({
    required this.id,
    this.idTenant,
    this.idMassiveEvent,
    required this.type,
    this.data,
    required this.createdAt,
    required this.isActive,
  });

  /// Crea un nuevo evento activo
  factory SimpleEventModel.create({
    required String name,
    required SimpleEventType type,
    String? data,
    String? idMassiveEvent,
    String? idTenant,
    String? id,
  }) {
    return SimpleEventModel(
      id: id ?? const Uuid().v4(),
      idTenant: idTenant,
      type: type,
      data: data,
      isActive: true,
      createdAt: DateTime.now(),
      idMassiveEvent: idMassiveEvent,
    );
  }

  /// Devuelve una copia con isActive modificado
  SimpleEventModel copyWith({bool? isActive}) {
    return SimpleEventModel(
      id: id,
      idTenant: idTenant,
      type: type,
      data: data,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      idMassiveEvent: idMassiveEvent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTenant': idTenant,
      'type': type.name,
      'data': data, // guarda como string
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'idMassiveEvent': idMassiveEvent,
    };
  }

  Map<String, dynamic> toJsonOnlineCreateApi() {
    if (idMassiveEvent == null) {
      if (data == null) {
        return {'type': type.name};
      } else {
        return {'type': type.name, 'data': data};
      }
    } else {
      if (data == null) {
        return {'type': type.name, 'idMassiveEvent': idMassiveEvent};
      } else {
        return {
          'type': type.name,
          'data': data,
          'idMassiveEvent': idMassiveEvent,
        };
      }
    }
  }

  factory SimpleEventModel.fromJson(
    Map<String, dynamic> json, {
    bool isActive = true,
  }) {
    return SimpleEventModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String,
      idMassiveEvent: json['idMassiveEvent'] as String?,
      type: SimpleEventType.values.firstWhere((e) => e.name == json['type']),
      data: json['data'] != null ? jsonEncode(json['data']) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: isActive,
    );
  }
}

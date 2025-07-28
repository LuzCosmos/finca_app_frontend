import 'package:uuid/uuid.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

class SimpleEventModel {
  final String id; // UUID
  String? idTenant; // UUID
  final EventType type; // tipo: medication, brand, weight, etc.
  final String? data; // datos adicionales en formato JSON
  final bool isActive; // si está activo para aplicar a nuevas reses
  final DateTime createdAt;
  final String? idMassiveEvent;

  SimpleEventModel({
    required this.id,
    this.idTenant,
    required this.type,
    this.data,
    required this.isActive,
    required this.createdAt,
    this.idMassiveEvent,
  });

  /// Crea un nuevo evento activo
  factory SimpleEventModel.create({
    required String name,
    required EventType type,
    String? data,
    String? idMassiveEvent,
    String? idTenant,
  }) {
    return SimpleEventModel(
      id: const Uuid().v4(),
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

  Map<String, dynamic> toJsonOnlineApi() {
    return {
      'id': id,
      'idTenant': idTenant,
      'type': type.name,
      'data': data,
      'idMassiveEvent': idMassiveEvent,
    };
  }

  factory SimpleEventModel.fromJson(Map<String, dynamic> json) {
    return SimpleEventModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String,
      type: EventType.values.firstWhere((e) => e.name == json['type']),
      data: json['data'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool,
      idMassiveEvent: json['idMassiveEvent'] as String?,
    );
  }
}

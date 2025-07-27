import 'package:uuid/uuid.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

class SimpleEventConfig {
  final String id; // UUID
  final String name; // nombre o descripción (ej: "Medication A")
  final EventType type; // tipo: medication, brand, weight, etc.
  final String? dataJson; // datos adicionales en formato JSON
  final bool isActive; // si está activo para aplicar a nuevas reses
  final DateTime createdAt;

  SimpleEventConfig({
    required this.id,
    required this.name,
    required this.type,
    this.dataJson,
    required this.isActive,
    required this.createdAt,
  });

  /// Crea un nuevo evento activo
  factory SimpleEventConfig.create({
    required String name,
    required EventType type,
    String? dataJson,
  }) {
    return SimpleEventConfig(
      id: const Uuid().v4(),
      name: name,
      type: type,
      dataJson: dataJson,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  /// Devuelve una copia con isActive modificado
  SimpleEventConfig copyWith({bool? isActive}) {
    return SimpleEventConfig(
      id: id,
      name: name,
      type: type,
      dataJson: dataJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'dataJson': dataJson, // guarda como string
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory SimpleEventConfig.fromJson(Map<String, dynamic> json) {
    return SimpleEventConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      type: EventType.values.firstWhere((e) => e.name == json['type']),
      dataJson: json['dataJson'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool,
    );
  }
}

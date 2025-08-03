import 'package:uuid/uuid.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:intl/intl.dart';

class MassiveEventModel {
  final String id;
  final DateTime eventDate;
  final List<SimpleEventModel> simpleEvents;
  String? idTenant;
  String status = 'open';
  DateTime createdAt;
  DateTime updatedAt;

  MassiveEventModel({
    required this.id,
    required this.eventDate,
    required this.simpleEvents,
    this.idTenant,
    this.status = 'open',
    required this.createdAt,
    required this.updatedAt,
  });

  factory MassiveEventModel.create({
    required DateTime eventDate,
    required List<SimpleEventModel> simpleEvents,
    String? idTenant,
    String? id,
    String status = 'open',
  }) {
    return MassiveEventModel(
      id: id ?? const Uuid().v4(),
      idTenant: idTenant,
      eventDate: eventDate,
      simpleEvents: simpleEvents,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Devuelve una copia con isActive modificado
  MassiveEventModel copyWith({bool? isActive}) {
    return MassiveEventModel(
      id: id,
      idTenant: idTenant,
      eventDate: eventDate,
      simpleEvents: simpleEvents,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
    return {
      'id': id,
      'idTenant': idTenant,
      'eventDate': formattedDate,
      'simpleEvents': simpleEvents.map((e) => e.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonOnlineCreateApi() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
    return {
      'eventDate': formattedDate,
      'simpleEvents':
          simpleEvents.map((e) => e.toJsonOnlineCreateApi()).toList(),
    };
  }

  factory MassiveEventModel.fromJson(Map<String, dynamic> json) {
    return MassiveEventModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      simpleEvents:
          (json['simpleEvents'] as List)
              .map((e) => SimpleEventModel.fromJson(e, isActive: true))
              .toList(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

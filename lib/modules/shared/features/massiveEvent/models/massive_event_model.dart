import 'package:uuid/uuid.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';

class MassiveEventModel {
  final String id; // UUID
  String? idTenant;
  final DateTime eventDate;
  final List<SimpleEventModel> simpleEvents;
  String status = 'open';

  MassiveEventModel({
    required this.id,
    this.idTenant,
    required this.eventDate,
    required this.simpleEvents,
    this.status = 'open',
  });

  factory MassiveEventModel.create({
    required DateTime eventDate,
    required List<SimpleEventModel> simpleEvents,
    String? idTenant,
    String? id,
    String status = 'open',
  }) {
    return MassiveEventModel(
      id: const Uuid().v4(),
      idTenant: idTenant,
      eventDate: eventDate,
      simpleEvents: simpleEvents,
      status: status,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTenant': idTenant,
      'eventDate': eventDate.toIso8601String(),
      'simpleEvents': simpleEvents.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }

  Map<String, dynamic> toJsonOnlineApi() {
    return {
      'id': id,
      'idTenant': idTenant,
      'eventDate': eventDate.toIso8601String(),
      'simpleEvents': simpleEvents.map((e) => e.toJsonOnlineApi()).toList(),
      'status': status,
    };
  }

  factory MassiveEventModel.fromJson(Map<String, dynamic> json) {
    return MassiveEventModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      simpleEvents:
          (json['simpleEvents'] as List)
              .map((e) => SimpleEventModel.fromJson(e))
              .toList(),
      status: json['status'] as String,
    );
  }
}

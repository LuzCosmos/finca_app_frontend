import 'package:uuid/uuid.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:intl/intl.dart';

class MassiveEventModel {
  final String id;
  final DateTime eventDate;
  final List<SimpleEventModel> simpleEvents;
  String? idTenant;
  String? name;
  String? createdBy;
  String status = 'open';
  DateTime createdAt;
  DateTime updatedAt;

  MassiveEventModel({
    required this.id,
    required this.eventDate,
    required this.simpleEvents,
    this.idTenant,
    this.name,
    this.createdBy,
    this.status = 'open',
    required this.createdAt,
    required this.updatedAt,
  });

  factory MassiveEventModel.create({
    required DateTime eventDate,
    required List<SimpleEventModel> simpleEvents,
    String? idTenant,
    String? id,
    String? name,
    String? createdBy,
    String status = 'open',
  }) {
    return MassiveEventModel(
      id: id ?? const Uuid().v4(),
      idTenant: idTenant,
      name: name,
      createdBy: createdBy,
      eventDate: eventDate,
      simpleEvents: simpleEvents,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MassiveEventModel copyWith({
    bool? isActive,
    String? name,
    String? createdBy,
    String? idTenant,
  }) {
    return MassiveEventModel(
      id: id,
      idTenant: idTenant ?? this.idTenant,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
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
      if (name != null) 'name': name,
      if (createdBy != null) 'createdBy': createdBy,
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
      name: json['name'] as String?,
      createdBy: json['createdBy'] as String?,
      eventDate: DateTime.parse(json['eventDate'] as String),
      simpleEvents:
          (json['simpleEvents'] as List)
              .map((e) => SimpleEventModel.fromJson(e))
              .toList(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

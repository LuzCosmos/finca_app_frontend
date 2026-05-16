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
  /// Username del creador (API); para mostrar en listas en lugar del UUID [createdBy].
  String? createdByUsername;
  String status = 'open';
  DateTime createdAt;
  DateTime updatedAt;
  /// En servidor/recepción: masivo creado para recepción de compra (excluido de lista autónoma).
  bool linkedToPurchaseReception;

  /// Listado autónomo: edición solo si el masivo sigue abierto (API puede variar mayúsculas).
  bool get isOpenForStandaloneListEdit =>
      status.toLowerCase().trim() == 'open';

  MassiveEventModel({
    required this.id,
    required this.eventDate,
    required this.simpleEvents,
    this.idTenant,
    this.name,
    this.createdBy,
    this.createdByUsername,
    this.status = 'open',
    required this.createdAt,
    required this.updatedAt,
    this.linkedToPurchaseReception = false,
  });

  factory MassiveEventModel.create({
    required DateTime eventDate,
    required List<SimpleEventModel> simpleEvents,
    String? idTenant,
    String? id,
    String? name,
    String? createdBy,
    String status = 'open',
    bool linkedToPurchaseReception = false,
  }) {
    return MassiveEventModel(
      id: id ?? const Uuid().v4(),
      idTenant: idTenant,
      name: name,
      createdBy: createdBy,
      createdByUsername: null,
      eventDate: eventDate,
      simpleEvents: simpleEvents,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      linkedToPurchaseReception: linkedToPurchaseReception,
    );
  }

  MassiveEventModel copyWith({
    bool? isActive,
    String? name,
    String? createdBy,
    String? createdByUsername,
    String? idTenant,
    List<SimpleEventModel>? simpleEvents,
  }) {
    return MassiveEventModel(
      id: id,
      idTenant: idTenant ?? this.idTenant,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      eventDate: eventDate,
      simpleEvents: simpleEvents ?? this.simpleEvents,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      linkedToPurchaseReception: linkedToPurchaseReception,
    );
  }

  Map<String, dynamic> toJson() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
    return {
      'id': id,
      'idTenant': idTenant,
      if (name != null) 'name': name,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdByUsername != null) 'createdByUsername': createdByUsername,
      'eventDate': formattedDate,
      'simpleEvents': simpleEvents.map((e) => e.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'linkedToPurchaseReception': linkedToPurchaseReception,
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
    final simpleRaw = json['simpleEvents'];
    final simpleList =
        simpleRaw is List
            ? simpleRaw.map((dynamic e) {
                final m = Map<String, dynamic>.from(e as Map);
                return SimpleEventModel.fromJson(m);
              }).toList()
            : <SimpleEventModel>[];
    return MassiveEventModel(
      id: json['id'] as String,
      idTenant: json['idTenant'] as String?,
      name: json['name'] as String?,
      createdBy: json['createdBy'] as String?,
      createdByUsername: json['createdByUsername'] as String?,
      eventDate: DateTime.parse(json['eventDate'] as String),
      simpleEvents: simpleList,
      status: json['status'] as String? ?? 'open',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      linkedToPurchaseReception: json['linkedToPurchaseReception'] as bool? ?? false,
    );
  }
}

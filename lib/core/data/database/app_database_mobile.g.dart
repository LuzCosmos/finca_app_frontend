// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_mobile.dart';

// ignore_for_file: type=lint
class $MassiveEventLocalTable extends MassiveEventLocal
    with TableInfo<$MassiveEventLocalTable, MassiveEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MassiveEventLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedToPurchaseReceptionMeta =
      const VerificationMeta('linkedToPurchaseReception');
  @override
  late final GeneratedColumn<bool> linkedToPurchaseReception =
      GeneratedColumn<bool>(
        'linked_to_purchase_reception',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("linked_to_purchase_reception" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    idTenant,
    name,
    eventDate,
    status,
    createdBy,
    linkedToPurchaseReception,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'massive_event_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<MassiveEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('linked_to_purchase_reception')) {
      context.handle(
        _linkedToPurchaseReceptionMeta,
        linkedToPurchaseReception.isAcceptableOrUnknown(
          data['linked_to_purchase_reception']!,
          _linkedToPurchaseReceptionMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MassiveEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MassiveEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      eventDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}event_date'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      linkedToPurchaseReception:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}linked_to_purchase_reception'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $MassiveEventLocalTable createAlias(String alias) {
    return $MassiveEventLocalTable(attachedDatabase, alias);
  }
}

class MassiveEvent extends DataClass implements Insertable<MassiveEvent> {
  final String id;
  final String? serverId;
  final String idTenant;
  final String name;
  final DateTime eventDate;
  final String status;
  final String? createdBy;
  final bool linkedToPurchaseReception;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const MassiveEvent({
    required this.id,
    this.serverId,
    required this.idTenant,
    required this.name,
    required this.eventDate,
    required this.status,
    this.createdBy,
    required this.linkedToPurchaseReception,
    required this.isSynced,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['id_tenant'] = Variable<String>(idTenant);
    map['name'] = Variable<String>(name);
    map['event_date'] = Variable<DateTime>(eventDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['linked_to_purchase_reception'] = Variable<bool>(
      linkedToPurchaseReception,
    );
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  MassiveEventLocalCompanion toCompanion(bool nullToAbsent) {
    return MassiveEventLocalCompanion(
      id: Value(id),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      idTenant: Value(idTenant),
      name: Value(name),
      eventDate: Value(eventDate),
      status: Value(status),
      createdBy:
          createdBy == null && nullToAbsent
              ? const Value.absent()
              : Value(createdBy),
      linkedToPurchaseReception: Value(linkedToPurchaseReception),
      isSynced: Value(isSynced),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory MassiveEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MassiveEvent(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      name: serializer.fromJson<String>(json['name']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      linkedToPurchaseReception: serializer.fromJson<bool>(
        json['linkedToPurchaseReception'],
      ),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'idTenant': serializer.toJson<String>(idTenant),
      'name': serializer.toJson<String>(name),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String?>(createdBy),
      'linkedToPurchaseReception': serializer.toJson<bool>(
        linkedToPurchaseReception,
      ),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  MassiveEvent copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? idTenant,
    String? name,
    DateTime? eventDate,
    String? status,
    Value<String?> createdBy = const Value.absent(),
    bool? linkedToPurchaseReception,
    bool? isSynced,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => MassiveEvent(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    idTenant: idTenant ?? this.idTenant,
    name: name ?? this.name,
    eventDate: eventDate ?? this.eventDate,
    status: status ?? this.status,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    linkedToPurchaseReception:
        linkedToPurchaseReception ?? this.linkedToPurchaseReception,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  MassiveEvent copyWithCompanion(MassiveEventLocalCompanion data) {
    return MassiveEvent(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      name: data.name.present ? data.name.value : this.name,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      linkedToPurchaseReception:
          data.linkedToPurchaseReception.present
              ? data.linkedToPurchaseReception.value
              : this.linkedToPurchaseReception,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MassiveEvent(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('eventDate: $eventDate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('linkedToPurchaseReception: $linkedToPurchaseReception, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    idTenant,
    name,
    eventDate,
    status,
    createdBy,
    linkedToPurchaseReception,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MassiveEvent &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.idTenant == this.idTenant &&
          other.name == this.name &&
          other.eventDate == this.eventDate &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.linkedToPurchaseReception == this.linkedToPurchaseReception &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MassiveEventLocalCompanion extends UpdateCompanion<MassiveEvent> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> idTenant;
  final Value<String> name;
  final Value<DateTime> eventDate;
  final Value<String> status;
  final Value<String?> createdBy;
  final Value<bool> linkedToPurchaseReception;
  final Value<bool> isSynced;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const MassiveEventLocalCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.name = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.linkedToPurchaseReception = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MassiveEventLocalCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String idTenant,
    required String name,
    required DateTime eventDate,
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.linkedToPurchaseReception = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       name = Value(name),
       eventDate = Value(eventDate);
  static Insertable<MassiveEvent> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? idTenant,
    Expression<String>? name,
    Expression<DateTime>? eventDate,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<bool>? linkedToPurchaseReception,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (idTenant != null) 'id_tenant': idTenant,
      if (name != null) 'name': name,
      if (eventDate != null) 'event_date': eventDate,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (linkedToPurchaseReception != null)
        'linked_to_purchase_reception': linkedToPurchaseReception,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MassiveEventLocalCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? idTenant,
    Value<String>? name,
    Value<DateTime>? eventDate,
    Value<String>? status,
    Value<String?>? createdBy,
    Value<bool>? linkedToPurchaseReception,
    Value<bool>? isSynced,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return MassiveEventLocalCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      idTenant: idTenant ?? this.idTenant,
      name: name ?? this.name,
      eventDate: eventDate ?? this.eventDate,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      linkedToPurchaseReception:
          linkedToPurchaseReception ?? this.linkedToPurchaseReception,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (linkedToPurchaseReception.present) {
      map['linked_to_purchase_reception'] = Variable<bool>(
        linkedToPurchaseReception.value,
      );
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MassiveEventLocalCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('eventDate: $eventDate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('linkedToPurchaseReception: $linkedToPurchaseReception, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SimpleEventLocalTable extends SimpleEventLocal
    with TableInfo<$SimpleEventLocalTable, SimpleEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SimpleEventLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMassiveEventMeta = const VerificationMeta(
    'idMassiveEvent',
  );
  @override
  late final GeneratedColumn<String> idMassiveEvent = GeneratedColumn<String>(
    'id_massive_event',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    idTenant,
    idMassiveEvent,
    type,
    data,
    isActive,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'simple_event_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<SimpleEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('id_massive_event')) {
      context.handle(
        _idMassiveEventMeta,
        idMassiveEvent.isAcceptableOrUnknown(
          data['id_massive_event']!,
          _idMassiveEventMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idMassiveEventMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SimpleEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SimpleEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      idMassiveEvent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_massive_event'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $SimpleEventLocalTable createAlias(String alias) {
    return $SimpleEventLocalTable(attachedDatabase, alias);
  }
}

class SimpleEvent extends DataClass implements Insertable<SimpleEvent> {
  final String id;
  final String? serverId;
  final String idTenant;
  final String idMassiveEvent;
  final String type;
  final String? data;
  final bool isActive;
  final bool isSynced;
  final DateTime? createdAt;
  const SimpleEvent({
    required this.id,
    this.serverId,
    required this.idTenant,
    required this.idMassiveEvent,
    required this.type,
    this.data,
    required this.isActive,
    required this.isSynced,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['id_tenant'] = Variable<String>(idTenant);
    map['id_massive_event'] = Variable<String>(idMassiveEvent);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  SimpleEventLocalCompanion toCompanion(bool nullToAbsent) {
    return SimpleEventLocalCompanion(
      id: Value(id),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      idTenant: Value(idTenant),
      idMassiveEvent: Value(idMassiveEvent),
      type: Value(type),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
    );
  }

  factory SimpleEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SimpleEvent(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      idMassiveEvent: serializer.fromJson<String>(json['idMassiveEvent']),
      type: serializer.fromJson<String>(json['type']),
      data: serializer.fromJson<String?>(json['data']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'idTenant': serializer.toJson<String>(idTenant),
      'idMassiveEvent': serializer.toJson<String>(idMassiveEvent),
      'type': serializer.toJson<String>(type),
      'data': serializer.toJson<String?>(data),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  SimpleEvent copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? idTenant,
    String? idMassiveEvent,
    String? type,
    Value<String?> data = const Value.absent(),
    bool? isActive,
    bool? isSynced,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => SimpleEvent(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    idTenant: idTenant ?? this.idTenant,
    idMassiveEvent: idMassiveEvent ?? this.idMassiveEvent,
    type: type ?? this.type,
    data: data.present ? data.value : this.data,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  SimpleEvent copyWithCompanion(SimpleEventLocalCompanion data) {
    return SimpleEvent(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      idMassiveEvent:
          data.idMassiveEvent.present
              ? data.idMassiveEvent.value
              : this.idMassiveEvent,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SimpleEvent(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTenant: $idTenant, ')
          ..write('idMassiveEvent: $idMassiveEvent, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    idTenant,
    idMassiveEvent,
    type,
    data,
    isActive,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SimpleEvent &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.idTenant == this.idTenant &&
          other.idMassiveEvent == this.idMassiveEvent &&
          other.type == this.type &&
          other.data == this.data &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class SimpleEventLocalCompanion extends UpdateCompanion<SimpleEvent> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> idTenant;
  final Value<String> idMassiveEvent;
  final Value<String> type;
  final Value<String?> data;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const SimpleEventLocalCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.idMassiveEvent = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SimpleEventLocalCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String idTenant,
    required String idMassiveEvent,
    required String type,
    this.data = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       idMassiveEvent = Value(idMassiveEvent),
       type = Value(type);
  static Insertable<SimpleEvent> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? idTenant,
    Expression<String>? idMassiveEvent,
    Expression<String>? type,
    Expression<String>? data,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (idTenant != null) 'id_tenant': idTenant,
      if (idMassiveEvent != null) 'id_massive_event': idMassiveEvent,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SimpleEventLocalCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? idTenant,
    Value<String>? idMassiveEvent,
    Value<String>? type,
    Value<String?>? data,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return SimpleEventLocalCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      idTenant: idTenant ?? this.idTenant,
      idMassiveEvent: idMassiveEvent ?? this.idMassiveEvent,
      type: type ?? this.type,
      data: data ?? this.data,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (idMassiveEvent.present) {
      map['id_massive_event'] = Variable<String>(idMassiveEvent.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SimpleEventLocalCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idTenant: $idTenant, ')
          ..write('idMassiveEvent: $idMassiveEvent, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnimalSimpleEventLocalTable extends AnimalSimpleEventLocal
    with TableInfo<$AnimalSimpleEventLocalTable, AnimalSimpleEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalSimpleEventLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalNumberMeta = const VerificationMeta(
    'animalNumber',
  );
  @override
  late final GeneratedColumn<String> animalNumber = GeneratedColumn<String>(
    'animal_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMassiveEventMeta = const VerificationMeta(
    'idMassiveEvent',
  );
  @override
  late final GeneratedColumn<String> idMassiveEvent = GeneratedColumn<String>(
    'id_massive_event',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idSimpleEventMeta = const VerificationMeta(
    'idSimpleEvent',
  );
  @override
  late final GeneratedColumn<String> idSimpleEvent = GeneratedColumn<String>(
    'id_simple_event',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedByMeta = const VerificationMeta(
    'appliedBy',
  );
  @override
  late final GeneratedColumn<String> appliedBy = GeneratedColumn<String>(
    'applied_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedInMassiveEventMeta =
      const VerificationMeta('recordedInMassiveEvent');
  @override
  late final GeneratedColumn<String> recordedInMassiveEvent =
      GeneratedColumn<String>(
        'recorded_in_massive_event',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isInvalidMeta = const VerificationMeta(
    'isInvalid',
  );
  @override
  late final GeneratedColumn<bool> isInvalid = GeneratedColumn<bool>(
    'is_invalid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_invalid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTenant,
    animalNumber,
    type,
    data,
    idMassiveEvent,
    idSimpleEvent,
    appliedAt,
    appliedBy,
    recordedInMassiveEvent,
    isSynced,
    isInvalid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animal_simple_event_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnimalSimpleEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('animal_number')) {
      context.handle(
        _animalNumberMeta,
        animalNumber.isAcceptableOrUnknown(
          data['animal_number']!,
          _animalNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_animalNumberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('id_massive_event')) {
      context.handle(
        _idMassiveEventMeta,
        idMassiveEvent.isAcceptableOrUnknown(
          data['id_massive_event']!,
          _idMassiveEventMeta,
        ),
      );
    }
    if (data.containsKey('id_simple_event')) {
      context.handle(
        _idSimpleEventMeta,
        idSimpleEvent.isAcceptableOrUnknown(
          data['id_simple_event']!,
          _idSimpleEventMeta,
        ),
      );
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedAtMeta);
    }
    if (data.containsKey('applied_by')) {
      context.handle(
        _appliedByMeta,
        appliedBy.isAcceptableOrUnknown(data['applied_by']!, _appliedByMeta),
      );
    }
    if (data.containsKey('recorded_in_massive_event')) {
      context.handle(
        _recordedInMassiveEventMeta,
        recordedInMassiveEvent.isAcceptableOrUnknown(
          data['recorded_in_massive_event']!,
          _recordedInMassiveEventMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_invalid')) {
      context.handle(
        _isInvalidMeta,
        isInvalid.isAcceptableOrUnknown(data['is_invalid']!, _isInvalidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnimalSimpleEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimalSimpleEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      animalNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}animal_number'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      idMassiveEvent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_massive_event'],
      ),
      idSimpleEvent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_simple_event'],
      ),
      appliedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}applied_at'],
          )!,
      appliedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_by'],
      ),
      recordedInMassiveEvent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_in_massive_event'],
      ),
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      isInvalid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_invalid'],
          )!,
    );
  }

  @override
  $AnimalSimpleEventLocalTable createAlias(String alias) {
    return $AnimalSimpleEventLocalTable(attachedDatabase, alias);
  }
}

class AnimalSimpleEvent extends DataClass
    implements Insertable<AnimalSimpleEvent> {
  final String id;
  final String idTenant;
  final String animalNumber;
  final String type;
  final String? data;
  final String? idMassiveEvent;
  final String? idSimpleEvent;
  final DateTime appliedAt;
  final String? appliedBy;
  final String? recordedInMassiveEvent;
  final bool isSynced;
  final bool isInvalid;
  const AnimalSimpleEvent({
    required this.id,
    required this.idTenant,
    required this.animalNumber,
    required this.type,
    this.data,
    this.idMassiveEvent,
    this.idSimpleEvent,
    required this.appliedAt,
    this.appliedBy,
    this.recordedInMassiveEvent,
    required this.isSynced,
    required this.isInvalid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_tenant'] = Variable<String>(idTenant);
    map['animal_number'] = Variable<String>(animalNumber);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    if (!nullToAbsent || idMassiveEvent != null) {
      map['id_massive_event'] = Variable<String>(idMassiveEvent);
    }
    if (!nullToAbsent || idSimpleEvent != null) {
      map['id_simple_event'] = Variable<String>(idSimpleEvent);
    }
    map['applied_at'] = Variable<DateTime>(appliedAt);
    if (!nullToAbsent || appliedBy != null) {
      map['applied_by'] = Variable<String>(appliedBy);
    }
    if (!nullToAbsent || recordedInMassiveEvent != null) {
      map['recorded_in_massive_event'] = Variable<String>(
        recordedInMassiveEvent,
      );
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_invalid'] = Variable<bool>(isInvalid);
    return map;
  }

  AnimalSimpleEventLocalCompanion toCompanion(bool nullToAbsent) {
    return AnimalSimpleEventLocalCompanion(
      id: Value(id),
      idTenant: Value(idTenant),
      animalNumber: Value(animalNumber),
      type: Value(type),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      idMassiveEvent:
          idMassiveEvent == null && nullToAbsent
              ? const Value.absent()
              : Value(idMassiveEvent),
      idSimpleEvent:
          idSimpleEvent == null && nullToAbsent
              ? const Value.absent()
              : Value(idSimpleEvent),
      appliedAt: Value(appliedAt),
      appliedBy:
          appliedBy == null && nullToAbsent
              ? const Value.absent()
              : Value(appliedBy),
      recordedInMassiveEvent:
          recordedInMassiveEvent == null && nullToAbsent
              ? const Value.absent()
              : Value(recordedInMassiveEvent),
      isSynced: Value(isSynced),
      isInvalid: Value(isInvalid),
    );
  }

  factory AnimalSimpleEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimalSimpleEvent(
      id: serializer.fromJson<String>(json['id']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      animalNumber: serializer.fromJson<String>(json['animalNumber']),
      type: serializer.fromJson<String>(json['type']),
      data: serializer.fromJson<String?>(json['data']),
      idMassiveEvent: serializer.fromJson<String?>(json['idMassiveEvent']),
      idSimpleEvent: serializer.fromJson<String?>(json['idSimpleEvent']),
      appliedAt: serializer.fromJson<DateTime>(json['appliedAt']),
      appliedBy: serializer.fromJson<String?>(json['appliedBy']),
      recordedInMassiveEvent: serializer.fromJson<String?>(
        json['recordedInMassiveEvent'],
      ),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isInvalid: serializer.fromJson<bool>(json['isInvalid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTenant': serializer.toJson<String>(idTenant),
      'animalNumber': serializer.toJson<String>(animalNumber),
      'type': serializer.toJson<String>(type),
      'data': serializer.toJson<String?>(data),
      'idMassiveEvent': serializer.toJson<String?>(idMassiveEvent),
      'idSimpleEvent': serializer.toJson<String?>(idSimpleEvent),
      'appliedAt': serializer.toJson<DateTime>(appliedAt),
      'appliedBy': serializer.toJson<String?>(appliedBy),
      'recordedInMassiveEvent': serializer.toJson<String?>(
        recordedInMassiveEvent,
      ),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isInvalid': serializer.toJson<bool>(isInvalid),
    };
  }

  AnimalSimpleEvent copyWith({
    String? id,
    String? idTenant,
    String? animalNumber,
    String? type,
    Value<String?> data = const Value.absent(),
    Value<String?> idMassiveEvent = const Value.absent(),
    Value<String?> idSimpleEvent = const Value.absent(),
    DateTime? appliedAt,
    Value<String?> appliedBy = const Value.absent(),
    Value<String?> recordedInMassiveEvent = const Value.absent(),
    bool? isSynced,
    bool? isInvalid,
  }) => AnimalSimpleEvent(
    id: id ?? this.id,
    idTenant: idTenant ?? this.idTenant,
    animalNumber: animalNumber ?? this.animalNumber,
    type: type ?? this.type,
    data: data.present ? data.value : this.data,
    idMassiveEvent:
        idMassiveEvent.present ? idMassiveEvent.value : this.idMassiveEvent,
    idSimpleEvent:
        idSimpleEvent.present ? idSimpleEvent.value : this.idSimpleEvent,
    appliedAt: appliedAt ?? this.appliedAt,
    appliedBy: appliedBy.present ? appliedBy.value : this.appliedBy,
    recordedInMassiveEvent:
        recordedInMassiveEvent.present
            ? recordedInMassiveEvent.value
            : this.recordedInMassiveEvent,
    isSynced: isSynced ?? this.isSynced,
    isInvalid: isInvalid ?? this.isInvalid,
  );
  AnimalSimpleEvent copyWithCompanion(AnimalSimpleEventLocalCompanion data) {
    return AnimalSimpleEvent(
      id: data.id.present ? data.id.value : this.id,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      animalNumber:
          data.animalNumber.present
              ? data.animalNumber.value
              : this.animalNumber,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      idMassiveEvent:
          data.idMassiveEvent.present
              ? data.idMassiveEvent.value
              : this.idMassiveEvent,
      idSimpleEvent:
          data.idSimpleEvent.present
              ? data.idSimpleEvent.value
              : this.idSimpleEvent,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      appliedBy: data.appliedBy.present ? data.appliedBy.value : this.appliedBy,
      recordedInMassiveEvent:
          data.recordedInMassiveEvent.present
              ? data.recordedInMassiveEvent.value
              : this.recordedInMassiveEvent,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isInvalid: data.isInvalid.present ? data.isInvalid.value : this.isInvalid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimalSimpleEvent(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('animalNumber: $animalNumber, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('idMassiveEvent: $idMassiveEvent, ')
          ..write('idSimpleEvent: $idSimpleEvent, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('appliedBy: $appliedBy, ')
          ..write('recordedInMassiveEvent: $recordedInMassiveEvent, ')
          ..write('isSynced: $isSynced, ')
          ..write('isInvalid: $isInvalid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idTenant,
    animalNumber,
    type,
    data,
    idMassiveEvent,
    idSimpleEvent,
    appliedAt,
    appliedBy,
    recordedInMassiveEvent,
    isSynced,
    isInvalid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimalSimpleEvent &&
          other.id == this.id &&
          other.idTenant == this.idTenant &&
          other.animalNumber == this.animalNumber &&
          other.type == this.type &&
          other.data == this.data &&
          other.idMassiveEvent == this.idMassiveEvent &&
          other.idSimpleEvent == this.idSimpleEvent &&
          other.appliedAt == this.appliedAt &&
          other.appliedBy == this.appliedBy &&
          other.recordedInMassiveEvent == this.recordedInMassiveEvent &&
          other.isSynced == this.isSynced &&
          other.isInvalid == this.isInvalid);
}

class AnimalSimpleEventLocalCompanion
    extends UpdateCompanion<AnimalSimpleEvent> {
  final Value<String> id;
  final Value<String> idTenant;
  final Value<String> animalNumber;
  final Value<String> type;
  final Value<String?> data;
  final Value<String?> idMassiveEvent;
  final Value<String?> idSimpleEvent;
  final Value<DateTime> appliedAt;
  final Value<String?> appliedBy;
  final Value<String?> recordedInMassiveEvent;
  final Value<bool> isSynced;
  final Value<bool> isInvalid;
  final Value<int> rowid;
  const AnimalSimpleEventLocalCompanion({
    this.id = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.animalNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.idMassiveEvent = const Value.absent(),
    this.idSimpleEvent = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.appliedBy = const Value.absent(),
    this.recordedInMassiveEvent = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isInvalid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalSimpleEventLocalCompanion.insert({
    required String id,
    required String idTenant,
    required String animalNumber,
    required String type,
    this.data = const Value.absent(),
    this.idMassiveEvent = const Value.absent(),
    this.idSimpleEvent = const Value.absent(),
    required DateTime appliedAt,
    this.appliedBy = const Value.absent(),
    this.recordedInMassiveEvent = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isInvalid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       animalNumber = Value(animalNumber),
       type = Value(type),
       appliedAt = Value(appliedAt);
  static Insertable<AnimalSimpleEvent> custom({
    Expression<String>? id,
    Expression<String>? idTenant,
    Expression<String>? animalNumber,
    Expression<String>? type,
    Expression<String>? data,
    Expression<String>? idMassiveEvent,
    Expression<String>? idSimpleEvent,
    Expression<DateTime>? appliedAt,
    Expression<String>? appliedBy,
    Expression<String>? recordedInMassiveEvent,
    Expression<bool>? isSynced,
    Expression<bool>? isInvalid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTenant != null) 'id_tenant': idTenant,
      if (animalNumber != null) 'animal_number': animalNumber,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (idMassiveEvent != null) 'id_massive_event': idMassiveEvent,
      if (idSimpleEvent != null) 'id_simple_event': idSimpleEvent,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (appliedBy != null) 'applied_by': appliedBy,
      if (recordedInMassiveEvent != null)
        'recorded_in_massive_event': recordedInMassiveEvent,
      if (isSynced != null) 'is_synced': isSynced,
      if (isInvalid != null) 'is_invalid': isInvalid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalSimpleEventLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? idTenant,
    Value<String>? animalNumber,
    Value<String>? type,
    Value<String?>? data,
    Value<String?>? idMassiveEvent,
    Value<String?>? idSimpleEvent,
    Value<DateTime>? appliedAt,
    Value<String?>? appliedBy,
    Value<String?>? recordedInMassiveEvent,
    Value<bool>? isSynced,
    Value<bool>? isInvalid,
    Value<int>? rowid,
  }) {
    return AnimalSimpleEventLocalCompanion(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      animalNumber: animalNumber ?? this.animalNumber,
      type: type ?? this.type,
      data: data ?? this.data,
      idMassiveEvent: idMassiveEvent ?? this.idMassiveEvent,
      idSimpleEvent: idSimpleEvent ?? this.idSimpleEvent,
      appliedAt: appliedAt ?? this.appliedAt,
      appliedBy: appliedBy ?? this.appliedBy,
      recordedInMassiveEvent:
          recordedInMassiveEvent ?? this.recordedInMassiveEvent,
      isSynced: isSynced ?? this.isSynced,
      isInvalid: isInvalid ?? this.isInvalid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (animalNumber.present) {
      map['animal_number'] = Variable<String>(animalNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (idMassiveEvent.present) {
      map['id_massive_event'] = Variable<String>(idMassiveEvent.value);
    }
    if (idSimpleEvent.present) {
      map['id_simple_event'] = Variable<String>(idSimpleEvent.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (appliedBy.present) {
      map['applied_by'] = Variable<String>(appliedBy.value);
    }
    if (recordedInMassiveEvent.present) {
      map['recorded_in_massive_event'] = Variable<String>(
        recordedInMassiveEvent.value,
      );
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isInvalid.present) {
      map['is_invalid'] = Variable<bool>(isInvalid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalSimpleEventLocalCompanion(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('animalNumber: $animalNumber, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('idMassiveEvent: $idMassiveEvent, ')
          ..write('idSimpleEvent: $idSimpleEvent, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('appliedBy: $appliedBy, ')
          ..write('recordedInMassiveEvent: $recordedInMassiveEvent, ')
          ..write('isSynced: $isSynced, ')
          ..write('isInvalid: $isInvalid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandLocalTable extends BrandLocal
    with TableInfo<$BrandLocalTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageBytesMeta = const VerificationMeta(
    'imageBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> imageBytes = GeneratedColumn<Uint8List>(
    'image_bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMimeTypeMeta = const VerificationMeta(
    'imageMimeType',
  );
  @override
  late final GeneratedColumn<String> imageMimeType = GeneratedColumn<String>(
    'image_mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageFileNameMeta = const VerificationMeta(
    'imageFileName',
  );
  @override
  late final GeneratedColumn<String> imageFileName = GeneratedColumn<String>(
    'image_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTenant,
    name,
    imageBytes,
    imageMimeType,
    imageFileName,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brand_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_bytes')) {
      context.handle(
        _imageBytesMeta,
        imageBytes.isAcceptableOrUnknown(data['image_bytes']!, _imageBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_imageBytesMeta);
    }
    if (data.containsKey('image_mime_type')) {
      context.handle(
        _imageMimeTypeMeta,
        imageMimeType.isAcceptableOrUnknown(
          data['image_mime_type']!,
          _imageMimeTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imageMimeTypeMeta);
    }
    if (data.containsKey('image_file_name')) {
      context.handle(
        _imageFileNameMeta,
        imageFileName.isAcceptableOrUnknown(
          data['image_file_name']!,
          _imageFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imageFileNameMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      imageBytes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.blob,
            data['${effectivePrefix}image_bytes'],
          )!,
      imageMimeType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}image_mime_type'],
          )!,
      imageFileName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}image_file_name'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $BrandLocalTable createAlias(String alias) {
    return $BrandLocalTable(attachedDatabase, alias);
  }
}

class Brand extends DataClass implements Insertable<Brand> {
  final String id;
  final String idTenant;
  final String name;
  final Uint8List imageBytes;
  final String imageMimeType;
  final String imageFileName;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Brand({
    required this.id,
    required this.idTenant,
    required this.name,
    required this.imageBytes,
    required this.imageMimeType,
    required this.imageFileName,
    required this.isSynced,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_tenant'] = Variable<String>(idTenant);
    map['name'] = Variable<String>(name);
    map['image_bytes'] = Variable<Uint8List>(imageBytes);
    map['image_mime_type'] = Variable<String>(imageMimeType);
    map['image_file_name'] = Variable<String>(imageFileName);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BrandLocalCompanion toCompanion(bool nullToAbsent) {
    return BrandLocalCompanion(
      id: Value(id),
      idTenant: Value(idTenant),
      name: Value(name),
      imageBytes: Value(imageBytes),
      imageMimeType: Value(imageMimeType),
      imageFileName: Value(imageFileName),
      isSynced: Value(isSynced),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Brand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<String>(json['id']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      name: serializer.fromJson<String>(json['name']),
      imageBytes: serializer.fromJson<Uint8List>(json['imageBytes']),
      imageMimeType: serializer.fromJson<String>(json['imageMimeType']),
      imageFileName: serializer.fromJson<String>(json['imageFileName']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTenant': serializer.toJson<String>(idTenant),
      'name': serializer.toJson<String>(name),
      'imageBytes': serializer.toJson<Uint8List>(imageBytes),
      'imageMimeType': serializer.toJson<String>(imageMimeType),
      'imageFileName': serializer.toJson<String>(imageFileName),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Brand copyWith({
    String? id,
    String? idTenant,
    String? name,
    Uint8List? imageBytes,
    String? imageMimeType,
    String? imageFileName,
    bool? isSynced,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Brand(
    id: id ?? this.id,
    idTenant: idTenant ?? this.idTenant,
    name: name ?? this.name,
    imageBytes: imageBytes ?? this.imageBytes,
    imageMimeType: imageMimeType ?? this.imageMimeType,
    imageFileName: imageFileName ?? this.imageFileName,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Brand copyWithCompanion(BrandLocalCompanion data) {
    return Brand(
      id: data.id.present ? data.id.value : this.id,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      name: data.name.present ? data.name.value : this.name,
      imageBytes:
          data.imageBytes.present ? data.imageBytes.value : this.imageBytes,
      imageMimeType:
          data.imageMimeType.present
              ? data.imageMimeType.value
              : this.imageMimeType,
      imageFileName:
          data.imageFileName.present
              ? data.imageFileName.value
              : this.imageFileName,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brand(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('imageMimeType: $imageMimeType, ')
          ..write('imageFileName: $imageFileName, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idTenant,
    name,
    $driftBlobEquality.hash(imageBytes),
    imageMimeType,
    imageFileName,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brand &&
          other.id == this.id &&
          other.idTenant == this.idTenant &&
          other.name == this.name &&
          $driftBlobEquality.equals(other.imageBytes, this.imageBytes) &&
          other.imageMimeType == this.imageMimeType &&
          other.imageFileName == this.imageFileName &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BrandLocalCompanion extends UpdateCompanion<Brand> {
  final Value<String> id;
  final Value<String> idTenant;
  final Value<String> name;
  final Value<Uint8List> imageBytes;
  final Value<String> imageMimeType;
  final Value<String> imageFileName;
  final Value<bool> isSynced;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BrandLocalCompanion({
    this.id = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.name = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.imageMimeType = const Value.absent(),
    this.imageFileName = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandLocalCompanion.insert({
    required String id,
    required String idTenant,
    required String name,
    required Uint8List imageBytes,
    required String imageMimeType,
    required String imageFileName,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       name = Value(name),
       imageBytes = Value(imageBytes),
       imageMimeType = Value(imageMimeType),
       imageFileName = Value(imageFileName);
  static Insertable<Brand> custom({
    Expression<String>? id,
    Expression<String>? idTenant,
    Expression<String>? name,
    Expression<Uint8List>? imageBytes,
    Expression<String>? imageMimeType,
    Expression<String>? imageFileName,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTenant != null) 'id_tenant': idTenant,
      if (name != null) 'name': name,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (imageMimeType != null) 'image_mime_type': imageMimeType,
      if (imageFileName != null) 'image_file_name': imageFileName,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? idTenant,
    Value<String>? name,
    Value<Uint8List>? imageBytes,
    Value<String>? imageMimeType,
    Value<String>? imageFileName,
    Value<bool>? isSynced,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return BrandLocalCompanion(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      imageMimeType: imageMimeType ?? this.imageMimeType,
      imageFileName: imageFileName ?? this.imageFileName,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageBytes.present) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes.value);
    }
    if (imageMimeType.present) {
      map['image_mime_type'] = Variable<String>(imageMimeType.value);
    }
    if (imageFileName.present) {
      map['image_file_name'] = Variable<String>(imageFileName.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandLocalCompanion(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('imageMimeType: $imageMimeType, ')
          ..write('imageFileName: $imageFileName, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CattleLocalTable extends CattleLocal
    with TableInfo<$CattleLocalTable, CattleLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CattleLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
  );
  static const VerificationMeta _idDeviceMeta = const VerificationMeta(
    'idDevice',
  );
  @override
  late final GeneratedColumn<String> idDevice = GeneratedColumn<String>(
    'id_device',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTenant,
    number,
    weight,
    status,
    idDevice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cattle_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<CattleLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('id_device')) {
      context.handle(
        _idDeviceMeta,
        idDevice.isAcceptableOrUnknown(data['id_device']!, _idDeviceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CattleLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CattleLocalData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      number:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}number'],
          )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      idDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_device'],
      ),
    );
  }

  @override
  $CattleLocalTable createAlias(String alias) {
    return $CattleLocalTable(attachedDatabase, alias);
  }
}

class CattleLocalData extends DataClass implements Insertable<CattleLocalData> {
  final String id;
  final String idTenant;
  final String number;
  final double? weight;
  final String status;
  final String? idDevice;
  const CattleLocalData({
    required this.id,
    required this.idTenant,
    required this.number,
    this.weight,
    required this.status,
    this.idDevice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_tenant'] = Variable<String>(idTenant);
    map['number'] = Variable<String>(number);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || idDevice != null) {
      map['id_device'] = Variable<String>(idDevice);
    }
    return map;
  }

  CattleLocalCompanion toCompanion(bool nullToAbsent) {
    return CattleLocalCompanion(
      id: Value(id),
      idTenant: Value(idTenant),
      number: Value(number),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      status: Value(status),
      idDevice:
          idDevice == null && nullToAbsent
              ? const Value.absent()
              : Value(idDevice),
    );
  }

  factory CattleLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CattleLocalData(
      id: serializer.fromJson<String>(json['id']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      number: serializer.fromJson<String>(json['number']),
      weight: serializer.fromJson<double?>(json['weight']),
      status: serializer.fromJson<String>(json['status']),
      idDevice: serializer.fromJson<String?>(json['idDevice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTenant': serializer.toJson<String>(idTenant),
      'number': serializer.toJson<String>(number),
      'weight': serializer.toJson<double?>(weight),
      'status': serializer.toJson<String>(status),
      'idDevice': serializer.toJson<String?>(idDevice),
    };
  }

  CattleLocalData copyWith({
    String? id,
    String? idTenant,
    String? number,
    Value<double?> weight = const Value.absent(),
    String? status,
    Value<String?> idDevice = const Value.absent(),
  }) => CattleLocalData(
    id: id ?? this.id,
    idTenant: idTenant ?? this.idTenant,
    number: number ?? this.number,
    weight: weight.present ? weight.value : this.weight,
    status: status ?? this.status,
    idDevice: idDevice.present ? idDevice.value : this.idDevice,
  );
  CattleLocalData copyWithCompanion(CattleLocalCompanion data) {
    return CattleLocalData(
      id: data.id.present ? data.id.value : this.id,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      number: data.number.present ? data.number.value : this.number,
      weight: data.weight.present ? data.weight.value : this.weight,
      status: data.status.present ? data.status.value : this.status,
      idDevice: data.idDevice.present ? data.idDevice.value : this.idDevice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CattleLocalData(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('number: $number, ')
          ..write('weight: $weight, ')
          ..write('status: $status, ')
          ..write('idDevice: $idDevice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idTenant, number, weight, status, idDevice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CattleLocalData &&
          other.id == this.id &&
          other.idTenant == this.idTenant &&
          other.number == this.number &&
          other.weight == this.weight &&
          other.status == this.status &&
          other.idDevice == this.idDevice);
}

class CattleLocalCompanion extends UpdateCompanion<CattleLocalData> {
  final Value<String> id;
  final Value<String> idTenant;
  final Value<String> number;
  final Value<double?> weight;
  final Value<String> status;
  final Value<String?> idDevice;
  final Value<int> rowid;
  const CattleLocalCompanion({
    this.id = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.number = const Value.absent(),
    this.weight = const Value.absent(),
    this.status = const Value.absent(),
    this.idDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CattleLocalCompanion.insert({
    required String id,
    required String idTenant,
    required String number,
    this.weight = const Value.absent(),
    this.status = const Value.absent(),
    this.idDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       number = Value(number);
  static Insertable<CattleLocalData> custom({
    Expression<String>? id,
    Expression<String>? idTenant,
    Expression<String>? number,
    Expression<double>? weight,
    Expression<String>? status,
    Expression<String>? idDevice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTenant != null) 'id_tenant': idTenant,
      if (number != null) 'number': number,
      if (weight != null) 'weight': weight,
      if (status != null) 'status': status,
      if (idDevice != null) 'id_device': idDevice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CattleLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? idTenant,
    Value<String>? number,
    Value<double?>? weight,
    Value<String>? status,
    Value<String?>? idDevice,
    Value<int>? rowid,
  }) {
    return CattleLocalCompanion(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      number: number ?? this.number,
      weight: weight ?? this.weight,
      status: status ?? this.status,
      idDevice: idDevice ?? this.idDevice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (idDevice.present) {
      map['id_device'] = Variable<String>(idDevice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CattleLocalCompanion(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('number: $number, ')
          ..write('weight: $weight, ')
          ..write('status: $status, ')
          ..write('idDevice: $idDevice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProviderLocalTable extends ProviderLocal
    with TableInfo<$ProviderLocalTable, ProviderLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nitMeta = const VerificationMeta('nit');
  @override
  late final GeneratedColumn<String> nit = GeneratedColumn<String>(
    'nit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTenant,
    name,
    nit,
    type,
    address,
    phone,
    email,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nit')) {
      context.handle(
        _nitMeta,
        nit.isAcceptableOrUnknown(data['nit']!, _nitMeta),
      );
    } else if (isInserting) {
      context.missing(_nitMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderLocalData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      nit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nit'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
    );
  }

  @override
  $ProviderLocalTable createAlias(String alias) {
    return $ProviderLocalTable(attachedDatabase, alias);
  }
}

class ProviderLocalData extends DataClass
    implements Insertable<ProviderLocalData> {
  final String id;
  final String idTenant;
  final String name;
  final String nit;
  final String type;
  final String? address;
  final String? phone;
  final String? email;
  const ProviderLocalData({
    required this.id,
    required this.idTenant,
    required this.name,
    required this.nit,
    required this.type,
    this.address,
    this.phone,
    this.email,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_tenant'] = Variable<String>(idTenant);
    map['name'] = Variable<String>(name);
    map['nit'] = Variable<String>(nit);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    return map;
  }

  ProviderLocalCompanion toCompanion(bool nullToAbsent) {
    return ProviderLocalCompanion(
      id: Value(id),
      idTenant: Value(idTenant),
      name: Value(name),
      nit: Value(nit),
      type: Value(type),
      address:
          address == null && nullToAbsent
              ? const Value.absent()
              : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
    );
  }

  factory ProviderLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderLocalData(
      id: serializer.fromJson<String>(json['id']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      name: serializer.fromJson<String>(json['name']),
      nit: serializer.fromJson<String>(json['nit']),
      type: serializer.fromJson<String>(json['type']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTenant': serializer.toJson<String>(idTenant),
      'name': serializer.toJson<String>(name),
      'nit': serializer.toJson<String>(nit),
      'type': serializer.toJson<String>(type),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
    };
  }

  ProviderLocalData copyWith({
    String? id,
    String? idTenant,
    String? name,
    String? nit,
    String? type,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
  }) => ProviderLocalData(
    id: id ?? this.id,
    idTenant: idTenant ?? this.idTenant,
    name: name ?? this.name,
    nit: nit ?? this.nit,
    type: type ?? this.type,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
  );
  ProviderLocalData copyWithCompanion(ProviderLocalCompanion data) {
    return ProviderLocalData(
      id: data.id.present ? data.id.value : this.id,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      name: data.name.present ? data.name.value : this.name,
      nit: data.nit.present ? data.nit.value : this.nit,
      type: data.type.present ? data.type.value : this.type,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderLocalData(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('nit: $nit, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idTenant, name, nit, type, address, phone, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderLocalData &&
          other.id == this.id &&
          other.idTenant == this.idTenant &&
          other.name == this.name &&
          other.nit == this.nit &&
          other.type == this.type &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email);
}

class ProviderLocalCompanion extends UpdateCompanion<ProviderLocalData> {
  final Value<String> id;
  final Value<String> idTenant;
  final Value<String> name;
  final Value<String> nit;
  final Value<String> type;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<int> rowid;
  const ProviderLocalCompanion({
    this.id = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.name = const Value.absent(),
    this.nit = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProviderLocalCompanion.insert({
    required String id,
    required String idTenant,
    required String name,
    required String nit,
    required String type,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       name = Value(name),
       nit = Value(nit),
       type = Value(type);
  static Insertable<ProviderLocalData> custom({
    Expression<String>? id,
    Expression<String>? idTenant,
    Expression<String>? name,
    Expression<String>? nit,
    Expression<String>? type,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTenant != null) 'id_tenant': idTenant,
      if (name != null) 'name': name,
      if (nit != null) 'nit': nit,
      if (type != null) 'type': type,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProviderLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? idTenant,
    Value<String>? name,
    Value<String>? nit,
    Value<String>? type,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? email,
    Value<int>? rowid,
  }) {
    return ProviderLocalCompanion(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      name: name ?? this.name,
      nit: nit ?? this.nit,
      type: type ?? this.type,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nit.present) {
      map['nit'] = Variable<String>(nit.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderLocalCompanion(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('name: $name, ')
          ..write('nit: $nit, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleLocalTable extends SaleLocal
    with TableInfo<$SaleLocalTable, SaleLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTenantMeta = const VerificationMeta(
    'idTenant',
  );
  @override
  late final GeneratedColumn<String> idTenant = GeneratedColumn<String>(
    'id_tenant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _buyerIdMeta = const VerificationMeta(
    'buyerId',
  );
  @override
  late final GeneratedColumn<String> buyerId = GeneratedColumn<String>(
    'buyer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transporterIdMeta = const VerificationMeta(
    'transporterId',
  );
  @override
  late final GeneratedColumn<String> transporterId = GeneratedColumn<String>(
    'transporter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minWeightConfigMeta = const VerificationMeta(
    'minWeightConfig',
  );
  @override
  late final GeneratedColumn<double> minWeightConfig = GeneratedColumn<double>(
    'min_weight_config',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _valuePerKgConfigMeta = const VerificationMeta(
    'valuePerKgConfig',
  );
  @override
  late final GeneratedColumn<double> valuePerKgConfig = GeneratedColumn<double>(
    'value_per_kg_config',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalWeightMeta = const VerificationMeta(
    'totalWeight',
  );
  @override
  late final GeneratedColumn<double> totalWeight = GeneratedColumn<double>(
    'total_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCountMeta = const VerificationMeta(
    'totalCount',
  );
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
    'total_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTenant,
    transactionDate,
    buyerId,
    transporterId,
    minWeightConfig,
    valuePerKgConfig,
    totalAmount,
    totalWeight,
    totalCount,
    notes,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_tenant')) {
      context.handle(
        _idTenantMeta,
        idTenant.isAcceptableOrUnknown(data['id_tenant']!, _idTenantMeta),
      );
    } else if (isInserting) {
      context.missing(_idTenantMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(
        _buyerIdMeta,
        buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('transporter_id')) {
      context.handle(
        _transporterIdMeta,
        transporterId.isAcceptableOrUnknown(
          data['transporter_id']!,
          _transporterIdMeta,
        ),
      );
    }
    if (data.containsKey('min_weight_config')) {
      context.handle(
        _minWeightConfigMeta,
        minWeightConfig.isAcceptableOrUnknown(
          data['min_weight_config']!,
          _minWeightConfigMeta,
        ),
      );
    }
    if (data.containsKey('value_per_kg_config')) {
      context.handle(
        _valuePerKgConfigMeta,
        valuePerKgConfig.isAcceptableOrUnknown(
          data['value_per_kg_config']!,
          _valuePerKgConfigMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_weight')) {
      context.handle(
        _totalWeightMeta,
        totalWeight.isAcceptableOrUnknown(
          data['total_weight']!,
          _totalWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalWeightMeta);
    }
    if (data.containsKey('total_count')) {
      context.handle(
        _totalCountMeta,
        totalCount.isAcceptableOrUnknown(data['total_count']!, _totalCountMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLocalData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      idTenant:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_tenant'],
          )!,
      transactionDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}transaction_date'],
          )!,
      buyerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}buyer_id'],
          )!,
      transporterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transporter_id'],
      ),
      minWeightConfig:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}min_weight_config'],
          )!,
      valuePerKgConfig:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}value_per_kg_config'],
          )!,
      totalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_amount'],
          )!,
      totalWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_weight'],
          )!,
      totalCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_count'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
    );
  }

  @override
  $SaleLocalTable createAlias(String alias) {
    return $SaleLocalTable(attachedDatabase, alias);
  }
}

class SaleLocalData extends DataClass implements Insertable<SaleLocalData> {
  final String id;
  final String idTenant;
  final DateTime transactionDate;
  final String buyerId;
  final String? transporterId;
  final double minWeightConfig;
  final double valuePerKgConfig;
  final double totalAmount;
  final double totalWeight;
  final int totalCount;
  final String? notes;
  final bool isSynced;
  const SaleLocalData({
    required this.id,
    required this.idTenant,
    required this.transactionDate,
    required this.buyerId,
    this.transporterId,
    required this.minWeightConfig,
    required this.valuePerKgConfig,
    required this.totalAmount,
    required this.totalWeight,
    required this.totalCount,
    this.notes,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_tenant'] = Variable<String>(idTenant);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['buyer_id'] = Variable<String>(buyerId);
    if (!nullToAbsent || transporterId != null) {
      map['transporter_id'] = Variable<String>(transporterId);
    }
    map['min_weight_config'] = Variable<double>(minWeightConfig);
    map['value_per_kg_config'] = Variable<double>(valuePerKgConfig);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_weight'] = Variable<double>(totalWeight);
    map['total_count'] = Variable<int>(totalCount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  SaleLocalCompanion toCompanion(bool nullToAbsent) {
    return SaleLocalCompanion(
      id: Value(id),
      idTenant: Value(idTenant),
      transactionDate: Value(transactionDate),
      buyerId: Value(buyerId),
      transporterId:
          transporterId == null && nullToAbsent
              ? const Value.absent()
              : Value(transporterId),
      minWeightConfig: Value(minWeightConfig),
      valuePerKgConfig: Value(valuePerKgConfig),
      totalAmount: Value(totalAmount),
      totalWeight: Value(totalWeight),
      totalCount: Value(totalCount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isSynced: Value(isSynced),
    );
  }

  factory SaleLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLocalData(
      id: serializer.fromJson<String>(json['id']),
      idTenant: serializer.fromJson<String>(json['idTenant']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      buyerId: serializer.fromJson<String>(json['buyerId']),
      transporterId: serializer.fromJson<String?>(json['transporterId']),
      minWeightConfig: serializer.fromJson<double>(json['minWeightConfig']),
      valuePerKgConfig: serializer.fromJson<double>(json['valuePerKgConfig']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalWeight: serializer.fromJson<double>(json['totalWeight']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idTenant': serializer.toJson<String>(idTenant),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'buyerId': serializer.toJson<String>(buyerId),
      'transporterId': serializer.toJson<String?>(transporterId),
      'minWeightConfig': serializer.toJson<double>(minWeightConfig),
      'valuePerKgConfig': serializer.toJson<double>(valuePerKgConfig),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalWeight': serializer.toJson<double>(totalWeight),
      'totalCount': serializer.toJson<int>(totalCount),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  SaleLocalData copyWith({
    String? id,
    String? idTenant,
    DateTime? transactionDate,
    String? buyerId,
    Value<String?> transporterId = const Value.absent(),
    double? minWeightConfig,
    double? valuePerKgConfig,
    double? totalAmount,
    double? totalWeight,
    int? totalCount,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
  }) => SaleLocalData(
    id: id ?? this.id,
    idTenant: idTenant ?? this.idTenant,
    transactionDate: transactionDate ?? this.transactionDate,
    buyerId: buyerId ?? this.buyerId,
    transporterId:
        transporterId.present ? transporterId.value : this.transporterId,
    minWeightConfig: minWeightConfig ?? this.minWeightConfig,
    valuePerKgConfig: valuePerKgConfig ?? this.valuePerKgConfig,
    totalAmount: totalAmount ?? this.totalAmount,
    totalWeight: totalWeight ?? this.totalWeight,
    totalCount: totalCount ?? this.totalCount,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
  );
  SaleLocalData copyWithCompanion(SaleLocalCompanion data) {
    return SaleLocalData(
      id: data.id.present ? data.id.value : this.id,
      idTenant: data.idTenant.present ? data.idTenant.value : this.idTenant,
      transactionDate:
          data.transactionDate.present
              ? data.transactionDate.value
              : this.transactionDate,
      buyerId: data.buyerId.present ? data.buyerId.value : this.buyerId,
      transporterId:
          data.transporterId.present
              ? data.transporterId.value
              : this.transporterId,
      minWeightConfig:
          data.minWeightConfig.present
              ? data.minWeightConfig.value
              : this.minWeightConfig,
      valuePerKgConfig:
          data.valuePerKgConfig.present
              ? data.valuePerKgConfig.value
              : this.valuePerKgConfig,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      totalWeight:
          data.totalWeight.present ? data.totalWeight.value : this.totalWeight,
      totalCount:
          data.totalCount.present ? data.totalCount.value : this.totalCount,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLocalData(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('buyerId: $buyerId, ')
          ..write('transporterId: $transporterId, ')
          ..write('minWeightConfig: $minWeightConfig, ')
          ..write('valuePerKgConfig: $valuePerKgConfig, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalWeight: $totalWeight, ')
          ..write('totalCount: $totalCount, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idTenant,
    transactionDate,
    buyerId,
    transporterId,
    minWeightConfig,
    valuePerKgConfig,
    totalAmount,
    totalWeight,
    totalCount,
    notes,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLocalData &&
          other.id == this.id &&
          other.idTenant == this.idTenant &&
          other.transactionDate == this.transactionDate &&
          other.buyerId == this.buyerId &&
          other.transporterId == this.transporterId &&
          other.minWeightConfig == this.minWeightConfig &&
          other.valuePerKgConfig == this.valuePerKgConfig &&
          other.totalAmount == this.totalAmount &&
          other.totalWeight == this.totalWeight &&
          other.totalCount == this.totalCount &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced);
}

class SaleLocalCompanion extends UpdateCompanion<SaleLocalData> {
  final Value<String> id;
  final Value<String> idTenant;
  final Value<DateTime> transactionDate;
  final Value<String> buyerId;
  final Value<String?> transporterId;
  final Value<double> minWeightConfig;
  final Value<double> valuePerKgConfig;
  final Value<double> totalAmount;
  final Value<double> totalWeight;
  final Value<int> totalCount;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const SaleLocalCompanion({
    this.id = const Value.absent(),
    this.idTenant = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.transporterId = const Value.absent(),
    this.minWeightConfig = const Value.absent(),
    this.valuePerKgConfig = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalWeight = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleLocalCompanion.insert({
    required String id,
    required String idTenant,
    required DateTime transactionDate,
    required String buyerId,
    this.transporterId = const Value.absent(),
    this.minWeightConfig = const Value.absent(),
    this.valuePerKgConfig = const Value.absent(),
    required double totalAmount,
    required double totalWeight,
    required int totalCount,
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       transactionDate = Value(transactionDate),
       buyerId = Value(buyerId),
       totalAmount = Value(totalAmount),
       totalWeight = Value(totalWeight),
       totalCount = Value(totalCount);
  static Insertable<SaleLocalData> custom({
    Expression<String>? id,
    Expression<String>? idTenant,
    Expression<DateTime>? transactionDate,
    Expression<String>? buyerId,
    Expression<String>? transporterId,
    Expression<double>? minWeightConfig,
    Expression<double>? valuePerKgConfig,
    Expression<double>? totalAmount,
    Expression<double>? totalWeight,
    Expression<int>? totalCount,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTenant != null) 'id_tenant': idTenant,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (buyerId != null) 'buyer_id': buyerId,
      if (transporterId != null) 'transporter_id': transporterId,
      if (minWeightConfig != null) 'min_weight_config': minWeightConfig,
      if (valuePerKgConfig != null) 'value_per_kg_config': valuePerKgConfig,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalWeight != null) 'total_weight': totalWeight,
      if (totalCount != null) 'total_count': totalCount,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? idTenant,
    Value<DateTime>? transactionDate,
    Value<String>? buyerId,
    Value<String?>? transporterId,
    Value<double>? minWeightConfig,
    Value<double>? valuePerKgConfig,
    Value<double>? totalAmount,
    Value<double>? totalWeight,
    Value<int>? totalCount,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return SaleLocalCompanion(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      transactionDate: transactionDate ?? this.transactionDate,
      buyerId: buyerId ?? this.buyerId,
      transporterId: transporterId ?? this.transporterId,
      minWeightConfig: minWeightConfig ?? this.minWeightConfig,
      valuePerKgConfig: valuePerKgConfig ?? this.valuePerKgConfig,
      totalAmount: totalAmount ?? this.totalAmount,
      totalWeight: totalWeight ?? this.totalWeight,
      totalCount: totalCount ?? this.totalCount,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idTenant.present) {
      map['id_tenant'] = Variable<String>(idTenant.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<String>(buyerId.value);
    }
    if (transporterId.present) {
      map['transporter_id'] = Variable<String>(transporterId.value);
    }
    if (minWeightConfig.present) {
      map['min_weight_config'] = Variable<double>(minWeightConfig.value);
    }
    if (valuePerKgConfig.present) {
      map['value_per_kg_config'] = Variable<double>(valuePerKgConfig.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalWeight.present) {
      map['total_weight'] = Variable<double>(totalWeight.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLocalCompanion(')
          ..write('id: $id, ')
          ..write('idTenant: $idTenant, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('buyerId: $buyerId, ')
          ..write('transporterId: $transporterId, ')
          ..write('minWeightConfig: $minWeightConfig, ')
          ..write('valuePerKgConfig: $valuePerKgConfig, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalWeight: $totalWeight, ')
          ..write('totalCount: $totalCount, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleDetailLocalTable extends SaleDetailLocal
    with TableInfo<$SaleDetailLocalTable, SaleDetailLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleDetailLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sale_local (id)',
    ),
  );
  static const VerificationMeta _cattleIdMeta = const VerificationMeta(
    'cattleId',
  );
  @override
  late final GeneratedColumn<String> cattleId = GeneratedColumn<String>(
    'cattle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredWeightMeta = const VerificationMeta(
    'measuredWeight',
  );
  @override
  late final GeneratedColumn<double> measuredWeight = GeneratedColumn<double>(
    'measured_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isApprovedMeta = const VerificationMeta(
    'isApproved',
  );
  @override
  late final GeneratedColumn<bool> isApproved = GeneratedColumn<bool>(
    'is_approved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_approved" IN (0, 1))',
    ),
  );
  static const VerificationMeta _rejectionReasonMeta = const VerificationMeta(
    'rejectionReason',
  );
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
    'rejection_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackerRemovedMeta = const VerificationMeta(
    'trackerRemoved',
  );
  @override
  late final GeneratedColumn<bool> trackerRemoved = GeneratedColumn<bool>(
    'tracker_removed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tracker_removed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    cattleId,
    measuredWeight,
    price,
    isApproved,
    rejectionReason,
    trackerRemoved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_detail_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleDetailLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('cattle_id')) {
      context.handle(
        _cattleIdMeta,
        cattleId.isAcceptableOrUnknown(data['cattle_id']!, _cattleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cattleIdMeta);
    }
    if (data.containsKey('measured_weight')) {
      context.handle(
        _measuredWeightMeta,
        measuredWeight.isAcceptableOrUnknown(
          data['measured_weight']!,
          _measuredWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measuredWeightMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('is_approved')) {
      context.handle(
        _isApprovedMeta,
        isApproved.isAcceptableOrUnknown(data['is_approved']!, _isApprovedMeta),
      );
    } else if (isInserting) {
      context.missing(_isApprovedMeta);
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
        _rejectionReasonMeta,
        rejectionReason.isAcceptableOrUnknown(
          data['rejection_reason']!,
          _rejectionReasonMeta,
        ),
      );
    }
    if (data.containsKey('tracker_removed')) {
      context.handle(
        _trackerRemovedMeta,
        trackerRemoved.isAcceptableOrUnknown(
          data['tracker_removed']!,
          _trackerRemovedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleDetailLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleDetailLocalData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      saleId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sale_id'],
          )!,
      cattleId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cattle_id'],
          )!,
      measuredWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}measured_weight'],
          )!,
      price:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}price'],
          )!,
      isApproved:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_approved'],
          )!,
      rejectionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_reason'],
      ),
      trackerRemoved:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}tracker_removed'],
          )!,
    );
  }

  @override
  $SaleDetailLocalTable createAlias(String alias) {
    return $SaleDetailLocalTable(attachedDatabase, alias);
  }
}

class SaleDetailLocalData extends DataClass
    implements Insertable<SaleDetailLocalData> {
  final String id;
  final String saleId;
  final String cattleId;
  final double measuredWeight;
  final double price;
  final bool isApproved;
  final String? rejectionReason;
  final bool trackerRemoved;
  const SaleDetailLocalData({
    required this.id,
    required this.saleId,
    required this.cattleId,
    required this.measuredWeight,
    required this.price,
    required this.isApproved,
    this.rejectionReason,
    required this.trackerRemoved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['cattle_id'] = Variable<String>(cattleId);
    map['measured_weight'] = Variable<double>(measuredWeight);
    map['price'] = Variable<double>(price);
    map['is_approved'] = Variable<bool>(isApproved);
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['tracker_removed'] = Variable<bool>(trackerRemoved);
    return map;
  }

  SaleDetailLocalCompanion toCompanion(bool nullToAbsent) {
    return SaleDetailLocalCompanion(
      id: Value(id),
      saleId: Value(saleId),
      cattleId: Value(cattleId),
      measuredWeight: Value(measuredWeight),
      price: Value(price),
      isApproved: Value(isApproved),
      rejectionReason:
          rejectionReason == null && nullToAbsent
              ? const Value.absent()
              : Value(rejectionReason),
      trackerRemoved: Value(trackerRemoved),
    );
  }

  factory SaleDetailLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleDetailLocalData(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      cattleId: serializer.fromJson<String>(json['cattleId']),
      measuredWeight: serializer.fromJson<double>(json['measuredWeight']),
      price: serializer.fromJson<double>(json['price']),
      isApproved: serializer.fromJson<bool>(json['isApproved']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      trackerRemoved: serializer.fromJson<bool>(json['trackerRemoved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'cattleId': serializer.toJson<String>(cattleId),
      'measuredWeight': serializer.toJson<double>(measuredWeight),
      'price': serializer.toJson<double>(price),
      'isApproved': serializer.toJson<bool>(isApproved),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'trackerRemoved': serializer.toJson<bool>(trackerRemoved),
    };
  }

  SaleDetailLocalData copyWith({
    String? id,
    String? saleId,
    String? cattleId,
    double? measuredWeight,
    double? price,
    bool? isApproved,
    Value<String?> rejectionReason = const Value.absent(),
    bool? trackerRemoved,
  }) => SaleDetailLocalData(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    cattleId: cattleId ?? this.cattleId,
    measuredWeight: measuredWeight ?? this.measuredWeight,
    price: price ?? this.price,
    isApproved: isApproved ?? this.isApproved,
    rejectionReason:
        rejectionReason.present ? rejectionReason.value : this.rejectionReason,
    trackerRemoved: trackerRemoved ?? this.trackerRemoved,
  );
  SaleDetailLocalData copyWithCompanion(SaleDetailLocalCompanion data) {
    return SaleDetailLocalData(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      cattleId: data.cattleId.present ? data.cattleId.value : this.cattleId,
      measuredWeight:
          data.measuredWeight.present
              ? data.measuredWeight.value
              : this.measuredWeight,
      price: data.price.present ? data.price.value : this.price,
      isApproved:
          data.isApproved.present ? data.isApproved.value : this.isApproved,
      rejectionReason:
          data.rejectionReason.present
              ? data.rejectionReason.value
              : this.rejectionReason,
      trackerRemoved:
          data.trackerRemoved.present
              ? data.trackerRemoved.value
              : this.trackerRemoved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleDetailLocalData(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('cattleId: $cattleId, ')
          ..write('measuredWeight: $measuredWeight, ')
          ..write('price: $price, ')
          ..write('isApproved: $isApproved, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('trackerRemoved: $trackerRemoved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    cattleId,
    measuredWeight,
    price,
    isApproved,
    rejectionReason,
    trackerRemoved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleDetailLocalData &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.cattleId == this.cattleId &&
          other.measuredWeight == this.measuredWeight &&
          other.price == this.price &&
          other.isApproved == this.isApproved &&
          other.rejectionReason == this.rejectionReason &&
          other.trackerRemoved == this.trackerRemoved);
}

class SaleDetailLocalCompanion extends UpdateCompanion<SaleDetailLocalData> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> cattleId;
  final Value<double> measuredWeight;
  final Value<double> price;
  final Value<bool> isApproved;
  final Value<String?> rejectionReason;
  final Value<bool> trackerRemoved;
  final Value<int> rowid;
  const SaleDetailLocalCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.cattleId = const Value.absent(),
    this.measuredWeight = const Value.absent(),
    this.price = const Value.absent(),
    this.isApproved = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.trackerRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleDetailLocalCompanion.insert({
    required String id,
    required String saleId,
    required String cattleId,
    required double measuredWeight,
    required double price,
    required bool isApproved,
    this.rejectionReason = const Value.absent(),
    this.trackerRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       cattleId = Value(cattleId),
       measuredWeight = Value(measuredWeight),
       price = Value(price),
       isApproved = Value(isApproved);
  static Insertable<SaleDetailLocalData> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? cattleId,
    Expression<double>? measuredWeight,
    Expression<double>? price,
    Expression<bool>? isApproved,
    Expression<String>? rejectionReason,
    Expression<bool>? trackerRemoved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (cattleId != null) 'cattle_id': cattleId,
      if (measuredWeight != null) 'measured_weight': measuredWeight,
      if (price != null) 'price': price,
      if (isApproved != null) 'is_approved': isApproved,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (trackerRemoved != null) 'tracker_removed': trackerRemoved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleDetailLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? cattleId,
    Value<double>? measuredWeight,
    Value<double>? price,
    Value<bool>? isApproved,
    Value<String?>? rejectionReason,
    Value<bool>? trackerRemoved,
    Value<int>? rowid,
  }) {
    return SaleDetailLocalCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      cattleId: cattleId ?? this.cattleId,
      measuredWeight: measuredWeight ?? this.measuredWeight,
      price: price ?? this.price,
      isApproved: isApproved ?? this.isApproved,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      trackerRemoved: trackerRemoved ?? this.trackerRemoved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (cattleId.present) {
      map['cattle_id'] = Variable<String>(cattleId.value);
    }
    if (measuredWeight.present) {
      map['measured_weight'] = Variable<double>(measuredWeight.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isApproved.present) {
      map['is_approved'] = Variable<bool>(isApproved.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (trackerRemoved.present) {
      map['tracker_removed'] = Variable<bool>(trackerRemoved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleDetailLocalCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('cattleId: $cattleId, ')
          ..write('measuredWeight: $measuredWeight, ')
          ..write('price: $price, ')
          ..write('isApproved: $isApproved, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('trackerRemoved: $trackerRemoved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MassiveEventLocalTable massiveEventLocal =
      $MassiveEventLocalTable(this);
  late final $SimpleEventLocalTable simpleEventLocal = $SimpleEventLocalTable(
    this,
  );
  late final $AnimalSimpleEventLocalTable animalSimpleEventLocal =
      $AnimalSimpleEventLocalTable(this);
  late final $BrandLocalTable brandLocal = $BrandLocalTable(this);
  late final $CattleLocalTable cattleLocal = $CattleLocalTable(this);
  late final $ProviderLocalTable providerLocal = $ProviderLocalTable(this);
  late final $SaleLocalTable saleLocal = $SaleLocalTable(this);
  late final $SaleDetailLocalTable saleDetailLocal = $SaleDetailLocalTable(
    this,
  );
  late final SimpleEventDao simpleEventDao = SimpleEventDao(
    this as AppDatabase,
  );
  late final MassiveEventDao massiveEventDao = MassiveEventDao(
    this as AppDatabase,
  );
  late final BrandDao brandDao = BrandDao(this as AppDatabase);
  late final AnimalSimpleEventDao animalSimpleEventDao = AnimalSimpleEventDao(
    this as AppDatabase,
  );
  late final CattleDao cattleDao = CattleDao(this as AppDatabase);
  late final ProviderDao providerDao = ProviderDao(this as AppDatabase);
  late final SaleDao saleDao = SaleDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    massiveEventLocal,
    simpleEventLocal,
    animalSimpleEventLocal,
    brandLocal,
    cattleLocal,
    providerLocal,
    saleLocal,
    saleDetailLocal,
  ];
}

typedef $$MassiveEventLocalTableCreateCompanionBuilder =
    MassiveEventLocalCompanion Function({
      required String id,
      Value<String?> serverId,
      required String idTenant,
      required String name,
      required DateTime eventDate,
      Value<String> status,
      Value<String?> createdBy,
      Value<bool> linkedToPurchaseReception,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$MassiveEventLocalTableUpdateCompanionBuilder =
    MassiveEventLocalCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> idTenant,
      Value<String> name,
      Value<DateTime> eventDate,
      Value<String> status,
      Value<String?> createdBy,
      Value<bool> linkedToPurchaseReception,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$MassiveEventLocalTableFilterComposer
    extends Composer<_$AppDatabase, $MassiveEventLocalTable> {
  $$MassiveEventLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get linkedToPurchaseReception => $composableBuilder(
    column: $table.linkedToPurchaseReception,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MassiveEventLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $MassiveEventLocalTable> {
  $$MassiveEventLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get linkedToPurchaseReception => $composableBuilder(
    column: $table.linkedToPurchaseReception,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MassiveEventLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $MassiveEventLocalTable> {
  $$MassiveEventLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get linkedToPurchaseReception => $composableBuilder(
    column: $table.linkedToPurchaseReception,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MassiveEventLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MassiveEventLocalTable,
          MassiveEvent,
          $$MassiveEventLocalTableFilterComposer,
          $$MassiveEventLocalTableOrderingComposer,
          $$MassiveEventLocalTableAnnotationComposer,
          $$MassiveEventLocalTableCreateCompanionBuilder,
          $$MassiveEventLocalTableUpdateCompanionBuilder,
          (
            MassiveEvent,
            BaseReferences<
              _$AppDatabase,
              $MassiveEventLocalTable,
              MassiveEvent
            >,
          ),
          MassiveEvent,
          PrefetchHooks Function()
        > {
  $$MassiveEventLocalTableTableManager(
    _$AppDatabase db,
    $MassiveEventLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MassiveEventLocalTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$MassiveEventLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$MassiveEventLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> eventDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<bool> linkedToPurchaseReception = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MassiveEventLocalCompanion(
                id: id,
                serverId: serverId,
                idTenant: idTenant,
                name: name,
                eventDate: eventDate,
                status: status,
                createdBy: createdBy,
                linkedToPurchaseReception: linkedToPurchaseReception,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String idTenant,
                required String name,
                required DateTime eventDate,
                Value<String> status = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<bool> linkedToPurchaseReception = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MassiveEventLocalCompanion.insert(
                id: id,
                serverId: serverId,
                idTenant: idTenant,
                name: name,
                eventDate: eventDate,
                status: status,
                createdBy: createdBy,
                linkedToPurchaseReception: linkedToPurchaseReception,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MassiveEventLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MassiveEventLocalTable,
      MassiveEvent,
      $$MassiveEventLocalTableFilterComposer,
      $$MassiveEventLocalTableOrderingComposer,
      $$MassiveEventLocalTableAnnotationComposer,
      $$MassiveEventLocalTableCreateCompanionBuilder,
      $$MassiveEventLocalTableUpdateCompanionBuilder,
      (
        MassiveEvent,
        BaseReferences<_$AppDatabase, $MassiveEventLocalTable, MassiveEvent>,
      ),
      MassiveEvent,
      PrefetchHooks Function()
    >;
typedef $$SimpleEventLocalTableCreateCompanionBuilder =
    SimpleEventLocalCompanion Function({
      required String id,
      Value<String?> serverId,
      required String idTenant,
      required String idMassiveEvent,
      required String type,
      Value<String?> data,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$SimpleEventLocalTableUpdateCompanionBuilder =
    SimpleEventLocalCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> idTenant,
      Value<String> idMassiveEvent,
      Value<String> type,
      Value<String?> data,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$SimpleEventLocalTableFilterComposer
    extends Composer<_$AppDatabase, $SimpleEventLocalTable> {
  $$SimpleEventLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SimpleEventLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $SimpleEventLocalTable> {
  $$SimpleEventLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SimpleEventLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $SimpleEventLocalTable> {
  $$SimpleEventLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SimpleEventLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SimpleEventLocalTable,
          SimpleEvent,
          $$SimpleEventLocalTableFilterComposer,
          $$SimpleEventLocalTableOrderingComposer,
          $$SimpleEventLocalTableAnnotationComposer,
          $$SimpleEventLocalTableCreateCompanionBuilder,
          $$SimpleEventLocalTableUpdateCompanionBuilder,
          (
            SimpleEvent,
            BaseReferences<_$AppDatabase, $SimpleEventLocalTable, SimpleEvent>,
          ),
          SimpleEvent,
          PrefetchHooks Function()
        > {
  $$SimpleEventLocalTableTableManager(
    _$AppDatabase db,
    $SimpleEventLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SimpleEventLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SimpleEventLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SimpleEventLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> idMassiveEvent = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SimpleEventLocalCompanion(
                id: id,
                serverId: serverId,
                idTenant: idTenant,
                idMassiveEvent: idMassiveEvent,
                type: type,
                data: data,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String idTenant,
                required String idMassiveEvent,
                required String type,
                Value<String?> data = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SimpleEventLocalCompanion.insert(
                id: id,
                serverId: serverId,
                idTenant: idTenant,
                idMassiveEvent: idMassiveEvent,
                type: type,
                data: data,
                isActive: isActive,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SimpleEventLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SimpleEventLocalTable,
      SimpleEvent,
      $$SimpleEventLocalTableFilterComposer,
      $$SimpleEventLocalTableOrderingComposer,
      $$SimpleEventLocalTableAnnotationComposer,
      $$SimpleEventLocalTableCreateCompanionBuilder,
      $$SimpleEventLocalTableUpdateCompanionBuilder,
      (
        SimpleEvent,
        BaseReferences<_$AppDatabase, $SimpleEventLocalTable, SimpleEvent>,
      ),
      SimpleEvent,
      PrefetchHooks Function()
    >;
typedef $$AnimalSimpleEventLocalTableCreateCompanionBuilder =
    AnimalSimpleEventLocalCompanion Function({
      required String id,
      required String idTenant,
      required String animalNumber,
      required String type,
      Value<String?> data,
      Value<String?> idMassiveEvent,
      Value<String?> idSimpleEvent,
      required DateTime appliedAt,
      Value<String?> appliedBy,
      Value<String?> recordedInMassiveEvent,
      Value<bool> isSynced,
      Value<bool> isInvalid,
      Value<int> rowid,
    });
typedef $$AnimalSimpleEventLocalTableUpdateCompanionBuilder =
    AnimalSimpleEventLocalCompanion Function({
      Value<String> id,
      Value<String> idTenant,
      Value<String> animalNumber,
      Value<String> type,
      Value<String?> data,
      Value<String?> idMassiveEvent,
      Value<String?> idSimpleEvent,
      Value<DateTime> appliedAt,
      Value<String?> appliedBy,
      Value<String?> recordedInMassiveEvent,
      Value<bool> isSynced,
      Value<bool> isInvalid,
      Value<int> rowid,
    });

class $$AnimalSimpleEventLocalTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalSimpleEventLocalTable> {
  $$AnimalSimpleEventLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalNumber => $composableBuilder(
    column: $table.animalNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idSimpleEvent => $composableBuilder(
    column: $table.idSimpleEvent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliedBy => $composableBuilder(
    column: $table.appliedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedInMassiveEvent => $composableBuilder(
    column: $table.recordedInMassiveEvent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInvalid => $composableBuilder(
    column: $table.isInvalid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnimalSimpleEventLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalSimpleEventLocalTable> {
  $$AnimalSimpleEventLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalNumber => $composableBuilder(
    column: $table.animalNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idSimpleEvent => $composableBuilder(
    column: $table.idSimpleEvent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliedBy => $composableBuilder(
    column: $table.appliedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedInMassiveEvent => $composableBuilder(
    column: $table.recordedInMassiveEvent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInvalid => $composableBuilder(
    column: $table.isInvalid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimalSimpleEventLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalSimpleEventLocalTable> {
  $$AnimalSimpleEventLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get animalNumber => $composableBuilder(
    column: $table.animalNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get idMassiveEvent => $composableBuilder(
    column: $table.idMassiveEvent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idSimpleEvent => $composableBuilder(
    column: $table.idSimpleEvent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<String> get appliedBy =>
      $composableBuilder(column: $table.appliedBy, builder: (column) => column);

  GeneratedColumn<String> get recordedInMassiveEvent => $composableBuilder(
    column: $table.recordedInMassiveEvent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isInvalid =>
      $composableBuilder(column: $table.isInvalid, builder: (column) => column);
}

class $$AnimalSimpleEventLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimalSimpleEventLocalTable,
          AnimalSimpleEvent,
          $$AnimalSimpleEventLocalTableFilterComposer,
          $$AnimalSimpleEventLocalTableOrderingComposer,
          $$AnimalSimpleEventLocalTableAnnotationComposer,
          $$AnimalSimpleEventLocalTableCreateCompanionBuilder,
          $$AnimalSimpleEventLocalTableUpdateCompanionBuilder,
          (
            AnimalSimpleEvent,
            BaseReferences<
              _$AppDatabase,
              $AnimalSimpleEventLocalTable,
              AnimalSimpleEvent
            >,
          ),
          AnimalSimpleEvent,
          PrefetchHooks Function()
        > {
  $$AnimalSimpleEventLocalTableTableManager(
    _$AppDatabase db,
    $AnimalSimpleEventLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AnimalSimpleEventLocalTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$AnimalSimpleEventLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$AnimalSimpleEventLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> animalNumber = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<String?> idMassiveEvent = const Value.absent(),
                Value<String?> idSimpleEvent = const Value.absent(),
                Value<DateTime> appliedAt = const Value.absent(),
                Value<String?> appliedBy = const Value.absent(),
                Value<String?> recordedInMassiveEvent = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isInvalid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalSimpleEventLocalCompanion(
                id: id,
                idTenant: idTenant,
                animalNumber: animalNumber,
                type: type,
                data: data,
                idMassiveEvent: idMassiveEvent,
                idSimpleEvent: idSimpleEvent,
                appliedAt: appliedAt,
                appliedBy: appliedBy,
                recordedInMassiveEvent: recordedInMassiveEvent,
                isSynced: isSynced,
                isInvalid: isInvalid,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idTenant,
                required String animalNumber,
                required String type,
                Value<String?> data = const Value.absent(),
                Value<String?> idMassiveEvent = const Value.absent(),
                Value<String?> idSimpleEvent = const Value.absent(),
                required DateTime appliedAt,
                Value<String?> appliedBy = const Value.absent(),
                Value<String?> recordedInMassiveEvent = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isInvalid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalSimpleEventLocalCompanion.insert(
                id: id,
                idTenant: idTenant,
                animalNumber: animalNumber,
                type: type,
                data: data,
                idMassiveEvent: idMassiveEvent,
                idSimpleEvent: idSimpleEvent,
                appliedAt: appliedAt,
                appliedBy: appliedBy,
                recordedInMassiveEvent: recordedInMassiveEvent,
                isSynced: isSynced,
                isInvalid: isInvalid,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnimalSimpleEventLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimalSimpleEventLocalTable,
      AnimalSimpleEvent,
      $$AnimalSimpleEventLocalTableFilterComposer,
      $$AnimalSimpleEventLocalTableOrderingComposer,
      $$AnimalSimpleEventLocalTableAnnotationComposer,
      $$AnimalSimpleEventLocalTableCreateCompanionBuilder,
      $$AnimalSimpleEventLocalTableUpdateCompanionBuilder,
      (
        AnimalSimpleEvent,
        BaseReferences<
          _$AppDatabase,
          $AnimalSimpleEventLocalTable,
          AnimalSimpleEvent
        >,
      ),
      AnimalSimpleEvent,
      PrefetchHooks Function()
    >;
typedef $$BrandLocalTableCreateCompanionBuilder =
    BrandLocalCompanion Function({
      required String id,
      required String idTenant,
      required String name,
      required Uint8List imageBytes,
      required String imageMimeType,
      required String imageFileName,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$BrandLocalTableUpdateCompanionBuilder =
    BrandLocalCompanion Function({
      Value<String> id,
      Value<String> idTenant,
      Value<String> name,
      Value<Uint8List> imageBytes,
      Value<String> imageMimeType,
      Value<String> imageFileName,
      Value<bool> isSynced,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$BrandLocalTableFilterComposer
    extends Composer<_$AppDatabase, $BrandLocalTable> {
  $$BrandLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandLocalTable> {
  $$BrandLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandLocalTable> {
  $$BrandLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BrandLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandLocalTable,
          Brand,
          $$BrandLocalTableFilterComposer,
          $$BrandLocalTableOrderingComposer,
          $$BrandLocalTableAnnotationComposer,
          $$BrandLocalTableCreateCompanionBuilder,
          $$BrandLocalTableUpdateCompanionBuilder,
          (Brand, BaseReferences<_$AppDatabase, $BrandLocalTable, Brand>),
          Brand,
          PrefetchHooks Function()
        > {
  $$BrandLocalTableTableManager(_$AppDatabase db, $BrandLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BrandLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BrandLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BrandLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Uint8List> imageBytes = const Value.absent(),
                Value<String> imageMimeType = const Value.absent(),
                Value<String> imageFileName = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandLocalCompanion(
                id: id,
                idTenant: idTenant,
                name: name,
                imageBytes: imageBytes,
                imageMimeType: imageMimeType,
                imageFileName: imageFileName,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idTenant,
                required String name,
                required Uint8List imageBytes,
                required String imageMimeType,
                required String imageFileName,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandLocalCompanion.insert(
                id: id,
                idTenant: idTenant,
                name: name,
                imageBytes: imageBytes,
                imageMimeType: imageMimeType,
                imageFileName: imageFileName,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandLocalTable,
      Brand,
      $$BrandLocalTableFilterComposer,
      $$BrandLocalTableOrderingComposer,
      $$BrandLocalTableAnnotationComposer,
      $$BrandLocalTableCreateCompanionBuilder,
      $$BrandLocalTableUpdateCompanionBuilder,
      (Brand, BaseReferences<_$AppDatabase, $BrandLocalTable, Brand>),
      Brand,
      PrefetchHooks Function()
    >;
typedef $$CattleLocalTableCreateCompanionBuilder =
    CattleLocalCompanion Function({
      required String id,
      required String idTenant,
      required String number,
      Value<double?> weight,
      Value<String> status,
      Value<String?> idDevice,
      Value<int> rowid,
    });
typedef $$CattleLocalTableUpdateCompanionBuilder =
    CattleLocalCompanion Function({
      Value<String> id,
      Value<String> idTenant,
      Value<String> number,
      Value<double?> weight,
      Value<String> status,
      Value<String?> idDevice,
      Value<int> rowid,
    });

class $$CattleLocalTableFilterComposer
    extends Composer<_$AppDatabase, $CattleLocalTable> {
  $$CattleLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idDevice => $composableBuilder(
    column: $table.idDevice,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CattleLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $CattleLocalTable> {
  $$CattleLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idDevice => $composableBuilder(
    column: $table.idDevice,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CattleLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $CattleLocalTable> {
  $$CattleLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get idDevice =>
      $composableBuilder(column: $table.idDevice, builder: (column) => column);
}

class $$CattleLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CattleLocalTable,
          CattleLocalData,
          $$CattleLocalTableFilterComposer,
          $$CattleLocalTableOrderingComposer,
          $$CattleLocalTableAnnotationComposer,
          $$CattleLocalTableCreateCompanionBuilder,
          $$CattleLocalTableUpdateCompanionBuilder,
          (
            CattleLocalData,
            BaseReferences<_$AppDatabase, $CattleLocalTable, CattleLocalData>,
          ),
          CattleLocalData,
          PrefetchHooks Function()
        > {
  $$CattleLocalTableTableManager(_$AppDatabase db, $CattleLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CattleLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CattleLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$CattleLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> idDevice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CattleLocalCompanion(
                id: id,
                idTenant: idTenant,
                number: number,
                weight: weight,
                status: status,
                idDevice: idDevice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idTenant,
                required String number,
                Value<double?> weight = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> idDevice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CattleLocalCompanion.insert(
                id: id,
                idTenant: idTenant,
                number: number,
                weight: weight,
                status: status,
                idDevice: idDevice,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CattleLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CattleLocalTable,
      CattleLocalData,
      $$CattleLocalTableFilterComposer,
      $$CattleLocalTableOrderingComposer,
      $$CattleLocalTableAnnotationComposer,
      $$CattleLocalTableCreateCompanionBuilder,
      $$CattleLocalTableUpdateCompanionBuilder,
      (
        CattleLocalData,
        BaseReferences<_$AppDatabase, $CattleLocalTable, CattleLocalData>,
      ),
      CattleLocalData,
      PrefetchHooks Function()
    >;
typedef $$ProviderLocalTableCreateCompanionBuilder =
    ProviderLocalCompanion Function({
      required String id,
      required String idTenant,
      required String name,
      required String nit,
      required String type,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<int> rowid,
    });
typedef $$ProviderLocalTableUpdateCompanionBuilder =
    ProviderLocalCompanion Function({
      Value<String> id,
      Value<String> idTenant,
      Value<String> name,
      Value<String> nit,
      Value<String> type,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<int> rowid,
    });

class $$ProviderLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderLocalTable> {
  $$ProviderLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProviderLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderLocalTable> {
  $$ProviderLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProviderLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderLocalTable> {
  $$ProviderLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nit =>
      $composableBuilder(column: $table.nit, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);
}

class $$ProviderLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProviderLocalTable,
          ProviderLocalData,
          $$ProviderLocalTableFilterComposer,
          $$ProviderLocalTableOrderingComposer,
          $$ProviderLocalTableAnnotationComposer,
          $$ProviderLocalTableCreateCompanionBuilder,
          $$ProviderLocalTableUpdateCompanionBuilder,
          (
            ProviderLocalData,
            BaseReferences<
              _$AppDatabase,
              $ProviderLocalTable,
              ProviderLocalData
            >,
          ),
          ProviderLocalData,
          PrefetchHooks Function()
        > {
  $$ProviderLocalTableTableManager(_$AppDatabase db, $ProviderLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProviderLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ProviderLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProviderLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nit = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderLocalCompanion(
                id: id,
                idTenant: idTenant,
                name: name,
                nit: nit,
                type: type,
                address: address,
                phone: phone,
                email: email,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idTenant,
                required String name,
                required String nit,
                required String type,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderLocalCompanion.insert(
                id: id,
                idTenant: idTenant,
                name: name,
                nit: nit,
                type: type,
                address: address,
                phone: phone,
                email: email,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProviderLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProviderLocalTable,
      ProviderLocalData,
      $$ProviderLocalTableFilterComposer,
      $$ProviderLocalTableOrderingComposer,
      $$ProviderLocalTableAnnotationComposer,
      $$ProviderLocalTableCreateCompanionBuilder,
      $$ProviderLocalTableUpdateCompanionBuilder,
      (
        ProviderLocalData,
        BaseReferences<_$AppDatabase, $ProviderLocalTable, ProviderLocalData>,
      ),
      ProviderLocalData,
      PrefetchHooks Function()
    >;
typedef $$SaleLocalTableCreateCompanionBuilder =
    SaleLocalCompanion Function({
      required String id,
      required String idTenant,
      required DateTime transactionDate,
      required String buyerId,
      Value<String?> transporterId,
      Value<double> minWeightConfig,
      Value<double> valuePerKgConfig,
      required double totalAmount,
      required double totalWeight,
      required int totalCount,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$SaleLocalTableUpdateCompanionBuilder =
    SaleLocalCompanion Function({
      Value<String> id,
      Value<String> idTenant,
      Value<DateTime> transactionDate,
      Value<String> buyerId,
      Value<String?> transporterId,
      Value<double> minWeightConfig,
      Value<double> valuePerKgConfig,
      Value<double> totalAmount,
      Value<double> totalWeight,
      Value<int> totalCount,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$SaleLocalTableReferences
    extends BaseReferences<_$AppDatabase, $SaleLocalTable, SaleLocalData> {
  $$SaleLocalTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleDetailLocalTable, List<SaleDetailLocalData>>
  _saleDetailLocalRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleDetailLocal,
    aliasName: $_aliasNameGenerator(db.saleLocal.id, db.saleDetailLocal.saleId),
  );

  $$SaleDetailLocalTableProcessedTableManager get saleDetailLocalRefs {
    final manager = $$SaleDetailLocalTableTableManager(
      $_db,
      $_db.saleDetailLocal,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _saleDetailLocalRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SaleLocalTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLocalTable> {
  $$SaleLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buyerId => $composableBuilder(
    column: $table.buyerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transporterId => $composableBuilder(
    column: $table.transporterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minWeightConfig => $composableBuilder(
    column: $table.minWeightConfig,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valuePerKgConfig => $composableBuilder(
    column: $table.valuePerKgConfig,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> saleDetailLocalRefs(
    Expression<bool> Function($$SaleDetailLocalTableFilterComposer f) f,
  ) {
    final $$SaleDetailLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleDetailLocal,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleDetailLocalTableFilterComposer(
            $db: $db,
            $table: $db.saleDetailLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SaleLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLocalTable> {
  $$SaleLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idTenant => $composableBuilder(
    column: $table.idTenant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buyerId => $composableBuilder(
    column: $table.buyerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transporterId => $composableBuilder(
    column: $table.transporterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minWeightConfig => $composableBuilder(
    column: $table.minWeightConfig,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valuePerKgConfig => $composableBuilder(
    column: $table.valuePerKgConfig,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLocalTable> {
  $$SaleLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idTenant =>
      $composableBuilder(column: $table.idTenant, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buyerId =>
      $composableBuilder(column: $table.buyerId, builder: (column) => column);

  GeneratedColumn<String> get transporterId => $composableBuilder(
    column: $table.transporterId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minWeightConfig => $composableBuilder(
    column: $table.minWeightConfig,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valuePerKgConfig => $composableBuilder(
    column: $table.valuePerKgConfig,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> saleDetailLocalRefs<T extends Object>(
    Expression<T> Function($$SaleDetailLocalTableAnnotationComposer a) f,
  ) {
    final $$SaleDetailLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleDetailLocal,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleDetailLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.saleDetailLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SaleLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLocalTable,
          SaleLocalData,
          $$SaleLocalTableFilterComposer,
          $$SaleLocalTableOrderingComposer,
          $$SaleLocalTableAnnotationComposer,
          $$SaleLocalTableCreateCompanionBuilder,
          $$SaleLocalTableUpdateCompanionBuilder,
          (SaleLocalData, $$SaleLocalTableReferences),
          SaleLocalData,
          PrefetchHooks Function({bool saleDetailLocalRefs})
        > {
  $$SaleLocalTableTableManager(_$AppDatabase db, $SaleLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SaleLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SaleLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SaleLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idTenant = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String> buyerId = const Value.absent(),
                Value<String?> transporterId = const Value.absent(),
                Value<double> minWeightConfig = const Value.absent(),
                Value<double> valuePerKgConfig = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> totalWeight = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleLocalCompanion(
                id: id,
                idTenant: idTenant,
                transactionDate: transactionDate,
                buyerId: buyerId,
                transporterId: transporterId,
                minWeightConfig: minWeightConfig,
                valuePerKgConfig: valuePerKgConfig,
                totalAmount: totalAmount,
                totalWeight: totalWeight,
                totalCount: totalCount,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idTenant,
                required DateTime transactionDate,
                required String buyerId,
                Value<String?> transporterId = const Value.absent(),
                Value<double> minWeightConfig = const Value.absent(),
                Value<double> valuePerKgConfig = const Value.absent(),
                required double totalAmount,
                required double totalWeight,
                required int totalCount,
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleLocalCompanion.insert(
                id: id,
                idTenant: idTenant,
                transactionDate: transactionDate,
                buyerId: buyerId,
                transporterId: transporterId,
                minWeightConfig: minWeightConfig,
                valuePerKgConfig: valuePerKgConfig,
                totalAmount: totalAmount,
                totalWeight: totalWeight,
                totalCount: totalCount,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SaleLocalTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({saleDetailLocalRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (saleDetailLocalRefs) db.saleDetailLocal,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleDetailLocalRefs)
                    await $_getPrefetchedData<
                      SaleLocalData,
                      $SaleLocalTable,
                      SaleDetailLocalData
                    >(
                      currentTable: table,
                      referencedTable: $$SaleLocalTableReferences
                          ._saleDetailLocalRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SaleLocalTableReferences(
                                db,
                                table,
                                p0,
                              ).saleDetailLocalRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.saleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SaleLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLocalTable,
      SaleLocalData,
      $$SaleLocalTableFilterComposer,
      $$SaleLocalTableOrderingComposer,
      $$SaleLocalTableAnnotationComposer,
      $$SaleLocalTableCreateCompanionBuilder,
      $$SaleLocalTableUpdateCompanionBuilder,
      (SaleLocalData, $$SaleLocalTableReferences),
      SaleLocalData,
      PrefetchHooks Function({bool saleDetailLocalRefs})
    >;
typedef $$SaleDetailLocalTableCreateCompanionBuilder =
    SaleDetailLocalCompanion Function({
      required String id,
      required String saleId,
      required String cattleId,
      required double measuredWeight,
      required double price,
      required bool isApproved,
      Value<String?> rejectionReason,
      Value<bool> trackerRemoved,
      Value<int> rowid,
    });
typedef $$SaleDetailLocalTableUpdateCompanionBuilder =
    SaleDetailLocalCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> cattleId,
      Value<double> measuredWeight,
      Value<double> price,
      Value<bool> isApproved,
      Value<String?> rejectionReason,
      Value<bool> trackerRemoved,
      Value<int> rowid,
    });

final class $$SaleDetailLocalTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SaleDetailLocalTable,
          SaleDetailLocalData
        > {
  $$SaleDetailLocalTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SaleLocalTable _saleIdTable(_$AppDatabase db) =>
      db.saleLocal.createAlias(
        $_aliasNameGenerator(db.saleDetailLocal.saleId, db.saleLocal.id),
      );

  $$SaleLocalTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SaleLocalTableTableManager(
      $_db,
      $_db.saleLocal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleDetailLocalTableFilterComposer
    extends Composer<_$AppDatabase, $SaleDetailLocalTable> {
  $$SaleDetailLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cattleId => $composableBuilder(
    column: $table.cattleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get measuredWeight => $composableBuilder(
    column: $table.measuredWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trackerRemoved => $composableBuilder(
    column: $table.trackerRemoved,
    builder: (column) => ColumnFilters(column),
  );

  $$SaleLocalTableFilterComposer get saleId {
    final $$SaleLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.saleLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLocalTableFilterComposer(
            $db: $db,
            $table: $db.saleLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleDetailLocalTable> {
  $$SaleDetailLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cattleId => $composableBuilder(
    column: $table.cattleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get measuredWeight => $composableBuilder(
    column: $table.measuredWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trackerRemoved => $composableBuilder(
    column: $table.trackerRemoved,
    builder: (column) => ColumnOrderings(column),
  );

  $$SaleLocalTableOrderingComposer get saleId {
    final $$SaleLocalTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.saleLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLocalTableOrderingComposer(
            $db: $db,
            $table: $db.saleLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleDetailLocalTable> {
  $$SaleDetailLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cattleId =>
      $composableBuilder(column: $table.cattleId, builder: (column) => column);

  GeneratedColumn<double> get measuredWeight => $composableBuilder(
    column: $table.measuredWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isApproved => $composableBuilder(
    column: $table.isApproved,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
    column: $table.rejectionReason,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get trackerRemoved => $composableBuilder(
    column: $table.trackerRemoved,
    builder: (column) => column,
  );

  $$SaleLocalTableAnnotationComposer get saleId {
    final $$SaleLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.saleLocal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleDetailLocalTable,
          SaleDetailLocalData,
          $$SaleDetailLocalTableFilterComposer,
          $$SaleDetailLocalTableOrderingComposer,
          $$SaleDetailLocalTableAnnotationComposer,
          $$SaleDetailLocalTableCreateCompanionBuilder,
          $$SaleDetailLocalTableUpdateCompanionBuilder,
          (SaleDetailLocalData, $$SaleDetailLocalTableReferences),
          SaleDetailLocalData,
          PrefetchHooks Function({bool saleId})
        > {
  $$SaleDetailLocalTableTableManager(
    _$AppDatabase db,
    $SaleDetailLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SaleDetailLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SaleDetailLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SaleDetailLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> cattleId = const Value.absent(),
                Value<double> measuredWeight = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<bool> isApproved = const Value.absent(),
                Value<String?> rejectionReason = const Value.absent(),
                Value<bool> trackerRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleDetailLocalCompanion(
                id: id,
                saleId: saleId,
                cattleId: cattleId,
                measuredWeight: measuredWeight,
                price: price,
                isApproved: isApproved,
                rejectionReason: rejectionReason,
                trackerRemoved: trackerRemoved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String cattleId,
                required double measuredWeight,
                required double price,
                required bool isApproved,
                Value<String?> rejectionReason = const Value.absent(),
                Value<bool> trackerRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleDetailLocalCompanion.insert(
                id: id,
                saleId: saleId,
                cattleId: cattleId,
                measuredWeight: measuredWeight,
                price: price,
                isApproved: isApproved,
                rejectionReason: rejectionReason,
                trackerRemoved: trackerRemoved,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SaleDetailLocalTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({saleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (saleId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.saleId,
                            referencedTable: $$SaleDetailLocalTableReferences
                                ._saleIdTable(db),
                            referencedColumn:
                                $$SaleDetailLocalTableReferences
                                    ._saleIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SaleDetailLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleDetailLocalTable,
      SaleDetailLocalData,
      $$SaleDetailLocalTableFilterComposer,
      $$SaleDetailLocalTableOrderingComposer,
      $$SaleDetailLocalTableAnnotationComposer,
      $$SaleDetailLocalTableCreateCompanionBuilder,
      $$SaleDetailLocalTableUpdateCompanionBuilder,
      (SaleDetailLocalData, $$SaleDetailLocalTableReferences),
      SaleDetailLocalData,
      PrefetchHooks Function({bool saleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MassiveEventLocalTableTableManager get massiveEventLocal =>
      $$MassiveEventLocalTableTableManager(_db, _db.massiveEventLocal);
  $$SimpleEventLocalTableTableManager get simpleEventLocal =>
      $$SimpleEventLocalTableTableManager(_db, _db.simpleEventLocal);
  $$AnimalSimpleEventLocalTableTableManager get animalSimpleEventLocal =>
      $$AnimalSimpleEventLocalTableTableManager(
        _db,
        _db.animalSimpleEventLocal,
      );
  $$BrandLocalTableTableManager get brandLocal =>
      $$BrandLocalTableTableManager(_db, _db.brandLocal);
  $$CattleLocalTableTableManager get cattleLocal =>
      $$CattleLocalTableTableManager(_db, _db.cattleLocal);
  $$ProviderLocalTableTableManager get providerLocal =>
      $$ProviderLocalTableTableManager(_db, _db.providerLocal);
  $$SaleLocalTableTableManager get saleLocal =>
      $$SaleLocalTableTableManager(_db, _db.saleLocal);
  $$SaleDetailLocalTableTableManager get saleDetailLocal =>
      $$SaleDetailLocalTableTableManager(_db, _db.saleDetailLocal);
}

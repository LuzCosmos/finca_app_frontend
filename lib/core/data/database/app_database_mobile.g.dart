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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
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
  final String? name;
  final DateTime eventDate;
  final String status;
  final String? createdBy;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const MassiveEvent({
    required this.id,
    this.serverId,
    required this.idTenant,
    this.name,
    required this.eventDate,
    required this.status,
    this.createdBy,
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
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['event_date'] = Variable<DateTime>(eventDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
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
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      eventDate: Value(eventDate),
      status: Value(status),
      createdBy:
          createdBy == null && nullToAbsent
              ? const Value.absent()
              : Value(createdBy),
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
      name: serializer.fromJson<String?>(json['name']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
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
      'name': serializer.toJson<String?>(name),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String?>(createdBy),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  MassiveEvent copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? idTenant,
    Value<String?> name = const Value.absent(),
    DateTime? eventDate,
    String? status,
    Value<String?> createdBy = const Value.absent(),
    bool? isSynced,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => MassiveEvent(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    idTenant: idTenant ?? this.idTenant,
    name: name.present ? name.value : this.name,
    eventDate: eventDate ?? this.eventDate,
    status: status ?? this.status,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
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
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MassiveEventLocalCompanion extends UpdateCompanion<MassiveEvent> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> idTenant;
  final Value<String?> name;
  final Value<DateTime> eventDate;
  final Value<String> status;
  final Value<String?> createdBy;
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
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MassiveEventLocalCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String idTenant,
    this.name = const Value.absent(),
    required DateTime eventDate,
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idTenant = Value(idTenant),
       eventDate = Value(eventDate);
  static Insertable<MassiveEvent> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? idTenant,
    Expression<String>? name,
    Expression<DateTime>? eventDate,
    Expression<String>? status,
    Expression<String>? createdBy,
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
    Value<String?>? name,
    Value<DateTime>? eventDate,
    Value<String>? status,
    Value<String?>? createdBy,
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
  final bool isSynced;
  final DateTime? createdAt;
  const SimpleEvent({
    required this.id,
    this.serverId,
    required this.idTenant,
    required this.idMassiveEvent,
    required this.type,
    this.data,
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
    bool? isSynced,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => SimpleEvent(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    idTenant: idTenant ?? this.idTenant,
    idMassiveEvent: idMassiveEvent ?? this.idMassiveEvent,
    type: type ?? this.type,
    data: data.present ? data.value : this.data,
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    massiveEventLocal,
    simpleEventLocal,
    animalSimpleEventLocal,
    brandLocal,
  ];
}

typedef $$MassiveEventLocalTableCreateCompanionBuilder =
    MassiveEventLocalCompanion Function({
      required String id,
      Value<String?> serverId,
      required String idTenant,
      Value<String?> name,
      required DateTime eventDate,
      Value<String> status,
      Value<String?> createdBy,
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
      Value<String?> name,
      Value<DateTime> eventDate,
      Value<String> status,
      Value<String?> createdBy,
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
                Value<String?> name = const Value.absent(),
                Value<DateTime> eventDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
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
                Value<String?> name = const Value.absent(),
                required DateTime eventDate,
                Value<String> status = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
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
}

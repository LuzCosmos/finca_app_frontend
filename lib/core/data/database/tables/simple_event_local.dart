import 'package:drift/drift.dart';

@DataClassName('SimpleEvent')
class SimpleEventLocal extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get serverId => text().nullable()();
  TextColumn get idTenant => text()();
  TextColumn get idMassiveEvent => text()(); // FK a MassiveEventLocal.id
  TextColumn get type => text()();
  TextColumn get data => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  List<Set<Column<Object>>> get indexes => [
    {idMassiveEvent},
  ];
}

import 'package:drift/drift.dart';

@DataClassName('MassiveEvent')
class MassiveEventLocal extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get serverId => text().nullable()();
  TextColumn get idTenant => text()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  TextColumn get createdBy => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

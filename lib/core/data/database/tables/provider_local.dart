import 'package:drift/drift.dart';

class ProviderLocal extends Table {
  TextColumn get id => text()();
  TextColumn get idTenant => text()();
  TextColumn get name => text()();
  TextColumn get nit => text()();
  TextColumn get type => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

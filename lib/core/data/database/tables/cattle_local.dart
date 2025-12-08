import 'package:drift/drift.dart';

class CattleLocal extends Table {
  TextColumn get id => text()();
  TextColumn get idTenant => text()();
  TextColumn get number => text()();
  RealColumn get weight => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  TextColumn get idDevice => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

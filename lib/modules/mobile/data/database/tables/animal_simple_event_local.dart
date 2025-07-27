import 'package:drift/drift.dart';

@DataClassName('AnimalSimpleEvent')
class AnimalSimpleEventLocal extends Table {
  TextColumn get id => text()(); // UUID primary key
  TextColumn get idTenant => text()();
  TextColumn get animalNumber => text()(); // animal number
  TextColumn get type => text()(); // event type
  TextColumn get dataJson => text().nullable()();
  DateTimeColumn get appliedAt => dateTime()();
  TextColumn get appliedBy => text().nullable()();
  TextColumn get recordedInMassiveEvent => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isInvalid => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

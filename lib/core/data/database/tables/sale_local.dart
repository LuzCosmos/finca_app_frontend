import 'package:drift/drift.dart';

class SaleLocal extends Table {
  TextColumn get id => text()();
  TextColumn get idTenant => text()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get buyerId => text()();
  TextColumn get transporterId => text().nullable()();
  RealColumn get minWeightConfig => real().withDefault(const Constant(0.0))();
  RealColumn get valuePerKgConfig => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real()();
  RealColumn get totalWeight => real()();
  IntColumn get totalCount => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

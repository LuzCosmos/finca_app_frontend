import 'package:drift/drift.dart';
import 'sale_local.dart';

class SaleDetailLocal extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(SaleLocal, #id)();
  TextColumn get cattleId => text()();
  RealColumn get measuredWeight => real()();
  RealColumn get price => real()();
  BoolColumn get isApproved => boolean()();
  TextColumn get rejectionReason => text().nullable()();
  BoolColumn get trackerRemoved => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

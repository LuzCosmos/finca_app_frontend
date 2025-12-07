// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_mobile.dart';

// ignore_for_file: type=lint
abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
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
  List<DatabaseSchemaEntity> get allSchemaEntities => [];
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
}

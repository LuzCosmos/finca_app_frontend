// lib/modules/mobile/data/database/app_database_mobile.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/massive_event_local.dart';
import 'tables/simple_event_local.dart';
import 'tables/brand_local.dart';
import 'tables/animal_simple_event_local.dart';
import 'daos/simple_event_dao.dart';
import 'daos/massive_event_dao.dart';
import 'daos/brand_dao.dart';
import 'daos/animal_simple_event_dao.dart';

part 'app_database_mobile.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'finca_app.db'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    MassiveEventLocal,
    SimpleEventLocal,
    AnimalSimpleEventLocal,
    BrandLocal,
  ],
  daos: [SimpleEventDao, MassiveEventDao, BrandDao, AnimalSimpleEventDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

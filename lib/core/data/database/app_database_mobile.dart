// lib/modules/mobile/data/database/app_database_mobile.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:finca_app_frontend/core/data/database/tables/massive_event_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/simple_event_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/brand_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/animal_simple_event_local.dart';
import 'package:finca_app_frontend/core/data/database/daos/simple_event_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/massive_event_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/brand_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/animal_simple_event_dao.dart';

import 'package:finca_app_frontend/core/data/database/tables/cattle_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/provider_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/sale_local.dart';
import 'package:finca_app_frontend/core/data/database/tables/sale_detail_local.dart';
import 'package:finca_app_frontend/core/data/database/daos/cattle_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/provider_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/sale_dao.dart';

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
    CattleLocal,
    ProviderLocal,
    SaleLocal,
    SaleDetailLocal,
  ],
  daos: [
    SimpleEventDao,
    MassiveEventDao,
    BrandDao,
    AnimalSimpleEventDao,
    CattleDao,
    ProviderDao,
    SaleDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(simpleEventLocal, simpleEventLocal.isActive);
      }
      if (from < 3) {
        await m.addColumn(
          massiveEventLocal,
          massiveEventLocal.linkedToPurchaseReception,
        );
      }
      if (from < 4) {
        await m.database.customStatement(
          "UPDATE massive_event_local SET name = 'MassiveEvent' "
          "WHERE name IS NULL OR trim(name) = ''",
        );
        await m.alterTable(
          TableMigration(
            massiveEventLocal,
            columnTransformer: {
              massiveEventLocal.name: ifNull(
                massiveEventLocal.name,
                const Constant('MassiveEvent'),
              ),
            },
          ),
        );
      }
      if (from < 5) {
        await purgeOfflineSyncTables(m.database);
      }
    },
  );
}

/// Vacía tablas usadas solo para cola/sync offline (HU móvil online-only).
/// No afecta `sale_local` ni otras tablas de otros módulos.
Future<void> purgeOfflineSyncTables(GeneratedDatabase db) async {
  await db.customStatement('DELETE FROM massive_event_local');
  await db.customStatement('DELETE FROM simple_event_local');
  await db.customStatement('DELETE FROM animal_simple_event_local');
  await db.customStatement('DELETE FROM brand_local');
}

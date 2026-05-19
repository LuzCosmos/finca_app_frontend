import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';

// Bajo prueba: purgeOfflineSyncTables en app_database_mobile.dart

void main() {
  test('purgeOfflineSyncTables vacía tablas de sync offline', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.into(db.massiveEventLocal).insert(
      MassiveEventLocalCompanion.insert(
        id: 'local-m1',
        idTenant: 'tenant-1',
        name: 'Test',
        eventDate: DateTime(2026, 1, 1),
      ),
    );

    await purgeOfflineSyncTables(db);

    final rows = await db.massiveEventDao.getAll();
    expect(rows, isEmpty);
  });
}

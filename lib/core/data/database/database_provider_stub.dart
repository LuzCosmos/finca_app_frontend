import 'package:finca_app_frontend/core/data/database/app_database_stub.dart';

/// Singleton provider (stub web): sin SQLite/FFI.
class DatabaseProvider {
  static AppDatabase? _instance;

  static AppDatabase get database {
    _instance ??= AppDatabase();
    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}

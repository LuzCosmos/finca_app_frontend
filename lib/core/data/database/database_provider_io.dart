import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';

/// Singleton provider to access a single instance of the Drift database.
///
/// Implementación **solo FFI** (móvil/escritorio): [AppDatabase] real con DAOs.
/// En web se usa [database_provider_stub.dart].
class DatabaseProvider {
  static AppDatabase? _instance;

  /// Returns the same instance of [AppDatabase].
  static AppDatabase get database {
    _instance ??= AppDatabase();
    return _instance!;
  }

  /// Close the instance when necessary (for example, when logging out).
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}

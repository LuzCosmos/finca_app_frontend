// Singleton [DatabaseProvider]: FFI → Drift real; web → stub.
// Código solo móvil/desktop con DAOs: importar [database_provider_io.dart].
export 'database_provider_stub.dart'
    if (dart.library.ffi) 'database_provider_io.dart';

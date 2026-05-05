import 'package:flutter_bloc/flutter_bloc.dart';

import 'sync_event.dart';
import 'sync_state.dart';

/// Stub para web.
///
/// En Flutter Web no podemos compilar `drift` con driver nativo (`sqlite3`/`dart:ffi`),
/// así que evitamos que el árbol de imports llegue a `SyncService` y a la base de datos.
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc() : super(SyncInitial()) {
    on<StartSync>((event, emit) async {
      emit(const SyncFailure('Sincronización no disponible en web.'));
    });
  }
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'sync_event.dart';
import 'sync_state.dart';
import '../services/sync_service.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;

  SyncBloc(this.syncService) : super(SyncInitial()) {
    on<StartSync>((event, emit) async {
      emit(SyncInProgress());
      try {
        final results = await syncService.syncAllInOrder(event.idTenant);
        // Verifica si alguna falló
        final failed = results.where((r) => !r.success).toList();
        if (failed.isEmpty) {
          emit(SyncSuccess());
        } else {
          final messages = failed.map((f) => f.message).join('\n');
          emit(SyncFailure(messages));
        }
      } catch (e) {
        emit(SyncFailure(e.toString()));
      }
    });
  }
}

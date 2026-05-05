import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

SyncBloc createIntegrationSyncBloc(SyncService syncService) => SyncBloc(syncService);


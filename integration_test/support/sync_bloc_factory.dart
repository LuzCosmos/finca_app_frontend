import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';

import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

import 'sync_bloc_factory_stub.dart'
    if (dart.library.io) 'sync_bloc_factory_io.dart' as impl;

SyncBloc createIntegrationSyncBloc(SyncService syncService) =>
    impl.createIntegrationSyncBloc(syncService);


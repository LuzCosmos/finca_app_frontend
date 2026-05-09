import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/data/database/database_provider_io.dart';
import 'package:finca_app_frontend/core/data/database/repositories/animal_simple_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/massive_event_repository.dart';
import 'package:finca_app_frontend/core/data/database/repositories/simple_event_repository.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';

Widget wrapMobileSyncScope(
  Widget child, {
  SyncBloc? syncBlocOverride,
}) {
  if (syncBlocOverride != null) {
    return BlocProvider<SyncBloc>.value(
      value: syncBlocOverride,
      child: child,
    );
  }
  // Importante: en release, si falla la inicializacion local (Drift/SQLite),
  // evita que toda la app quede en blanco; permitimos que al menos navegue
  // el router (login/home) aunque el sync no funcione.
  try {
    return BlocProvider<SyncBloc>(
      create: (_) {
        final db = DatabaseProvider.database;
        final syncService = SyncService(
          animalSimpleEventRepository: AnimalSimpleEventRepository(db.animalSimpleEventDao),
          brandRepository: BrandRepository(db.brandDao),
          massiveEventRepository: MassiveEventRepository(db.massiveEventDao, db.simpleEventDao),
          simpleEventRepository: SimpleEventRepository(db.simpleEventDao),
          baseUrl: BasicApiService.getApiBaseUrl(),
          getToken: () async => (await SessionService.getToken()) ?? '',
        );
        return SyncBloc(syncService);
      },
      child: child,
    );
  } catch (e, st) {
    // ignore: avoid_print
    debugPrint('wrapMobileSyncScope init error: $e\n$st');
    return child;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockSyncService extends Mock implements SyncService {}

/// [MaterialApp.router] con [LocaleBloc] y [SyncBloc] (este último exige el
/// listener de sync en `MassiveEventPage` en plataforma IO).
Widget buildRouterTestHost(GoRouter router) {
  final syncMock = _MockSyncService();
  when(
    () => syncMock.syncAllInOrder(any()),
  ).thenAnswer((_) async => <SyncResult>[]);

  return MultiBlocProvider(
    providers: [
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
      BlocProvider<SyncBloc>(create: (_) => SyncBloc(syncMock)),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

/// Avanza tiempo de reloj sin [pumpAndSettle]: indicadores de carga indefinidos
/// (p. ej. en Home o listas con API) impiden que el settle termine.
Future<void> pumpRouterFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(seconds: 2));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';

// Bajo prueba:
// - MassiveEventListPage + GoRouter: FAB creación navega a /massive-events/create

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
  });

  testWidgets('embedded list+create: tap + navega a ruta de creación', (
    tester,
  ) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': '10001'},
      },
      idTenant: 'tid',
      idUser: 'u',
    );

    Future<List<MassiveEventModel>> fetch() async => [
      MassiveEventModel(
        id: 'x1',
        eventDate: DateTime(2024, 1, 1),
        simpleEvents: const [],
        name: 'N',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      ),
    ];

    final router = GoRouter(
      initialLocation: '/massive-events',
      routes: [
        GoRoute(
          path: '/massive-events',
          builder:
              (_, _) => MassiveEventListPage(
                embedded: true,
                fetchStandaloneOverride: fetch,
              ),
        ),
        GoRoute(
          path: '/massive-events/create',
          builder:
              (_, _) => const Scaffold(
                body: Text('stub-create-route'),
              ),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LocaleBloc(),
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('stub-create-route'), findsOneWidget);
  });
}

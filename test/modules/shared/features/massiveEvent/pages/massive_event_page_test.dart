import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/services/sync_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/pages/massive_event_page.dart
// - lib/modules/shared/features/massiveEvent/widgets/event_config_panel.dart
// - lib/modules/shared/features/massiveEvent/widgets/event_detail_form.dart
// - lib/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart (provider)
// - lib/modules/shared/features/massiveEvent/pages/massive_event_sync_listener_io.dart (SyncBloc)
// - lib/modules/shared/widgets/finca_scaffold.dart (LocaleBloc, SessionService.isAuthenticated)

class _MockMassiveEventDataSource extends Mock
    implements IMassiveEventPageDataSource {}

class _MockSyncService extends Mock implements SyncService {}

void main() {
  late _MockMassiveEventDataSource dataSource;
  late _MockSyncService syncService;

  setUpAll(() {
    registerFallbackValue(
      MassiveEventModel.create(
        eventDate: DateTime(2020, 1, 1),
        simpleEvents: [
          SimpleEventModel.create(name: 'fb', type: SimpleEventType.weight),
        ],
      ),
    );
    registerFallbackValue(
      SimpleEventModel.create(name: 'fb', type: SimpleEventType.weight),
    );
  });

  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
    dataSource = _MockMassiveEventDataSource();
    syncService = _MockSyncService();
    when(
      () => syncService.syncAllInOrder(any()),
    ).thenAnswer((_) async => <SyncResult>[]);
  });

  testWidgets('MassiveEventPage con BlocProvider: título L10n y panel config', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: Language.spanish.localeValue,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocaleBloc()),
                BlocProvider(
                  create: (_) => MassiveEventBloc(dataSource: dataSource),
                ),
                BlocProvider(create: (_) => SyncBloc(syncService)),
              ],
              child: const MassiveEventPage(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(l10n.massiveEvent), findsWidgets);
    expect(
      find.byKey(const ValueKey<String>('eventConfigPanel_massiveEvent')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('animalEntryForm')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('processedAnimalsTable')), findsOneWidget);

    final bloc = tester.element(find.byType(MassiveEventPage)).read<MassiveEventBloc>();
    expect(bloc.dataSource, same(dataSource));

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'flujo largo: diálogo peso crea masivo; segundo detalle (tipo chapa) vía saveSimpleEvent',
    (tester) async {
      when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);

      when(() => dataSource.saveMassiveEvent(
            massiveEvent: any(named: 'massiveEvent'),
          )).thenAnswer((
        inv,
      ) async {
        final MassiveEventModel m =
            inv.namedArguments[#massiveEvent] as MassiveEventModel;
        final simples =
            m.simpleEvents
                .map(
                  (e) => SimpleEventModel(
                    id: e.id,
                    idTenant: e.idTenant,
                    idMassiveEvent: 'mid-1',
                    type: e.type,
                    data: e.data,
                    createdAt: e.createdAt,
                    isActive: e.isActive,
                  ),
                )
                .toList();
        return MassiveEventModel(
          id: 'mid-1',
          eventDate: m.eventDate,
          simpleEvents: simples,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
        );
      });

      when(() => dataSource.saveSimpleEvent(
            simpleEvent: any(named: 'simpleEvent'),
          )).thenAnswer((
        inv,
      ) async {
        final SimpleEventModel s =
            inv.namedArguments[#simpleEvent] as SimpleEventModel;
        return SaveSimpleEventResult(saved: s);
      });

      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: Language.spanish.localeValue,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => LocaleBloc()),
                  BlocProvider(
                    create: (_) => MassiveEventBloc(dataSource: dataSource),
                  ),
                  BlocProvider(create: (_) => SyncBloc(syncService)),
                ],
                child: const MassiveEventPage(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      Future<void> tapAddEventInPanel() async {
        await tester.tap(find.text(l10n.addSomething(l10n.event)));
        await tester.pumpAndSettle();
      }

      Future<void> confirmDetailDialog() async {
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(ElevatedButton),
          ),
        );
        await tester.pumpAndSettle();
      }

      await tapAddEventInPanel();
      await confirmDetailDialog();

      expect(find.text(l10n.eventTypeWeight), findsWidgets);

      await tapAddEventInPanel();

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.eventTypeTracker).last);
      await tester.pumpAndSettle();

      await confirmDetailDialog();

      expect(find.text(l10n.eventTypeTracker), findsWidgets);

      verify(
        () => dataSource.saveMassiveEvent(
          massiveEvent: any(named: 'massiveEvent'),
        ),
      ).called(1);
      verify(
        () => dataSource.saveSimpleEvent(
          simpleEvent: any(named: 'simpleEvent'),
        ),
      ).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('diálogo agregar evento: cancelar no llama saveMassiveEvent', (
    tester,
  ) async {
    when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);

    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: Language.spanish.localeValue,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocaleBloc()),
                BlocProvider(
                  create: (_) => MassiveEventBloc(dataSource: dataSource),
                ),
                BlocProvider(create: (_) => SyncBloc(syncService)),
              ],
              child: const MassiveEventPage(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.addSomething(l10n.event)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();

    verifyNever(
      () => dataSource.saveMassiveEvent(
        massiveEvent: any(named: 'massiveEvent'),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'diálogo tipo medicación vacío: no llama saveMassiveEvent',
    (tester) async {
      when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);

      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: Language.spanish.localeValue,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => LocaleBloc()),
                  BlocProvider(
                    create: (_) => MassiveEventBloc(dataSource: dataSource),
                  ),
                  BlocProvider(create: (_) => SyncBloc(syncService)),
                ],
                child: const MassiveEventPage(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.addSomething(l10n.event)));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.eventTypeMedication).last);
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(ElevatedButton, l10n.add),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      verifyNever(
        () => dataSource.saveMassiveEvent(
          massiveEvent: any(named: 'massiveEvent'),
        ),
      );
    },
  );

  testWidgets('saveMassiveEvent lanza: banner error genérico', (tester) async {
    when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);
    when(
      () => dataSource.saveMassiveEvent(
        massiveEvent: any(named: 'massiveEvent'),
      ),
    ).thenThrow(Exception('fallo red'));

    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: Language.spanish.localeValue,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocaleBloc()),
                BlocProvider(
                  create: (_) => MassiveEventBloc(dataSource: dataSource),
                ),
                BlocProvider(create: (_) => SyncBloc(syncService)),
              ],
              child: const MassiveEventPage(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.addSomething(l10n.event)));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.error_generic), findsOneWidget);
    verify(
      () => dataSource.saveMassiveEvent(
        massiveEvent: any(named: 'massiveEvent'),
      ),
    ).called(1);
  });

  testWidgets('saveMassiveEvent recibe payload con tipo peso', (tester) async {
    when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);

    MassiveEventModel? seen;
    when(
      () => dataSource.saveMassiveEvent(
        massiveEvent: any(named: 'massiveEvent'),
      ),
    ).thenAnswer((inv) async {
      seen = inv.namedArguments[#massiveEvent] as MassiveEventModel;
      final m = seen!;
      return MassiveEventModel(
        id: 'mid-payload',
        eventDate: m.eventDate,
        simpleEvents: m.simpleEvents,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );
    });

    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: Language.spanish.localeValue,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocaleBloc()),
                BlocProvider(
                  create: (_) => MassiveEventBloc(dataSource: dataSource),
                ),
                BlocProvider(create: (_) => SyncBloc(syncService)),
              ],
              child: const MassiveEventPage(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.addSomething(l10n.event)));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(seen, isNotNull);
    expect(seen!.simpleEvents.length, 1);
    expect(seen!.simpleEvents.first.type, SimpleEventType.weight);
  });

  testWidgets(
    'getAllBrands falla al abrir diálogo: banner error genérico en página',
    (tester) async {
      when(
        () => dataSource.getAllBrands(),
      ).thenThrow(Exception('brands'));

      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: Language.spanish.localeValue,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => LocaleBloc()),
                  BlocProvider(
                    create: (_) => MassiveEventBloc(dataSource: dataSource),
                  ),
                  BlocProvider(create: (_) => SyncBloc(syncService)),
                ],
                child: const MassiveEventPage(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addSomething(l10n.event)));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.text(l10n.error_generic), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}

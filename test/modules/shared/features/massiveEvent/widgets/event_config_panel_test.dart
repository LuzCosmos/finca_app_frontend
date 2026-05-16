import 'dart:convert';

import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/event_config_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/widgets/event_config_panel.dart

class _MockDataSource extends Mock implements IMassiveEventPageDataSource {}

void main() {
  late _MockDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(
      SimpleEventModel(
        id: 'fb',
        type: SimpleEventType.medication,
        data: '{}',
        createdAt: DateTime(2024, 1, 1),
        isActive: true,
      ),
    );
  });

  setUp(() {
    dataSource = _MockDataSource();
    when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);
    when(
      () => dataSource.updateSimpleEvent(
        simpleEvent: any(named: 'simpleEvent'),
        endpoint: any(named: 'endpoint'),
      ),
    ).thenAnswer((_) async {});
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      locale: Language.spanish.localeValue,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocaleBloc()),
            BlocProvider(
              create: (_) => MassiveEventBloc(dataSource: dataSource),
            ),
          ],
          child: child,
        ),
      ),
    );
  }

  testWidgets(
    'botón editar medicación llama updateSimpleEvent en simple-events',
    (tester) async {
      final medication = SimpleEventModel(
        id: 'med-edit-1',
        idMassiveEvent: 'me-1',
        type: SimpleEventType.medication,
        data: jsonEncode({
          'medicationName': 'Ivermectina',
          'dosage': '5ml',
          'route': 'SC',
          'lot': 'L-99',
        }),
        createdAt: DateTime(2024, 1, 1),
        isActive: true,
      );

      late AppLocalizations l10n;

      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 560,
            width: 400,
            child: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context)!;
                return _PanelHarness(initialEvents: [medication]);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byTooltip(l10n.editSomething(l10n.event)),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.editSomething(l10n.event)), findsOneWidget);

      final dialogFields = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(dialogFields.at(1), '10ml');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(l10n.save),
        ),
      );
      await tester.pumpAndSettle();

      final captured = verify(
        () => dataSource.updateSimpleEvent(
          simpleEvent: captureAny(named: 'simpleEvent'),
          endpoint: captureAny(named: 'endpoint'),
        ),
      ).captured;

      expect(captured[1], 'simple-events');

      final updated = captured[0] as SimpleEventModel;
      expect(updated.id, 'med-edit-1');
      final decoded =
          jsonDecode(updated.data!) as Map<String, dynamic>;
      expect(decoded['medicationName'], 'Ivermectina');
      expect(decoded['dosage'], '10ml');
      expect(decoded['route'], 'SC');
      expect(decoded['lot'], 'L-99');
    },
  );
}

class _PanelHarness extends StatefulWidget {
  const _PanelHarness({required this.initialEvents});

  final List<SimpleEventModel> initialEvents;

  @override
  State<_PanelHarness> createState() => _PanelHarnessState();
}

class _PanelHarnessState extends State<_PanelHarness> {
  late List<SimpleEventModel> _events;

  @override
  void initState() {
    super.initState();
    _events = List<SimpleEventModel>.from(widget.initialEvents);
  }

  @override
  Widget build(BuildContext context) {
    return EventConfigPanel(
      key: const ValueKey<String>('eventConfigPanel_massiveEvent'),
      isWide: true,
      eventDate: DateTime(2025, 6, 1),
      eventName: 'Lote prueba',
      idMassiveEvent: 'me-1',
      simpleEvents: _events,
      onMassiveEventCreated: (_) {},
      showError: (_) {},
      showSuccess: (_) {},
      showInfo: (_) {},
      onEventsChanged: (list) => setState(() => _events = list),
      onEventNameChanged: (_) {},
    );
  }
}

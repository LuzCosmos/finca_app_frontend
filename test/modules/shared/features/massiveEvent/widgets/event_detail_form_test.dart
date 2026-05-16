import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'dart:convert';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/event_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/widgets/event_detail_form.dart

class _MockDataSource extends Mock implements IMassiveEventPageDataSource {}

void main() {
  late _MockDataSource dataSource;

  setUp(() {
    dataSource = _MockDataSource();
    when(() => dataSource.getAllBrands()).thenAnswer((_) async => []);
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
    'activeEventTypes vacío: dropdown incluye los 6 SimpleEventType (matriz UI)',
    (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return EventDetailForm(
                activeEventTypes: const [],
                onBrandsLoadError: (_) {},
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final labels = [
        l10n.eventTypeWeight,
        l10n.eventTypeCastration,
        l10n.eventTypeTracker,
        l10n.eventTypeEartag,
        l10n.eventTypeMedication,
        l10n.eventTypeBrand,
      ];

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      for (final label in labels) {
        expect(find.text(label), findsWidgets);
      }
    },
  );

  testWidgets('getAllBrands falla: onBrandsLoadError recibe error genérico', (
    tester,
  ) async {
    when(
      () => dataSource.getAllBrands(),
    ).thenThrow(Exception('red'));

    String? captured;
    late AppLocalizations l10n;

    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return EventDetailForm(
              activeEventTypes: const [],
              onBrandsLoadError: (m) => captured = m,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump();

    expect(captured, l10n.error_generic);
  });

  testWidgets(
    'tipo marca activo en lista: medicación sigue disponible en dropdown',
    (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return EventDetailForm(
                activeEventTypes: const [SimpleEventType.brand],
                onBrandsLoadError: (_) {},
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text(l10n.eventTypeMedication), findsWidgets);
      expect(find.text(l10n.eventTypeBrand), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('modo edición medicación: precarga campos sin selector de tipo', (
    tester,
  ) async {
    final medication = SimpleEventModel(
      id: 'med-uuid-1',
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
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return EventDetailForm(
              activeEventTypes: const [SimpleEventType.medication],
              onBrandsLoadError: (_) {},
              editingEvent: medication,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.editSomething(l10n.event)), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    expect(find.text('Ivermectina'), findsOneWidget);
    expect(find.text('5ml'), findsOneWidget);
    expect(find.text('SC'), findsOneWidget);
    expect(find.text('L-99'), findsOneWidget);
    expect(find.text(l10n.save), findsOneWidget);
  });

  testWidgets('modo edición medicación: pop devuelve data JSON actualizada', (
    tester,
  ) async {
    final medication = SimpleEventModel(
      id: 'med-2',
      type: SimpleEventType.medication,
      data: jsonEncode({
        'medicationName': 'Vacuna A',
        'dosage': '2',
        'route': 'IM',
        'lot': 'B1',
      }),
      createdAt: DateTime(2024, 6, 1),
      isActive: true,
    );

    late AppLocalizations l10n;
    Map<String, dynamic>? result;

    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return Builder(
              builder: (inner) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<Map<String, dynamic>>(
                      context: inner,
                      builder:
                          (_) => EventDetailForm(
                            activeEventTypes: const [],
                            onBrandsLoadError: (_) {},
                            editingEvent: medication,
                          ),
                    );
                  },
                  child: const Text('open'),
                );
              },
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), '3');
    await tester.tap(find.text(l10n.save));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!['type'], SimpleEventType.medication.name);
    final decoded = jsonDecode(result!['data'] as String) as Map<String, dynamic>;
    expect(decoded['medicationName'], 'Vacuna A');
    expect(decoded['dosage'], '3');
    expect(decoded['route'], 'IM');
    expect(decoded['lot'], 'B1');
  });
}

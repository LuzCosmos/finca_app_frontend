import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/processed_animals_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/widgets/processed_animals_table.dart

void main() {
  testWidgets('mapa vacío: muestra noAnimals', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: Language.spanish.localeValue,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const ProcessedAnimalsTable(
              animalEventsAppliedMap: {},
              simpleEventTypes: [],
              isWide: true,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.noAnimals), findsOneWidget);
  });

  testWidgets(
    'con fila y todos los tipos: columnas y celdas visibles (tabular)',
    (tester) async {
      late AppLocalizations l10n;
      final row = AnimalSimpleEventTableRowModel(
        animalNumber: 'E2E-99',
        weight: 420.5,
        tracker: 'TRK',
        earTagLeft: 'L1',
        earTagRight: 'R1',
        castrated: true,
        medicalTreatments: ['MedA'],
        brandNames: ['MarcaX'],
        isSynced: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: Language.spanish.localeValue,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return ProcessedAnimalsTable(
                animalEventsAppliedMap: {'k1': row},
                simpleEventTypes: SimpleEventType.values,
                isWide: true,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('E2E-99'), findsOneWidget);
      expect(find.text('420.5'), findsOneWidget);
      expect(find.text('TRK'), findsOneWidget);
      expect(find.text('L1'), findsOneWidget);
      expect(find.text('R1'), findsOneWidget);
      expect(find.text(l10n.yes), findsOneWidget);
      expect(find.text('MedA'), findsOneWidget);
      expect(find.text('MarcaX'), findsOneWidget);
      expect(find.byIcon(Icons.sync_problem), findsOneWidget);
      expect(find.text(l10n.animal), findsOneWidget);
      expect(find.text(l10n.weightKg), findsOneWidget);
    },
  );
}

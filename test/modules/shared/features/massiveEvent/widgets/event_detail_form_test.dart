import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
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
}

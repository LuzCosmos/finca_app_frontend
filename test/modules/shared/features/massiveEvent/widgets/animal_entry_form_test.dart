import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/animal_entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock implements IMassiveEventPageDataSource {}

void main() {
  late _MockDataSource dataSource;

  setUp(() {
    dataSource = _MockDataSource();
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

  SimpleEventModel weightEvent() => SimpleEventModel(
        id: 'se-1',
        type: SimpleEventType.weight,
        data: '{"weight":100}',
        isActive: true,
        idMassiveEvent: 'me-1',
        createdAt: DateTime(2025, 1, 1),
      );

  testWidgets('acepta número alfanumérico con guion en el campo', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return AnimalEntryForm(
              idMassiveEvent: 'me-1',
              activeEvents: [weightEvent()],
              animalEventsAppliedMap: const {},
              onApply: (_) {},
              showError: (_) {},
              showSuccess: (_) {},
              showInfo: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'N-100');
    await tester.pump();

    expect(find.text('N-100'), findsOneWidget);

    final field = tester.widget<TextFormField>(find.byType(TextFormField).first);
    expect(field.validator?.call('N-100'), isNull);
    expect(field.validator?.call(''), l10n.fieldRequired);
  });

  testWidgets('rechaza más de 50 caracteres', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return AnimalEntryForm(
              idMassiveEvent: 'me-1',
              activeEvents: [weightEvent()],
              animalEventsAppliedMap: const {},
              onApply: (_) {},
              showError: (_) {},
              showSuccess: (_) {},
              showInfo: (_) {},
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final longNumber = 'A' * 51;
    final field = tester.widget<TextFormField>(find.byType(TextFormField).first);
    expect(field.validator?.call(longNumber), l10n.invalidValue);
  });
}

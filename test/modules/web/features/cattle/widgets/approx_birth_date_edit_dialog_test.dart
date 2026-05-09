import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/approx_birth_date_edit_dialog.dart';

/// MaterialApp con español para textos L10n estables en tests.
Widget wrapEs(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  group('ApproxBirthDateEditDialog', () {
    testWidgets('modo manual con fecha inicial: Aceptar devuelve birthDateAprx', (
      tester,
    ) async {
      Map<String, dynamic>? popped;

      await tester.pumpWidget(
        wrapEs(
          Scaffold(
            body: TextButton(
              onPressed: () async {
                popped = await showDialog<Map<String, dynamic>?>(
                  context: tester.element(find.byType(TextButton)),
                  builder:
                      (_) => const ApproxBirthDateEditDialog(
                        initialBirthDateAprxDisplay: '2020-03-15',
                      ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      expect(popped, <String, dynamic>{'birthDateAprx': '2020-03-15'});
    });

    testWidgets('modo manual sin fecha: muestra error obligatorio', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapEs(
          Scaffold(
            body: TextButton(
              onPressed: () async {
                await showDialog<void>(
                  context: tester.element(find.byType(TextButton)),
                  builder: (_) => const ApproxBirthDateEditDialog(),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo es obligatorio.'), findsOneWidget);
    });

    testWidgets('dentición incompleta: mensaje de completar los cinco', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapEs(
          Scaffold(
            body: TextButton(
              onPressed: () async {
                await showDialog<void>(
                  context: tester.element(find.byType(TextButton)),
                  builder: (_) => const ApproxBirthDateEditDialog(),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Por dentición'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '8');
      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      // El mismo texto aparece como ayuda y como mensaje de error.
      expect(
        find.text(
          'Si usa dentición, complete los cinco valores y la fecha de evaluación.',
        ),
        findsNWidgets(2),
      );
    });

    testWidgets(
      'dentición completa precargada: Aceptar devuelve los cinco campos',
      (tester) async {
        Map<String, dynamic>? popped;

        await tester.pumpWidget(
          wrapEs(
            Scaffold(
              body: TextButton(
                onPressed: () async {
                  popped = await showDialog<Map<String, dynamic>?>(
                    context: tester.element(find.byType(TextButton)),
                    builder:
                        (_) => const ApproxBirthDateEditDialog(
                          milkTeethCount: 8,
                          permanentTeethCount: 0,
                          milkTeethWear: 3,
                          permanentTeethWear: 2,
                          dentalEvaluationDateRaw: '2024-06-15',
                        ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Aceptar'));
        await tester.pumpAndSettle();

        expect(popped, <String, dynamic>{
          'milkTeethCount': 8,
          'permanentTeethCount': 0,
          'milkTeethWear': 3,
          'permanentTeethWear': 2,
          'dentalEvaluationDate': '2024-06-15',
        });
      },
    );

    testWidgets('Cancelar cierra sin resultado', (tester) async {
      Map<String, dynamic>? popped;

      await tester.pumpWidget(
        wrapEs(
          Scaffold(
            body: TextButton(
              onPressed: () async {
                popped = await showDialog<Map<String, dynamic>?>(
                  context: tester.element(find.byType(TextButton)),
                  builder:
                      (_) => const ApproxBirthDateEditDialog(
                        initialBirthDateAprxDisplay: '2021-01-01',
                      ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(popped, isNull);
    });
  });
}

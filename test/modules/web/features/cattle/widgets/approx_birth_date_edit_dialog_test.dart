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

Future<Map<String, dynamic>> fakePreviewBirthFromDentition(
  Map<String, dynamic> _,
) async => <String, dynamic>{
  'birthDateAprx': '2024-06-15',
  'dentitionTableVersion': 'sapa2014-v1',
};

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
                      (_) => ApproxBirthDateEditDialog(
                        initialBirthDateAprxDisplay: '2020-03-15',
                        previewBirthFromDentition:
                            fakePreviewBirthFromDentition,
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
                  builder:
                      (_) => ApproxBirthDateEditDialog(
                        previewBirthFromDentition:
                            fakePreviewBirthFromDentition,
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
                  builder:
                      (_) => ApproxBirthDateEditDialog(
                        previewBirthFromDentition:
                            fakePreviewBirthFromDentition,
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
                        (_) => ApproxBirthDateEditDialog(
                          milkTeethCount: 8,
                          permanentTeethCount: 0,
                          milkTeethWear: 3,
                          permanentTeethWear: 0,
                          dentalEvaluationDateRaw: '2024-06-15',
                          previewBirthFromDentition:
                              fakePreviewBirthFromDentition,
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
          'permanentTeethWear': 0,
          'dentalEvaluationDate': '2024-06-15',
          'birthDateAprxPreview': '2024-06-15',
        });
      },
    );

    testWidgets(
      'dentición: leche>0 con desgaste leche 0 muestra error sin llamar preview',
      (tester) async {
        var previewCalls = 0;
        Future<Map<String, dynamic>> countingPreview(
          Map<String, dynamic> body,
        ) async {
          previewCalls++;
          return fakePreviewBirthFromDentition(body);
        }

        await tester.pumpWidget(
          wrapEs(
            Scaffold(
              body: TextButton(
                onPressed: () async {
                  await showDialog<void>(
                    context: tester.element(find.byType(TextButton)),
                    builder:
                        (_) => ApproxBirthDateEditDialog(
                          milkTeethCount: 8,
                          permanentTeethCount: 0,
                          milkTeethWear: 0,
                          permanentTeethWear: 0,
                          dentalEvaluationDateRaw: '2024-06-15',
                          previewBirthFromDentition: countingPreview,
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

        expect(previewCalls, 0);
        expect(
          find.textContaining('No aplica'),
          findsWidgets,
        );
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
                      (_) => ApproxBirthDateEditDialog(
                        initialBirthDateAprxDisplay: '2021-01-01',
                        previewBirthFromDentition:
                            fakePreviewBirthFromDentition,
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

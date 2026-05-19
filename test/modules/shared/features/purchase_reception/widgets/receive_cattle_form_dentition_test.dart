import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/receive_cattle_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget wrapEsWideForm(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

/// Evita HTTP real en debounces de número / arete / búsqueda de tracker.
class StubReceptionApiService extends ReceptionApiService {
  StubReceptionApiService() : super();

  @override
  Future<bool> checkCattleNumberExists(String number) async => false;

  @override
  Future<bool> checkEartagExists(String eartag) async => false;

  @override
  Future<List<DeviceModel>> searchDevices(String query) async => [];
}

Finder milkWearDropdownEs() {
  return find.byWidgetPredicate(
    (w) =>
        w is DropdownButtonFormField<int?> &&
        w.decoration.labelText == 'Desgaste leche',
  );
}

Future<void> pumpFormWithQuickDentition(
  WidgetTester tester, {
  required ReceiveCattleForm form,
}) async {
  // setSurfaceSize no siempre aplica al RenderView en esta versión; physicalSize sí.
  final view = tester.view;
  view.physicalSize = const Size(1920, 1400);
  view.devicePixelRatio = 1.0;
  addTearDown(view.resetPhysicalSize);
  addTearDown(view.resetDevicePixelRatio);
  await tester.pumpWidget(wrapEsWideForm(form));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReceiveCattleForm dentición rápida', () {
    late Map<String, dynamic>? submitted;
    late String? errorFromUi;

    setUp(() async {
      submitted = null;
      errorFromUi = null;
      SharedPreferences.setMockInitialValues(<String, Object>{
        'reception_submit_birth_dentition_count': 4,
        'reception_submit_birth_manual_count': 1,
      });
    });

    testWidgets(
      'envío completo 8 leche / 0 permanentes incluye payload dentición SAPA',
      (tester) async {
        final form = ReceiveCattleForm(
          receptionApiService: StubReceptionApiService(),
          availableLots: [
            {
              'id': 'lot-a',
              'lotNumber': 1,
              'totalWeight': 200,
              'purchasedCattleCount': 2,
              'pricePerKg': 10,
            },
          ],
          activeEvents: const <SimpleEventModel>[],
          onSubmit: (Map<String, dynamic> cattleData) async {
            submitted = cattleData;
          },
          onNumberChanged: (_) {},
          onError: (e) {
            errorFromUi = e;
          },
        );

        await pumpFormWithQuickDentition(tester, form: form);

        await tester.enterText(
          find.byKey(const ValueKey('receive_form_number')),
          'WT-DENT-1',
        );
        await tester.enterText(
          find.byKey(const ValueKey('receive_form_weight')),
          '350',
        );

        await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Negro'));
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 600));

        await tester.tap(find.text('Dentición rápida (uso frecuente)'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_milk_count')),
          '8',
        );
        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_perm_count')),
          '0',
        );
        await tester.pumpAndSettle();

        await tester.tap(milkWearDropdownEs());
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('3 —').last);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Recibir res'));
        await tester.pumpAndSettle();

        expect(errorFromUi, isNull);
        expect(submitted, isNotNull);
        expect(submitted!['milkTeethCount'], 8);
        expect(submitted!['permanentTeethCount'], 0);
        expect(submitted!['milkTeethWear'], 3);
        expect(submitted!['permanentTeethWear'], 0);
        expect(submitted!['dentalEvaluationDate'], isNotEmpty);
        expect(submitted!.containsKey('birthDateAprx'), isFalse);
      },
    );

    testWidgets(
      'al cambiar par de conteos se limpia desgaste leche y bloquea envío parcial',
      (tester) async {
        final form = ReceiveCattleForm(
          receptionApiService: StubReceptionApiService(),
          availableLots: [
            {
              'id': 'lot-a',
              'lotNumber': 1,
              'totalWeight': 200,
              'purchasedCattleCount': 2,
              'pricePerKg': 10,
            },
          ],
          activeEvents: const <SimpleEventModel>[],
          onSubmit: (Map<String, dynamic> cattleData) async {
            submitted = cattleData;
          },
          onNumberChanged: (_) {},
          onError: (e) {
            errorFromUi = e;
          },
        );

        await pumpFormWithQuickDentition(tester, form: form);

        await tester.enterText(
          find.byKey(const ValueKey('receive_form_number')),
          'WT-DENT-2',
        );
        await tester.enterText(
          find.byKey(const ValueKey('receive_form_weight')),
          '340',
        );

        await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Negro'));
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 600));

        await tester.tap(find.text('Dentición rápida (uso frecuente)'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_milk_count')),
          '8',
        );
        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_perm_count')),
          '0',
        );
        await tester.pumpAndSettle();

        await tester.tap(milkWearDropdownEs());
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('3 —').last);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_milk_count')),
          '6',
        );
        await tester.enterText(
          find.byKey(const ValueKey('receive_quick_dentition_perm_count')),
          '2',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Recibir res'));
        await tester.pumpAndSettle();

        expect(submitted, isNull);
        expect(errorFromUi, isNotNull);
        expect(
          errorFromUi,
          'Si usa dentición, complete los cinco valores y la fecha de evaluación.',
        );
      },
    );
  });
}

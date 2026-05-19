import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/edit_received_cattle_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingReceptionApi extends ReceptionApiService {
  Map<String, dynamic>? lastBody;
  String? lastCattleId;
  Object? throwOnSave;

  @override
  Future<void> updateReceivedCattle({
    required String cattleId,
    required Map<String, dynamic> body,
  }) async {
    lastCattleId = cattleId;
    lastBody = body;
    if (throwOnSave != null) throw throwOnSave!;
  }
}

Widget _wrapDialog(Widget dialog) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: dialog),
  );
}

Map<String, dynamic> _sampleCattle() => {
  'id': 'cattle-1',
  'number': '100',
  'receivedWeight': 320,
  'eartagLeft': 'L-ORIG',
  'eartagRight': 'R-ORIG',
  'idLot': 'lot-a',
  'color': 'BLACK',
  'hasHorn': false,
  'castrated': false,
  'gender': 'MALE',
  'characteristics': <String>[],
  'deviceName': '-',
  'comments': '',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reception_submit_birth_dentition_count': 0,
      'reception_submit_birth_manual_count': 0,
    });
  });

  group('EditReceivedCattleDialog', () {
    testWidgets('precarga peso, lote y número en título', (tester) async {
      final api = _RecordingReceptionApi();
      await tester.pumpWidget(
        _wrapDialog(
          EditReceivedCattleDialog(
            cattle: _sampleCattle(),
            availableLots: [
              {'id': 'lot-a', 'lotNumber': 1},
              {'id': 'lot-b', 'lotNumber': 2},
            ],
            receptionApi: api,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('100'), findsWidgets);
      expect(
        find.byKey(const ValueKey('edit_cattle_weight')),
        findsOneWidget,
      );
      final weightField = tester.widget<TextFormField>(
        find.byKey(const ValueKey('edit_cattle_weight')),
      );
      expect(weightField.controller?.text, '320');
    });

    testWidgets('flujo feliz: guardar cierra con true y envía PATCH', (
      tester,
    ) async {
      final api = _RecordingReceptionApi();
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  dialogResult = await showDialog<bool>(
                    context: context,
                    builder:
                        (_) => EditReceivedCattleDialog(
                          cattle: _sampleCattle(),
                          availableLots: [
                            {'id': 'lot-a', 'lotNumber': 1},
                          ],
                          receptionApi: api,
                        ),
                  );
                },
                child: const Text('open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('edit_cattle_weight')),
        '355',
      );
      await tester.tap(find.byKey(const ValueKey('edit_cattle_save')));
      await tester.pumpAndSettle();

      expect(dialogResult, isTrue);
      expect(api.lastCattleId, 'cattle-1');
      expect(api.lastBody?['receivedWeight'], 355);
      expect(api.lastBody?['idLot'], 'lot-a');
    });

    testWidgets('initialLotId respaldo si cattle no trae idLot', (
      tester,
    ) async {
      final cattle = _sampleCattle()..remove('idLot');
      await tester.pumpWidget(
        _wrapDialog(
          EditReceivedCattleDialog(
            cattle: cattle,
            availableLots: [
              {'id': 'lot-b', 'lotNumber': 2},
            ],
            initialLotId: 'lot-b',
            receptionApi: _RecordingReceptionApi(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Lote 2'), findsOneWidget);
    });

    testWidgets('peso inválido no llama API', (tester) async {
      final api = _RecordingReceptionApi();
      await tester.pumpWidget(
        _wrapDialog(
          EditReceivedCattleDialog(
            cattle: _sampleCattle(),
            availableLots: [],
            receptionApi: api,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('edit_cattle_weight')),
        '0',
      );
      await tester.tap(find.byKey(const ValueKey('edit_cattle_save')));
      await tester.pumpAndSettle();

      expect(api.lastBody, isNull);
    });

    testWidgets('error de API se muestra en diálogo', (tester) async {
      final api = _RecordingReceptionApi()
        ..throwOnSave = Exception('conflict eartag');
      await tester.pumpWidget(
        _wrapDialog(
          EditReceivedCattleDialog(
            cattle: _sampleCattle(),
            availableLots: [],
            receptionApi: api,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('edit_cattle_save')));
      await tester.pumpAndSettle();

      expect(find.textContaining('conflict'), findsOneWidget);
    });

    testWidgets('cancelar cierra sin guardar', (tester) async {
      final api = _RecordingReceptionApi();
      await tester.pumpWidget(
        _wrapDialog(
          EditReceivedCattleDialog(
            cattle: _sampleCattle(),
            availableLots: [],
            receptionApi: api,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(EditReceivedCattleDialog)),
      )!;
      await tester.tap(find.text(l10n.cancel));
      await tester.pumpAndSettle();

      expect(api.lastBody, isNull);
    });
  });
}

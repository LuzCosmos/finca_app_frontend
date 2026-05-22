import 'dart:convert';

import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/services/scale_reading_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/animal_entry_form.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/receive_cattle_form.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/create_sale_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../support/app_test_host.dart';
import '../support/scale_screen_test_support.dart' as scale_support;

class _MockMassiveEventDataSource extends Mock
    implements IMassiveEventPageDataSource {}

class _MockSalesDataSource extends Mock implements ISalesDataSource {}

class _StubReceptionApi extends ReceptionApiService {
  @override
  Future<bool> checkCattleNumberExists(String number) async => false;

  @override
  Future<bool> checkEartagExists(String eartag) async => false;

  @override
  Future<List<DeviceModel>> searchDevices(String query) async => [];
}

String _jwtWithExp(int offsetSeconds) {
  final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + offsetSeconds;
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': exp})))
      .replaceAll('=', '');
  return '$header.$payload.sig';
}

Future<void> _hydrateSession({
  Map<String, dynamic>? permissions,
}) async {
  await SessionService.saveSession(
    token: _jwtWithExp(7200),
    permissions: permissions ?? {'FARM': {'cattle': '11111'}},
    idTenant: 'tenant-1',
    idUser: 'user-1',
    refreshToken: 'rt',
  );
}

void main() {
  tearDown(ScaleReadingService.resetDebugState);

  group('AnimalEntryForm + pesa', () {
    late _MockMassiveEventDataSource dataSource;

    setUp(() {
      dataSource = _MockMassiveEventDataSource();
      scale_support.setConnectedStableScale(weightKg: 385.2);
    });

    Widget wrapAnimalEntry(Widget child) {
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

    testWidgets('con tipo peso: aplica estable en campo peso', (tester) async {
      await tester.pumpWidget(
        wrapAnimalEntry(
          AnimalEntryForm(
                idMassiveEvent: 'me-1',
                activeEvents: [weightEvent()],
                animalEventsAppliedMap: const {},
                onApply: (_) {},
                showError: (_) {},
                showSuccess: (_) {},
                showInfo: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(scale_support.scalePanelFinder, findsOneWidget);
      await scale_support.tapUseStableWeightSettle(tester);

      expect(find.text('385.20'), findsOneWidget);
    });

    testWidgets('sin tipo peso: no muestra panel', (tester) async {
      await tester.pumpWidget(
        wrapAnimalEntry(
          AnimalEntryForm(
            idMassiveEvent: 'me-1',
            activeEvents: const [],
            animalEventsAppliedMap: const {},
            onApply: (_) {},
            showError: (_) {},
            showSuccess: (_) {},
            showInfo: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(scale_support.scalePanelFinder, findsNothing);
    });
  });

  group('ReceiveCattleForm + pesa', () {
    setUp(() {
      scale_support.setConnectedStableScale(weightKg: 412.5);
    });

    testWidgets('aplica peso estable en receive_form_weight', (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(1600, 900);
      view.devicePixelRatio = 1.0;
      addTearDown(view.resetPhysicalSize);
      addTearDown(view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          locale: Language.spanish.localeValue,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReceiveCattleForm(
                receptionApiService: _StubReceptionApi(),
                availableLots: const [],
                activeEvents: const [],
                onSubmit: (_) {},
                onNumberChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(scale_support.scalePanelFinder, findsOneWidget);
      await scale_support.tapUseStableWeightSettle(tester);

      final field = tester.widget<TextFormField>(
        find.byKey(const ValueKey('receive_form_weight')),
      );
      expect(field.controller?.text, '412.50');
    });
  });

  group('CreateSalePage + pesa', () {
    late _MockSalesDataSource dataSource;

    setUp(() {
      dataSource = _MockSalesDataSource();
      scale_support.setConnectedStableScale(weightKg: 400.0);
      when(() => dataSource.getBusinessPartners(any())).thenAnswer((_) async => []);
      when(() => dataSource.fetchCatalogs()).thenAnswer((_) async {});
    });

    testWidgets(
      'aplica peso estable en create_sale_cattle_weight',
      (tester) async {
        final view = tester.view;
        view.physicalSize = const Size(1920, 1400);
        view.devicePixelRatio = 1.0;
        addTearDown(view.resetPhysicalSize);
        addTearDown(view.resetDevicePixelRatio);

        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: CreateSalePage(dataSource: dataSource),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        expect(scale_support.scalePanelFinder, findsOneWidget);
        await scale_support.tapUseStableWeightSettle(tester);

        final field = tester.widget<TextFormField>(
          find.byKey(const ValueKey('create_sale_cattle_weight')),
        );
        expect(field.controller?.text, '400.00');
      },
    );
  });

  group('CattleMasterListPage + pesa', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      SessionService.resetForTesting();
      BasicApiService.resetForTesting();
      await _hydrateSession();
      BasicApiService.setBaseUrl('https://api-cattle.test/api/v1');
      scale_support.setConnectedStableScale(weightKg: 350.0);
    });

    Future<void> pumpCattleList(WidgetTester tester) async {
      await http.runWithClient(() async {
        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: const CattleMasterListPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }, () {
        return MockClient((request) async {
          if (request.method == 'GET' && request.url.path.endsWith('/cattle')) {
            return http.Response(
              jsonEncode({
                'items': [
                  {
                    'id': 'c1',
                    'number': '100',
                    'lastWeight': 300,
                    'status': 'ACTIVE',
                  },
                ],
                'page': 1,
                'limit': 500,
                'total': 1,
              }),
              200,
            );
          }
          return http.Response('{}', 404);
        });
      });
    }

    testWidgets('muestra panel con permiso de edición', (tester) async {
      await pumpCattleList(tester);
      expect(scale_support.scalePanelFinder, findsOneWidget);
    });

    testWidgets(
      'sin celda de peso en edición muestra mensaje scale_selectWeightCell',
      (tester) async {
        await pumpCattleList(tester);

        final l10n = AppLocalizations.of(
          tester.element(scale_support.scalePanelFinder),
        )!;

        await scale_support.tapUseStableWeightSettle(tester);

        expect(find.text(l10n.scale_selectWeightCell), findsOneWidget);
      },
    );

    testWidgets('sin permiso update: botón usar peso deshabilitado', (
      tester,
    ) async {
      SessionService.resetForTesting();
      BasicApiService.resetForTesting();
      await _hydrateSession(
        permissions: {
          'FARM': {'cattle': '11000'},
        },
      );
      BasicApiService.setBaseUrl('https://api-cattle.test/api/v1');

      await pumpCattleList(tester);

      final button = tester.widget<FilledButton>(
        find.descendant(
          of: scale_support.scalePanelFinder,
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
    });
  });
}

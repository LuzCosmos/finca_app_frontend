import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/utils/reception_form_field_style.dart';
import 'package:finca_app_frontend/modules/shared/features/purchase_reception/widgets/receive_cattle_form.dart';

import '../reception_form_field_test_support.dart';

class _StubReceptionApi extends ReceptionApiService {
  @override
  Future<bool> checkCattleNumberExists(String number) async => false;

  @override
  Future<bool> checkEartagExists(String eartag) async => false;

  @override
  Future<List<DeviceModel>> searchDevices(String query) async => [];
}

void main() {
  testWidgets('ReceiveCattleForm usa decoración y contenedor compactos', (
    tester,
  ) async {
    final view = tester.view;
    view.physicalSize = const Size(1600, 900);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceiveCattleForm(
              receptionApiService: _StubReceptionApi(),
              availableLots: const [],
              activeEvents: const <SimpleEventModel>[],
              onSubmit: (_) {},
              onNumberChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectCompactReceptionFieldDecoration(
      tester,
      find.byKey(const ValueKey('receive_form_weight')),
    );

    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.byWidgetPredicate(
          (w) => w is Padding && w.padding == kReceptionFormOuterPadding,
        ),
      ),
      findsOneWidget,
    );
  });
}

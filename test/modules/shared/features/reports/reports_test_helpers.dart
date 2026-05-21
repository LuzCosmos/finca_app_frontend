import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';

Future<void> saveReportsTestSession() async {
  SharedPreferences.setMockInitialValues({});
  final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400;
  await SessionService.saveSession(
    token:
        'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.'
        '${base64Url.encode(utf8.encode(jsonEncode({'exp': exp})))}.'
        'sig',
    permissions: const {},
    idTenant: 'tenant-reports-test',
    idUser: 'user-reports-test',
    refreshToken: 'rt',
  );
  await SessionService.hydrateFromStorage();
}

/// Evita timeout de `pumpAndSettle` con animaciones de gráficos (fl_chart).
Future<void> pumpReportsWidget(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/theme/theme.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/main.dart';
import 'package:finca_app_frontend/router/router.dart';

// Bajo prueba: lib/main.dart (MainApp), lib/core/blocs/locale/locale_bloc.dart,
// lib/core/theme/theme.dart, lib/core/utils/language.dart, lib/l10n/app_localizations.dart,
// lib/router/router.dart, lib/core/services/session_service.dart.

void main() {
  setUp(() {
    SessionService.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MainApp: raíz incluye LocaleBloc y tema enlazado', (
    WidgetTester tester,
  ) async {
    await SessionService.hydrateFromStorage();

    await tester.pumpWidget(
      MainApp(router: createAppRouter(hasValidToken: () => false)),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(BlocBuilder<LocaleBloc, LocaleState>), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);

    final MaterialApp material =
        tester.widget(find.byType(MaterialApp)) as MaterialApp;
    expect(material.debugShowCheckedModeBanner, false);
    expect(material.theme, AppTheme.lightTheme);
    expect(material.locale, Language.spanish.localeValue);
    expect(
      material.supportedLocales,
      AppLocalizations.supportedLocales,
    );
    expect(
      material.localizationsDelegates,
      AppLocalizations.localizationsDelegates,
    );

    expect(tester.takeException(), isNull);
  });
}

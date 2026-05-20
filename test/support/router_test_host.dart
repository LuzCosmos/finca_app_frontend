import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// [MaterialApp.router] con [LocaleBloc] para tests de rutas.
Widget buildRouterTestHost(GoRouter router) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      locale: Language.spanish.localeValue,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

/// Avanza tiempo de reloj sin [pumpAndSettle]: indicadores de carga indefinidos
/// (p. ej. en Home o listas con API) impiden que el settle termine.
Future<void> pumpRouterFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(seconds: 2));
}

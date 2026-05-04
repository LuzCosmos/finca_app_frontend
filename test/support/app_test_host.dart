import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/theme/theme.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// [MaterialApp] con tema, [LocaleBloc] y localización (español por defecto).
Widget pumpLocalizedMaterialShell({
  required Widget home,
  Locale? locale,
}) {
  return BlocProvider(
    create: (_) => LocaleBloc(),
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale ?? Language.spanish.localeValue,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

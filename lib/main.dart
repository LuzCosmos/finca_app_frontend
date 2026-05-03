import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'router/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finca_app_frontend/core/theme/theme.dart';
import 'package:finca_app_frontend/core/bootstrap/mobile_sync_provider.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

class _ErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const _ErrorApp({
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Error de arranque')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Error: $error\n\nStack:\n$stackTrace',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e, st) {
      debugPrint('dotenv.load falló (p. ej. asset .env ausente): $e\n$st');
    }
  }
  await SessionService.hydrateFromStorage();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            'FlutterError:\n${details.exception}\n\n${details.stack}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  };

  runZonedGuarded(
    () async {
      await _bootstrap();
      runApp(const MainApp());
    },
    (Object error, StackTrace stackTrace) {
      runApp(_ErrorApp(error: error, stackTrace: stackTrace));
    },
  );
}

class MainApp extends StatelessWidget {
  /// Si es null, se usa [appRouter] (comportamiento en producción).
  final GoRouter? router;

  const MainApp({super.key, this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LocaleBloc>(create: (_) => LocaleBloc())],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return wrapMobileSyncScope(
            MaterialApp.router(
              debugShowCheckedModeBanner: false,
              locale: state.selectedLanguage.localeValue,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: AppTheme.lightTheme,
              routerConfig: router ?? appRouter,
            ),
          );
        },
      ),
    );
  }
}

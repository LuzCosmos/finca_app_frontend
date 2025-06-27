import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LocaleBloc>(create: (_) => LocaleBloc())],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.selectedLanguage.localeValue,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const MyHomePage(title: 'Finca App'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Finca App'),
        actions: <Widget>[
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              return _buildLanguageSwitch(context, Theme.of(context), state);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(l10n.testMedium, style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}

Widget _buildLanguageSwitch(
  BuildContext context,
  ThemeData theme,
  LocaleState state,
) {
  return TextButton(
    onPressed: () {
      context.read<LocaleBloc>().add(
        ChangeLanguage(
          state.selectedLanguage == Language.english
              ? Language.spanish
              : Language.english,
        ),
      );
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "EN",
            style: TextStyle(
              fontSize: 18,
              color:
                  state.selectedLanguage == Language.english
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
          const TextSpan(
            text: " | ",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextSpan(
            text: "ES",
            style: TextStyle(
              fontSize: 18,
              color:
                  state.selectedLanguage == Language.spanish
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}






/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      create: (_) => LocaleBloc(),
      child: const _MyAppContent(),
    );
  }
}

class _MyAppContent extends StatelessWidget {
  const _MyAppContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finca App'),
        actions: <Widget>[_LanguageSwitch()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(l10n.testMedium, style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            context.read<LocaleBloc>().add(
              ChangeLanguage(
                state.selectedLanguage == Language.english
                    ? Language.spanish
                    : Language.english,
              ),
            );
          },
          child: _buildLanguageText(state),
        );
      },
    );
  }

  Widget _buildLanguageText(LocaleState state) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "EN",
            style: TextStyle(
              fontSize: 18,
              color:
                  state.selectedLanguage == Language.english
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
          const TextSpan(
            text: " | ",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextSpan(
            text: "ES",
            style: TextStyle(
              fontSize: 18,
              color:
                  state.selectedLanguage == Language.spanish
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
*/
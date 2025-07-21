import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';

class FincaScaffold extends StatelessWidget {
  final Widget body;
  final String? title;

  const FincaScaffold({super.key, required this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title ?? 'Finca App'),
        actions: <Widget>[
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              return _buildLanguageSwitch(context, Theme.of(context), state);
            },
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildLanguageSwitch(
    BuildContext context,
    ThemeData theme,
    LocaleState state,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        padding: const EdgeInsets.only(right: 10),
        value: state.selectedLanguage.locale,
        icon: const Icon(Icons.language, color: Colors.white, size: 11),
        dropdownColor: theme.colorScheme.primary,
        onChanged: (String? newLangCode) {
          if (newLangCode != null) {
            final selectedLang = languageFromCode(newLangCode);
            context.read<LocaleBloc>().add(ChangeLanguage(selectedLang));
          }
        },
        items:
            Language.values.map((lang) {
              return DropdownMenuItem<String>(
                value: lang.locale,
                child: Text(
                  '${lang.flag} ${lang.name}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              );
            }).toList(),
      ),
    );
  }
}

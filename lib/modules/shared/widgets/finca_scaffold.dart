import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

class FincaScaffold extends StatelessWidget {
  final Widget body;
  final String? title;

  const FincaScaffold({super.key, required this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionService.isAuthenticated(),
      builder: (context, snapshot) {
        final bool isAuthenticated = snapshot.data ?? false;
        
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(title ?? 'Finca App'),
            leading: Navigator.of(context).canPop() ? const BackButton() : null,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              BlocBuilder<LocaleBloc, LocaleState>(
                builder: (context, state) {
                  return _buildLanguageSwitch(context, Theme.of(context), state);
                },
              ),
              if (isAuthenticated) ...[
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 20),
                  onPressed: () {
                    context.go('/home');
                  },
                ),
                _buildUserDropdown(context, Theme.of(context)),
              ],
                
            ],
          ),
          body: body,
        );
      },
    );
  }

  Widget _buildLanguageSwitch(
    BuildContext context,
    ThemeData theme,
    LocaleState state,
  ) {
    return PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.selectedLanguage.flag,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.language, color: Colors.white, size: 16),
        ],
      ),
      color: theme.colorScheme.primary,
      offset: const Offset(0, 40),
      onSelected: (String newLangCode) {
        final selectedLang = languageFromCode(newLangCode);
        context.read<LocaleBloc>().add(ChangeLanguage(selectedLang));
      },
      itemBuilder: (BuildContext context) => Language.values.map((lang) {
        return PopupMenuItem<String>(
          value: lang.locale,
          child: Row(
            children: [
              Text(
                lang.flag,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                lang.name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserDropdown(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person, color: Colors.white, size: 20),
      color: theme.colorScheme.primary,
      offset: const Offset(0, 40),
      onSelected: (String value) async {
        if (value == 'logout') {
          final success = await SessionService.logout();
          if (success && context.mounted) {
            context.go('/login');
          }
        } /*else if (value == 'editUser') {
          context.push('/user/edit');
        }*/
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        /*PopupMenuItem<String>(
          value: 'editUser',
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.user_editUser,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),*/
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.user_logout,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

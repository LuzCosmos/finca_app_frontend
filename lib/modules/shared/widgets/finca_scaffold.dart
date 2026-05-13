import 'package:finca_app_frontend/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

class FincaScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final bool showHomeButton;

  /// Si es true, solo se renderiza [body] (sin [Scaffold] ni AppBar).
  /// Útil al embeber la pantalla dentro del panel derecho del home en layout ancho.
  final bool embedded;

  /// Si no es null, el icono inicio ejecuta solo este callback (p. ej. [HomePage] rail: volver al
  /// dashboard del panel sin solo depender del router).
  ///
  /// Si es null (**típico en móvil angosto**: `/users`, formularios a pantalla completa, etc.),
  /// el comportamiento es [navigateToHomeRemovingOverlays]: primero cierra overlays de
  /// [Navigator.push], luego **siempre** [GoRouter.go]('/home') — ese `go` no se quitó; sigue siendo
  /// el que lleva desde rutas declarativas al inicio.
  final VoidCallback? onHomePressed;

  /// Botón flotante opcional (p. ej. crear en listas móviles).
  final Widget? floatingActionButton;

  const FincaScaffold({
    super.key,
    required this.body,
    this.title,
    this.showHomeButton = true,
    this.embedded = false,
    this.onHomePressed,
    this.floatingActionButton,
  });

  /// Cierra rutas empiladas con [Navigator.push] (formularios modales, etc.).
  /// Sin esto, [GoRouter.go]('/home') no hace nada si la ubicación ya era `/home`
  /// y la pantalla seguía visible encima.
  static void popNavigatorOverlays(BuildContext context) {
    for (final root in [false, true]) {
      final navigator = Navigator.maybeOf(context, rootNavigator: root);
      if (navigator == null) {
        continue;
      }
      while (navigator.canPop()) {
        navigator.pop();
      }
    }
  }

  /// 1. Cierra rutas locales [Navigator.push] (modales sobre la misma ubicación declarativa).
  /// 2. **Siempre** [GoRouter.go]('/home') — necesario en pantalla estrecha/móvil al volver desde
  /// `/sales`, `/users`, etc.; en web desktop también al salir de pantallas sin rail.
  static void navigateToHomeRemovingOverlays(BuildContext context) {
    popNavigatorOverlays(context);
    GoRouter.of(context).go('/home');
  }

  @override
  State<FincaScaffold> createState() => _FincaScaffoldState();
}

class _FincaScaffoldState extends State<FincaScaffold> {
  late Future<bool> _isAuthenticatedFuture;

  @override
  void initState() {
    super.initState();
    _isAuthenticatedFuture = SessionService.isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return widget.body;
    }

    return FutureBuilder<bool>(
      future: _isAuthenticatedFuture,
      builder: (context, snapshot) {
        final bool isAuthenticated = snapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(widget.title ?? 'Finca App'),
            leading: Navigator.of(context).canPop() ? const BackButton() : null,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              BlocBuilder<LocaleBloc, LocaleState>(
                builder: (context, state) {
                  return _buildLanguageSwitch(
                    context,
                    Theme.of(context),
                    state,
                  );
                },
              ),
              if (isAuthenticated) ...[
                if (widget.showHomeButton) ...[
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white, size: 20),
                    tooltip: AppLocalizations.of(context)!.home_title,
                    onPressed: () {
                      if (widget.onHomePressed != null) {
                        widget.onHomePressed!();
                      } else {
                        FincaScaffold.navigateToHomeRemovingOverlays(context);
                      }
                    },
                  ),
                ],
                _buildUserDropdown(context, Theme.of(context)),
              ],
            ],
          ),
          body: widget.body,
          floatingActionButton: widget.floatingActionButton,
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
      itemBuilder:
          (BuildContext context) =>
              Language.values.map((lang) {
                return PopupMenuItem<String>(
                  value: lang.locale,
                  child: Row(
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        lang.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
    );
  }

  Widget _buildUserDropdown(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.person, color: Colors.white, size: 20),
      color: theme.colorScheme.primary,
      offset: const Offset(0, 40),
      onSelected: (String value) async {
        if (value == 'logout') {
          final success = await AuthService().logout();
          if (success && context.mounted) {
            context.go('/login');
          }
        } /*else if (value == 'editUser') {
          context.push('/user/edit');
        }*/
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            /*PopupMenuItem<String>(
          value: 'editUser',
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.editSomething(l10n.user),
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
                    l10n.logout,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}

import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:flutter/material.dart';
import '/core/services/auth_service.dart';
import '/core/services/auth_exception.dart';
import '/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onLoginSuccess;
  final AuthService? authService;

  const LoginForm({super.key, required this.onLoginSuccess, this.authService});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String companyUsername = 'finca_alamos';

  bool loading = false;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = widget.authService ?? AuthService();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => loading = true);
    try {
      final result = await authService.login(
        username: username,
        password: password,
        companyUsername: companyUsername,
      );
      await SessionService.saveSession(
        token: result['token'],
        permissions: result['permissions'],
        idTenant: result['idTenant'],
      );
      widget.onLoginSuccess(result);
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;

      String errorMessage;
      if (e is AuthException) {
        switch (e.message) {
          case 'invalidCredentials':
            errorMessage = l10n.login_invalidCredentials;
            break;
          default:
            errorMessage = l10n.login_unexpectedError;
        }
      } else {
        errorMessage = l10n.login_unexpectedError;
      }
      MessageBanner.error(errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: '',
            decoration: InputDecoration(labelText: l10n.login_username),
            onChanged: (val) => username = val,
            validator:
                (val) => val!.isEmpty ? l10n.login_usernameRequired : null,
          ),
          TextFormField(
            initialValue: '',
            decoration: InputDecoration(labelText: l10n.login_password),
            obscureText: true,
            onChanged: (val) => password = val,
            validator:
                (val) => val!.isEmpty ? l10n.login_passwordRequired : null,
          ),
          TextFormField(
            initialValue: 'finca_alamos',
            decoration: InputDecoration(labelText: l10n.login_company),
            onChanged: (val) => companyUsername = val,
          ),
          const SizedBox(height: 20),
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                onPressed: _submit,
                child: Text(l10n.login_login),
              ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finca_app_frontend/core/services/auth_service.dart';
import 'package:finca_app_frontend/core/services/auth_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/models/user_model.dart';

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
  String companyUsername = 'GPCB';

  bool loading = false;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = widget.authService ?? AuthService();
  }

  void _submit() async {
    if (loading) return;
    if (_formKey.currentState?.validate() != true) return;
    setState(() => loading = true);
    try {
      final result = await authService.login(
        username: username,
        password: password,
        companyUsername: companyUsername,
      );
      if (!mounted) return;
      final User user = result['user'];
      await SessionService.saveSession(
        token: result['token'],
        permissions: result['permissions'],
        idTenant: user.idTenant,
        idUser: user.id,
        refreshToken: result['refreshToken'] as String?,
      );
      if (!mounted) return;
      widget.onLoginSuccess(result);
    } catch (e) {
      if (!mounted) return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
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
            key: const Key('login-username-field'),
            initialValue: '',
            decoration: InputDecoration(labelText: l10n.username),
            autofillHints: const [AutofillHints.username],
            onChanged: (val) => username = val,
            validator:
                (val) =>
                    val == null || val.trim().isEmpty
                        ? l10n.login_usernameRequired
                        : null,
          ),
          TextFormField(
            key: const Key('login-password-field'),
            initialValue: '',
            decoration: InputDecoration(labelText: l10n.password),
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            onChanged: (val) => password = val,
            validator:
                (val) =>
                    val == null || val.trim().isEmpty
                        ? l10n.login_passwordRequired
                        : null,
          ),
          TextFormField(
            key: const Key('login-company-field'),
            initialValue: 'GPCB',
            decoration: InputDecoration(labelText: l10n.company),
            onChanged: (val) => companyUsername = val,
          ),
          const SizedBox(height: 20),
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _submit, child: Text(l10n.login)),
        ],
      ),
    );
  }
}

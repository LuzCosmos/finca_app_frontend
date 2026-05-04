import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/auth_service.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/widgets/login_form.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';

class LoginPage extends StatelessWidget {
  final String title;
  final AuthService? authService;

  const LoginPage({super.key, this.title = '', this.authService});

  void _handleLoginSuccess(
    BuildContext context,
    Map<String, dynamic> _,
  ) {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return KeyedSubtree(
      key: const ValueKey<String>('login-page'),
      child: FincaScaffold(
        title: title,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 400 : double.infinity,
              ),
              child: LoginForm(
                onLoginSuccess: (data) => _handleLoginSuccess(context, data),
                authService: authService,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

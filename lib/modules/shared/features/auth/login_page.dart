import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/finca_scaffold.dart';

class LoginPage extends StatelessWidget {
  final String title;
  const LoginPage({super.key, this.title = ''});

  void _handleLoginSuccess(
    BuildContext context,
    Map<String, dynamic> loginData,
  ) {
    // Aquí haces navegación o asignación de estado global
    // Ejemplo: Navigator.pushReplacementNamed(context, '/home');
    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const HomePage()),);
    context.go('/home');

    print('Login exitoso. Usuario: ${loginData['user'].username}');
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return FincaScaffold(
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
            ),
          ),
        ),
      ),
    );
  }
}

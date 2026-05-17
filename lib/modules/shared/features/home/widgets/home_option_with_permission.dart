import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_card.dart';

class HomeOptionWithPermission extends StatelessWidget {
  /// Si es true, la opción solo se muestra en móvil cuando hay conexión (en web siempre visible).
  final bool requiresOnline;
  final bool isVisible;
  final String title;
  final IconData icon;
  final String route;

  /// Si el padre ya filtró por conectividad, puede omitir la comprobación interna.
  final bool online;

  const HomeOptionWithPermission({
    super.key,
    required this.isVisible,
    required this.title,
    required this.icon,
    required this.route,
    this.requiresOnline = false,
    this.online = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox();
    }
    if (requiresOnline && !kIsWeb && !online) {
      return const SizedBox();
    }
    return HomeOptionCard(
      title: title,
      icon: icon,
      onTap: () => context.push(route),
    );
  }
}

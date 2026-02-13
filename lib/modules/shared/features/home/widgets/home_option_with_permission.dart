import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_card.dart';

class HomeOptionWithPermission extends StatelessWidget {
  final bool forWebOnly;
  final bool isVisible;
  final String title;
  final IconData icon;
  final String route;

  const HomeOptionWithPermission({
    super.key,
    required this.isVisible,
    required this.title,
    required this.icon,
    required this.route,
    this.forWebOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox();
    }
    if (forWebOnly && !PlatformService().isWeb()) {
      return const SizedBox();
    }
    return HomeOptionCard(
      title: title,
      icon: icon,
      onTap: () => context.push(route),
    );
  }
}

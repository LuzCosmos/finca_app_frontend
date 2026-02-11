import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_card.dart';

class HomeOptionWithPermission extends StatelessWidget {
  final String module;
  final String resource;
  final bool forWebOnly;
  final String title;
  final IconData icon;
  final String route;

  const HomeOptionWithPermission({
    super.key,
    required this.module,
    required this.resource,
    required this.title,
    required this.icon,
    required this.route,
    this.forWebOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionService.hasPermission(module, resource),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        if (!(snapshot.data ?? false)) {
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
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_with_permission.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    //final isWeb = PlatformService().isWeb();

    return FincaScaffold(
      title: l10n.home_title,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              HomeOptionWithPermission(
                module: "COMMERCE",
                resource: "purchases",
                title: l10n.home_purchase,
                icon: Icons.shopping_cart,
                route: "/cattle-purchase",
              ),
              HomeOptionWithPermission(
                module: "MASSIVE_EVENTS",
                resource: "massive_events",
                title: l10n.home_massiveEvent,
                icon: CupertinoIcons.list_bullet,
                route: "/massive-event",
                forWebOnly: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

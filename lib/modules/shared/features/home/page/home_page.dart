import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_card.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_with_permission.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWeb = PlatformService().isWeb();

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
              /*if (isWeb)
                HomeOptionCard(
                  title: l10n.home_purchase,
                  icon: Icons.shopping_cart,
                  onTap: () {
                    context.push('/cattle-purchase');
                  },
                ),
              if (isWeb)
                HomeOptionCard(
                  title: l10n.home_purchaseReception,
                  icon: Icons.inventory,
                  onTap: () {},
                ),
              if (isWeb)
                HomeOptionCard(
                  title: l10n.home_sale,
                  icon: Icons.point_of_sale,
                  onTap: () {},
                ),
              HomeOptionCard(
                title: l10n.home_massiveEvent,
                icon: Icons.event,
                onTap: () {},
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

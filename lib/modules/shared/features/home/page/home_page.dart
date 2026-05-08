import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_with_permission.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:finca_app_frontend/modules/shared/features/home/home_sync_helper_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/shared/features/home/home_sync_helper_io.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<Map<String, dynamic>> _permissionsFuture;
  late final HomeSyncHelper _homeSyncHelper;

  @override
  void initState() {
    super.initState();
    _homeSyncHelper = createHomeSyncHelper();
    _permissionsFuture = SessionService.getPermissions();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _homeSyncHelper.onPostFrame(this),
    );
  }

  @override
  void dispose() {
    _homeSyncHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return KeyedSubtree(
      key: const ValueKey<String>('home-page'),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _permissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return FincaScaffold(
              title: l10n.home_title,
              showHomeButton: false,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final permissions = snapshot.data ?? const <String, dynamic>{};

          return FincaScaffold(
            title: l10n.home_title,
            showHomeButton: false,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _homeSyncHelper.buildSyncSection(context, l10n),
                  Expanded(
                    child: Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          HomeOptionWithPermission(
                            isVisible: true,
                            title: l10n.dashboard_title,
                            icon: Icons.dashboard_outlined,
                            route: "/dashboard",
                            forWebOnly: false,
                          ),
                          HomeOptionWithPermission(
                            isVisible: homeStyleResourceAllowed(
                              permissions,
                              "COMMERCE",
                              "purchases",
                            ),
                            title: l10n.purchase,
                            icon: Icons.shopping_cart,
                            route: "/purchases",
                          ),
                          HomeOptionWithPermission(
                            isVisible: homeStyleResourceAllowed(
                              permissions,
                              "MASSIVE_EVENTS",
                              "massive_events",
                            ),
                            title: l10n.massiveEvent,
                            icon: CupertinoIcons.list_bullet,
                            route: "/massive-events/create",
                            forWebOnly: false,
                          ),
                          HomeOptionWithPermission(
                            isVisible: homeStyleResourceAllowed(
                              permissions,
                              "COMMERCE",
                              "sales",
                            ),
                            title: l10n.sale,
                            icon: Icons.monetization_on,
                            route: "/sales",
                            forWebOnly: true,
                          ),
                          HomeOptionWithPermission(
                            isVisible: homeStyleResourceAllowed(
                              permissions,
                              "EMP_MGMT",
                              "users",
                            ),
                            title: l10n.users,
                            icon: Icons.people,
                            route: "/users",
                            forWebOnly: false,
                          ),
                          HomeOptionWithPermission(
                            isVisible: homeStyleResourceAllowed(
                              permissions,
                              "FARM",
                              "cattle",
                            ),
                            title: l10n.masterListTitle,
                            icon: Icons.table_view,
                            route: "/cattle",
                            forWebOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

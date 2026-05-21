import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/constants/home_layout_breakpoints.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_with_permission.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/shared/features/users/pages/users_list_page.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/pages/purchases_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/pages/devices_list_page.dart';
import 'package:finca_app_frontend/router/route_access.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  /// Solo para tests: el colapso del rail persiste en estático y contaminaría el orden de ejecución.
  @visibleForTesting
  static void resetWideRailCollapseSessionForTesting() {
    _HomePageState.resetWideRailCollapseSessionForTesting();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomeMenuItem {
  const _HomeMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.isVisible,
    this.requiresOnline = false,
  });

  final String id;
  final String title;
  final IconData icon;
  final String route;
  final bool isVisible;

  /// Módulo 100 % online: en móvil solo visible con conexión.
  final bool requiresOnline;
}

class _HomePageState extends State<HomePage> {
  @visibleForTesting
  static void resetWideRailCollapseSessionForTesting() {
    _wideRailUserCollapsedSession = null;
  }

  late final Future<Map<String, dynamic>> _permissionsFuture;
  StreamSubscription<bool>? _onlineSubscription;
  bool _isOnline = true;

  /// Opción activa en layout ancho (sidebar + panel).
  String _wideSelectedId = 'dashboard';

  /// Preferencia de rail en layout **ancho** (web y nativo): memoria por sesión de la app.
  /// - null: solo decide el ancho útil vs [kHomeWebRailExtendedBreakpoint]
  /// - true: forzar compacto (hamburguesa)
  /// - false: forzar extendido si el ancho lo permite
  static bool? _wideRailUserCollapsedSession;

  /// Preferencia explícita del usuario para el rail en modo dashboard (wide).
  bool? _wideRailUserCollapsed;

  @override
  void initState() {
    super.initState();
    _permissionsFuture = SessionService.getPermissions();
    _wideRailUserCollapsed = _wideRailUserCollapsedSession;
    if (!kIsWeb) {
      HomeConnectivityService.isOnline().then((online) {
        if (mounted) setState(() => _isOnline = online);
      });
      _onlineSubscription = HomeConnectivityService.onlineStream().listen((
        online,
      ) {
        if (mounted) setState(() => _isOnline = online);
      });
    }
  }

  @override
  void dispose() {
    _onlineSubscription?.cancel();
    super.dispose();
  }

  List<_HomeMenuItem> _menuItems(
    AppLocalizations l10n,
    Map<String, dynamic> perms,
  ) {
    return [
      _HomeMenuItem(
        id: 'dashboard',
        title: l10n.dashboard_title,
        icon: Icons.dashboard_outlined,
        route: '/dashboard',
        isVisible: true,
        requiresOnline: true,
      ),
      _HomeMenuItem(
        id: 'purchases',
        title: l10n.purchase,
        icon: Icons.shopping_cart,
        route: '/purchases',
        isVisible: homeStyleResourceAllowed(perms, 'COMMERCE', 'purchases'),
        requiresOnline: true,
      ),
      _HomeMenuItem(
        id: 'massive_events',
        title: l10n.massiveEvent,
        icon: CupertinoIcons.list_bullet,
        route: '/massive-events',
        isVisible: homeStyleResourceAllowed(
          perms,
          'MASSIVE_EVENTS',
          'massive_events',
        ),
        requiresOnline: false,
      ),
      _HomeMenuItem(
        id: 'sales',
        title: l10n.sale,
        icon: Icons.monetization_on,
        route: '/sales',
        isVisible: homeStyleResourceAllowed(perms, 'COMMERCE', 'sales'),
        requiresOnline: true,
      ),
      _HomeMenuItem(
        id: 'users',
        title: l10n.users,
        icon: Icons.people,
        route: '/users',
        isVisible: homeStyleResourceAllowed(perms, 'EMP_MGMT', 'users'),
        requiresOnline: true,
      ),
      _HomeMenuItem(
        id: 'cattle',
        title: l10n.masterListTitle,
        icon: FontAwesomeIcons.cow,
        route: '/cattle',
        isVisible: homeStyleResourceAllowed(perms, 'FARM', 'cattle'),
        requiresOnline: true,
      ),
      _HomeMenuItem(
        id: 'equipment_resources',
        title: l10n.equipmentAndResource_title,
        icon: Icons.devices_other_outlined,
        route: '/equipment-resources',
        isVisible: homeStyleResourceAllowed(perms, 'PROD_CENTER', 'devices'),
        requiresOnline: true,
      ),
    ];
  }

  Iterable<_HomeMenuItem> _visibleMenuItems(List<_HomeMenuItem> items) {
    return items.where((e) {
      if (!e.isVisible) return false;
      if (e.requiresOnline && !kIsWeb && !_isOnline) return false;
      return true;
    });
  }

  /// Panel por defecto en layout ancho cuando la selección actual no está visible.
  String _defaultWidePanelId(List<_HomeMenuItem> visible) {
    if (visible.isEmpty) return 'dashboard';
    return visible.first.id;
  }

  /// Título de la barra superior en layout ancho: nombre del módulo activo.
  String _wideShellTitle(
    AppLocalizations l10n,
    List<_HomeMenuItem> visible,
    String panelId,
  ) {
    for (final e in visible) {
      if (e.id == panelId) {
        return e.title;
      }
    }
    return visible.isNotEmpty ? visible.first.title : l10n.home_title;
  }

  /// En **web** siempre se usa el layout tipo dashboard (rail + panel), como en el mockup
  /// ancho, sin depender del viewport.
  bool get _forceWideLayoutOnWeb => PlatformService().isWeb();

  /// Misma regla que el [LayoutBuilder] interno tras `Padding(all: 16)`.
  bool _isWideForHostConstraints(
    BuildContext context,
    BoxConstraints hostConstraints,
  ) {
    if (_forceWideLayoutOnWeb) {
      return true;
    }
    const horizontalPadding = 32.0;
    final maxW =
        hostConstraints.maxWidth.isFinite
            ? hostConstraints.maxWidth
            : MediaQuery.sizeOf(context).width;
    return (maxW - horizontalPadding) >= kHomeWideLayoutBreakpoint;
  }

  Widget _widePanel(String id) {
    switch (id) {
      case 'dashboard':
        return const DashboardPage(embedded: true);
      case 'purchases':
        return const PurchasesListPage(embedded: true);
      case 'massive_events':
        return const MassiveEventListPage(embedded: true);
      case 'sales':
        return const SaleDashboardPage(embedded: true);
      case 'users':
        return const UsersListPage(embedded: true);
      case 'cattle':
        return const CattleMasterListPage(embedded: true);
      case 'equipment_resources':
        return const DevicesListPage(embedded: true);
      default:
        return const DashboardPage(embedded: true);
    }
  }

  bool _isRailExtendedByWidth(BoxConstraints constraints) {
    const horizontalPadding = 32.0;
    final usableW = constraints.maxWidth - horizontalPadding;
    return usableW >= kHomeWebRailExtendedBreakpoint;
  }

  bool _effectiveRailExtended(BoxConstraints constraints) {
    final canExtendByWidth = _isRailExtendedByWidth(constraints);
    if (!canExtendByWidth) return false;
    if (_wideRailUserCollapsed == true) return false;
    return true;
  }

  Widget _buildRailHeader({
    required BuildContext context,
    required bool railExtended,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                key: const ValueKey<String>('home-rail-toggle'),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    // Si estamos extendidos, colapsar. Si estamos compactos, intentar expandir.
                    if (railExtended) {
                      _wideRailUserCollapsed = true;
                    } else {
                      _wideRailUserCollapsed = false;
                    }
                    _wideRailUserCollapsedSession = _wideRailUserCollapsed;
                  });
                },
              ),
              if (railExtended) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Finca App',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ] else ...[
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactRail({
    required BuildContext context,
    required List<_HomeMenuItem> visible,
    required String panelId,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildRailHeader(context: context, railExtended: false),
        Expanded(
          child: ListView(
            key: const ValueKey<String>('home-wide-side-menu-compact'),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final e in visible)
                Tooltip(
                  message: e.title,
                  child: InkWell(
                    key: ValueKey<String>('home-side-item-compact-${e.id}'),
                    onTap: () => setState(() => _wideSelectedId = e.id),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: panelId == e.id
                            ? theme.colorScheme.primaryContainer.withValues(
                              alpha: 0.35,
                            )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        e.icon,
                        color: panelId == e.id ? theme.colorScheme.primary : null,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return KeyedSubtree(
      key: const ValueKey<String>('home-page'),
      child: LayoutBuilder(
        builder: (context, hostConstraints) {
          final shellWide = _isWideForHostConstraints(context, hostConstraints);

          return FutureBuilder<Map<String, dynamic>>(
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
              final items = _menuItems(l10n, permissions);
              final visible = _visibleMenuItems(items).toList();
              final defaultPanelId = _defaultWidePanelId(visible);
              final panelId =
                  visible.any((e) => e.id == _wideSelectedId)
                      ? _wideSelectedId
                      : defaultPanelId;
              if (panelId != _wideSelectedId) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _wideSelectedId = panelId);
                  }
                });
              }

              final appBarTitle =
                  shellWide
                      ? _wideShellTitle(l10n, visible, panelId)
                      : l10n.home_title;

              /// Rail + panel: mismo motivo que [FincaScaffold.navigateToHomeRemovingOverlays]
              /// ante modales — aquí cerramos overlays y solo reseteamos el panel a Dashboard.
              final showShellHomeButton =
                  shellWide && panelId != defaultPanelId;

              return FincaScaffold(
                title: appBarTitle,
                showHomeButton: showShellHomeButton,
                onHomePressed: showShellHomeButton
                    ? () {
                        if (!mounted) return;
                        FincaScaffold.popNavigatorOverlays(context);
                        if (!mounted) return;
                        setState(() => _wideSelectedId = defaultPanelId);
                      }
                    : null,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide =
                          _forceWideLayoutOnWeb ||
                          constraints.maxWidth >= kHomeWideLayoutBreakpoint;

                      if (isWide) {
                        final railExtended = _effectiveRailExtended(constraints);
                        return KeyedSubtree(
                          key: const ValueKey<String>('home-wide-layout'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      width: railExtended
                                          ? kHomeWideRailWidth
                                          : kHomeCompactRailWidth,
                                      child: Material(
                                        elevation: 1,
                                        borderRadius: BorderRadius.circular(12),
                                        clipBehavior: Clip.antiAlias,
                                        child: railExtended
                                            ? Column(
                                              children: [
                                                _buildRailHeader(
                                                  context: context,
                                                  railExtended: true,
                                                ),
                                                Expanded(
                                                  child: ListView(
                                                    key: const ValueKey<String>(
                                                      'home-wide-side-menu',
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                    children: [
                                                      for (final e in visible)
                                                        ListTile(
                                                          key: ValueKey<String>(
                                                            'home-side-item-${e.id}',
                                                          ),
                                                          leading: Icon(e.icon),
                                                          title: Text(e.title),
                                                          selected: panelId == e.id,
                                                          selectedTileColor: Theme.of(
                                                                context,
                                                              )
                                                              .colorScheme
                                                              .primaryContainer
                                                              .withValues(alpha: 0.35),
                                                          onTap: () {
                                                            setState(
                                                              () => _wideSelectedId =
                                                                  e.id,
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                            : _buildCompactRail(
                                              context: context,
                                              visible: visible,
                                              panelId: panelId,
                                            ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 24,
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Expanded(
                                      child: ClipRect(
                                        child: KeyedSubtree(
                                          key: ValueKey<String>(
                                            'home-wide-panel-$panelId',
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                            ),
                                            child: _widePanel(panelId),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return KeyedSubtree(
                        key: const ValueKey<String>('home-compact-layout'),
                        child: Column(
                          children: [
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
                                    route: '/dashboard',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'COMMERCE',
                                      'purchases',
                                    ),
                                    title: l10n.purchase,
                                    icon: Icons.shopping_cart,
                                    route: '/purchases',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'MASSIVE_EVENTS',
                                      'massive_events',
                                    ),
                                    title: l10n.massiveEvent,
                                    icon: CupertinoIcons.list_bullet,
                                    route: '/massive-events',
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'COMMERCE',
                                      'sales',
                                    ),
                                    title: l10n.sale,
                                    icon: Icons.monetization_on,
                                    route: '/sales',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'EMP_MGMT',
                                      'users',
                                    ),
                                    title: l10n.users,
                                    icon: Icons.people,
                                    route: '/users',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'FARM',
                                      'cattle',
                                    ),
                                    title: l10n.masterListTitle,
                                    icon: FontAwesomeIcons.cow,
                                    route: '/cattle',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'PROD_CENTER',
                                      'devices',
                                    ),
                                    title: l10n.equipmentAndResource_title,
                                    icon: Icons.devices_other_outlined,
                                    route: '/equipment-resources',
                                    requiresOnline: true,
                                    online: _isOnline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

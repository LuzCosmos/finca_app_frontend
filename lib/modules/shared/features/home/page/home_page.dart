import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finca_app_frontend/core/services/platform_sevice.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/constants/home_layout_breakpoints.dart';
import 'package:finca_app_frontend/modules/shared/features/home/home_sync_helper_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/shared/features/home/home_sync_helper_io.dart';
import 'package:finca_app_frontend/modules/shared/features/home/widgets/home_option_with_permission.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_page_data_source_mobile_interface.dart'
    if (dart.library.html) 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web_interface.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/shared/features/users/pages/users_list_page.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchases_list_page.dart';
import 'package:finca_app_frontend/router/route_access.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    this.forWebOnly = true,
  });

  final String id;
  final String title;
  final IconData icon;
  final String route;
  final bool isVisible;
  final bool forWebOnly;
}

class _HomePageState extends State<HomePage> {
  late final Future<Map<String, dynamic>> _permissionsFuture;
  late final HomeSyncHelper _homeSyncHelper;

  /// Opción activa en layout ancho (sidebar + panel).
  String _wideSelectedId = 'dashboard';

  /// Estado del rail en web (memoria por sesión). Vive mientras la app está abierta.
  /// - null: automático por ancho
  /// - true: forzar compacto
  /// - false: forzar extendido (si el ancho lo permite)
  static bool? _webRailUserCollapsedSession;

  /// En web: el usuario puede forzar rail compacto/extendido con el botón hamburguesa.
  /// Si es null, el rail sigue el comportamiento automático por ancho.
  bool? _webRailUserCollapsed;

  @override
  void initState() {
    super.initState();
    _homeSyncHelper = createHomeSyncHelper();
    _permissionsFuture = SessionService.getPermissions();
    _webRailUserCollapsed = _webRailUserCollapsedSession;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _homeSyncHelper.onPostFrame(this),
    );
  }

  @override
  void dispose() {
    _homeSyncHelper.dispose();
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
        forWebOnly: false,
      ),
      _HomeMenuItem(
        id: 'purchases',
        title: l10n.purchase,
        icon: Icons.shopping_cart,
        route: '/purchases',
        isVisible: homeStyleResourceAllowed(perms, 'COMMERCE', 'purchases'),
      ),
      _HomeMenuItem(
        id: 'massive_events',
        title: l10n.massiveEvent,
        icon: CupertinoIcons.list_bullet,
        route: '/massive-events/create',
        isVisible: homeStyleResourceAllowed(
          perms,
          'MASSIVE_EVENTS',
          'massive_events',
        ),
        forWebOnly: false,
      ),
      _HomeMenuItem(
        id: 'sales',
        title: l10n.sale,
        icon: Icons.monetization_on,
        route: '/sales',
        isVisible: homeStyleResourceAllowed(perms, 'COMMERCE', 'sales'),
      ),
      _HomeMenuItem(
        id: 'users',
        title: l10n.users,
        icon: Icons.people,
        route: '/users',
        isVisible: homeStyleResourceAllowed(perms, 'EMP_MGMT', 'users'),
        forWebOnly: false,
      ),
      _HomeMenuItem(
        id: 'cattle',
        title: l10n.masterListTitle,
        icon: FontAwesomeIcons.cow,
        route: '/cattle',
        isVisible: homeStyleResourceAllowed(perms, 'FARM', 'cattle'),
      ),
    ];
  }

  Iterable<_HomeMenuItem> _visibleForPlatform(List<_HomeMenuItem> items) {
    final isWeb = PlatformService().isWeb();
    return items.where((e) => e.isVisible && (!e.forWebOnly || isWeb));
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
    return l10n.dashboard_title;
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
        return BlocProvider(
          create:
              (_) => MassiveEventBloc(
                dataSource: createMassiveEventPageDataSource(),
              ),
          child: const MassiveEventPage(embedded: true),
        );
      case 'sales':
        return const SaleDashboardPage(embedded: true);
      case 'users':
        return const UsersListPage(embedded: true);
      case 'cattle':
        return const CattleMasterListPage(embedded: true);
      default:
        return const DashboardPage(embedded: true);
    }
  }

  bool _isWebRailExtended(BoxConstraints constraints) {
    if (!_forceWideLayoutOnWeb) return true;
    const horizontalPadding = 32.0;
    final usableW = constraints.maxWidth - horizontalPadding;
    return usableW >= kHomeWebRailExtendedBreakpoint;
  }

  bool _effectiveWebRailExtended(BoxConstraints constraints) {
    if (!_forceWideLayoutOnWeb) return true;
    final canExtendByWidth = _isWebRailExtended(constraints);
    // Si el viewport es demasiado angosto, no permitimos “expandir” para evitar overflow.
    if (!canExtendByWidth) return false;
    // Si el usuario lo colapsó, mantenemos compacto.
    if (_webRailUserCollapsed == true) return false;
    return true;
  }

  Widget _buildRailHeader({
    required BuildContext context,
    required bool railExtended,
  }) {
    if (!_forceWideLayoutOnWeb) {
      return const SizedBox.shrink();
    }
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
                      _webRailUserCollapsed = true;
                    } else {
                      // Si el ancho lo permite, expandimos; si no, nos quedamos compacto.
                      _webRailUserCollapsed = false;
                    }
                    _webRailUserCollapsedSession = _webRailUserCollapsed;
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

  Widget _buildWebCompactRail({
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
              final visible = _visibleForPlatform(items).toList();
              final panelId =
                  visible.any((e) => e.id == _wideSelectedId)
                      ? _wideSelectedId
                      : 'dashboard';
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
                  shellWide && panelId != 'dashboard';

              return FincaScaffold(
                title: appBarTitle,
                showHomeButton: showShellHomeButton,
                onHomePressed: showShellHomeButton
                    ? () {
                        if (!mounted) return;
                        FincaScaffold.popNavigatorOverlays(context);
                        if (!mounted) return;
                        setState(() => _wideSelectedId = 'dashboard');
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
                        final railExtended =
                            _forceWideLayoutOnWeb
                                ? _effectiveWebRailExtended(constraints)
                                : true;
                        return KeyedSubtree(
                          key: const ValueKey<String>('home-wide-layout'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _homeSyncHelper.buildSyncSection(context, l10n),
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
                                            : _buildWebCompactRail(
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
                                    route: '/dashboard',
                                    forWebOnly: false,
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
                                  ),
                                  HomeOptionWithPermission(
                                    isVisible: homeStyleResourceAllowed(
                                      permissions,
                                      'MASSIVE_EVENTS',
                                      'massive_events',
                                    ),
                                    title: l10n.massiveEvent,
                                    icon: CupertinoIcons.list_bullet,
                                    route: '/massive-events/create',
                                    forWebOnly: false,
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
                                    forWebOnly: true,
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
                                    forWebOnly: false,
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
                                    forWebOnly: true,
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

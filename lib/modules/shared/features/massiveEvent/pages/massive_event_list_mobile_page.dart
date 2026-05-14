import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_date_shortcuts.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_events_page_result.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_mobile_detail_sheet.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_mobile_event_row.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_mobile_filters_card.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_shared_views.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:intl/intl.dart';

import 'massive_event_list_client_filter.dart';
import 'massive_event_list_permissions.dart';
import 'massive_event_list_types.dart';

class _MassiveListState {
  _MassiveListState({
    required this.events,
    required this.error,
    required this.offline,
    required this.canCreate,
    required this.canList,
  });

  final List<MassiveEventModel> events;
  final Object? error;
  final bool offline;
  final bool canCreate;
  final bool canList;
}

class MassiveEventListMobile extends StatefulWidget {
  const MassiveEventListMobile({
    super.key,
    this.embedded = false,
    this.fetchStandaloneOverride,
    this.fetchStandalonePagedOverride,
    this.getPermissionsOverride,
  });

  final bool embedded;

  /// Solo tests **móvil**: lista completa agregada en cliente (filtros en cliente).
  final Future<List<MassiveEventModel>> Function()? fetchStandaloneOverride;

  /// Tests: paginación sin red (scroll infinito / API paginada).
  final MassiveEventsStandalonePagedFetch? fetchStandalonePagedOverride;

  final MassiveEventsGetPermissions? getPermissionsOverride;

  @override
  State<MassiveEventListMobile> createState() => _MassiveEventListMobileState();
}

class _MassiveEventListMobileState extends State<MassiveEventListMobile> {
  static const double _wideListBreakpoint = 560;
  static const double _extraWideListBreakpoint = 800;
  static const int _pagedLimit = 30;

  late Future<_MassiveListState> _legacyFuture;

  final _nameCtrl = TextEditingController();
  final _listScroll = ScrollController();

  DateTime? _from;
  DateTime? _to;
  String _status = 'all';

  bool _bootDone = false;
  bool _canCreate = false;
  bool _canList = false;

  List<MassiveEventModel> _pagedItems = const [];
  bool _pagedLoading = true;
  bool _pagedLoadingMore = false;
  bool _pagedHasMore = false;
  int _pagedPage = 1;
  Object? _pagedError;
  bool _pagedOffline = false;

  bool get _useLegacyList => widget.fetchStandaloneOverride != null;

  @override
  void initState() {
    super.initState();
    if (_useLegacyList) {
      _legacyFuture = _loadLegacy();
    } else {
      _listScroll.addListener(_onScroll);
      _bootstrapPaged();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  MassiveEventStandaloneListQuery get _listQuery =>
      MassiveEventStandaloneListQuery(
        eventFrom: _from,
        eventTo: _to,
        nameTrim: _nameCtrl.text.trim(),
        statusRaw: _status,
      );

  bool get _hasActiveFilters => _listQuery.hasActiveFilters;

  Future<MassiveEventsPageResult> _fetchStandalonePage(int page) async {
    final q = _listQuery;
    final status = q.statusForApi;
    final o = widget.fetchStandalonePagedOverride;
    if (o != null) {
      return o(
        page: page,
        limit: _pagedLimit,
        from: q.fromForApi,
        to: q.toForApi,
        name: q.nameForApi,
        status: status,
        sortBy: 'eventDate',
        sortDir: 'desc',
      );
    }
    return MassiveEventApiService.listStandaloneMassiveEventsPaged(
      page: page,
      limit: _pagedLimit,
      from: q.fromForApi,
      to: q.toForApi,
      name: q.nameForApi,
      status: status,
      sortBy: 'eventDate',
      sortDir: 'desc',
    );
  }

  Future<void> _bootstrapPaged() async {
    final permissions = await massiveEventListResolvePermissions(
      widget.getPermissionsOverride,
    );
    if (!mounted) return;
    final canCreate = massiveEventsBitmaskAllowsCreate(permissions);
    final canList = massiveEventsBitmaskAllowsList(permissions);
    setState(() {
      _canCreate = canCreate;
      _canList = canList;
      _bootDone = true;
    });
    if (canList) {
      await _reloadPaged(reset: true);
    } else {
      setState(() => _pagedLoading = false);
    }
  }

  void _onScroll() {
    if (_useLegacyList || !_canList || _pagedLoading || _pagedLoadingMore) {
      return;
    }
    if (!_pagedHasMore) return;
    final pos = _listScroll.position;
    if (pos.pixels >= pos.maxScrollExtent - 240) {
      _loadMorePaged();
    }
  }

  Future<void> _loadMorePaged() async {
    if (_pagedLoadingMore || !_pagedHasMore) return;
    setState(() => _pagedLoadingMore = true);
    final next = _pagedPage + 1;
    try {
      final res = await _fetchStandalonePage(next);
      if (!mounted) return;
      setState(() {
        _pagedItems = [..._pagedItems, ...res.items];
        _pagedHasMore = res.hasMore;
        _pagedPage = next;
        _pagedLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _pagedLoadingMore = false);
    }
  }

  Future<void> _reloadPaged({required bool reset}) async {
    if (reset) {
      setState(() {
        _pagedLoading = true;
        _pagedError = null;
        _pagedOffline = false;
        _pagedItems = const [];
        _pagedPage = 1;
        _pagedHasMore = false;
      });
    }
    try {
      final res = await _fetchStandalonePage(1);
      if (!mounted) return;
      setState(() {
        _pagedItems = res.items;
        _pagedHasMore = res.hasMore;
        _pagedPage = 1;
        _pagedLoading = false;
        _pagedError = null;
        _pagedOffline = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      final code = ApiExceptionCode.fromString(e.code);
      setState(() {
        _pagedError = e;
        _pagedLoading = false;
        _pagedOffline = code == ApiExceptionCode.serverConnectionError;
      });
    } catch (e) {
      final offline =
          e is SocketException ||
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException');
      if (!mounted) return;
      setState(() {
        _pagedError = e;
        _pagedLoading = false;
        _pagedOffline = offline;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _nameCtrl.clear();
      _status = 'all';
    });
    if (_useLegacyList) {
      _reloadLegacy();
    } else {
      _reloadPaged(reset: true);
    }
  }

  Future<void> _reloadLegacy() async {
    setState(() {
      _legacyFuture = _loadLegacy();
    });
  }

  Future<_MassiveListState> _loadLegacy() async {
    final permissions = await massiveEventListResolvePermissions(
      widget.getPermissionsOverride,
    );
    final canCreate = massiveEventsBitmaskAllowsCreate(permissions);
    final canList = massiveEventsBitmaskAllowsList(permissions);
    if (!canList) {
      return _MassiveListState(
        events: const [],
        error: null,
        offline: false,
        canCreate: canCreate,
        canList: false,
      );
    }
    final q = _listQuery;
    final status = q.statusForApi;
    try {
      var events = await widget.fetchStandaloneOverride!();
      events = filterStandaloneMassiveEventsClient(
        events,
        from: _from,
        to: _to,
        nameTrim: q.nameTrim,
        status: status,
      );
      return _MassiveListState(
        events: events,
        error: null,
        offline: false,
        canCreate: canCreate,
        canList: true,
      );
    } catch (e) {
      final offline =
          e is SocketException ||
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          (e is ApiException &&
              e.code == ApiExceptionCode.serverConnectionError.name);
      return _MassiveListState(
        events: const [],
        error: e,
        offline: offline,
        canCreate: canCreate,
        canList: true,
      );
    }
  }

  String _errorPrimaryMessage(AppLocalizations l10n, Object error) {
    if (error is ApiException) {
      final code = ApiExceptionCode.fromString(error.code);
      return code.asText(context, objectName: l10n.massiveEvent);
    }
    return l10n.massiveEventsListLoadError;
  }

  Widget _buildErrorPanel(AppLocalizations l10n, Object error, bool offline) {
    final theme = Theme.of(context);
    final primary = _errorPrimaryMessage(l10n, error);
    final show422 =
        error is ApiException &&
        ApiExceptionCode.fromString(error.code) ==
            ApiExceptionCode.unprocessableEntity;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              primary,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (show422) ...[
              const SizedBox(height: 8),
              Text(
                l10n.massiveEventsListUnprocessableEntityHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (offline) ...[
              const SizedBox(height: 8),
              Text(
                l10n.massiveEventsListOffline,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed:
                  _useLegacyList
                      ? _reloadLegacy
                      : () => _reloadPaged(reset: true),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFilterCard(AppLocalizations l10n) {
    return MassiveEventStandaloneListMobileFiltersCard(
      l10n: l10n,
      from: _from,
      to: _to,
      nameController: _nameCtrl,
      statusRaw: _status,
      hasActiveFilters: _hasActiveFilters,
      onFromChanged: (d) => setState(() => _from = d),
      onToChanged: (d) => setState(() => _to = d),
      onNameChanged: () => setState(() {}),
      onNameSubmitted:
          _useLegacyList ? _reloadLegacy : () => _reloadPaged(reset: true),
      onStatusChanged: (v) {
        setState(() => _status = v);
        if (_useLegacyList) {
          _reloadLegacy();
        } else {
          _reloadPaged(reset: true);
        }
      },
      onSearch:
          _useLegacyList ? _reloadLegacy : () => _reloadPaged(reset: true),
      onClearFilters: _clearFilters,
      onShortcutToday: () {
        final r = MassiveEventStandaloneListDateShortcuts.todayLocal();
        setState(() {
          _from = r.$1;
          _to = r.$2;
        });
        if (_useLegacyList) {
          _reloadLegacy();
        } else {
          _reloadPaged(reset: true);
        }
      },
      onShortcutThisWeek: () {
        final r = MassiveEventStandaloneListDateShortcuts.thisWeekLocal(context);
        setState(() {
          _from = r.$1;
          _to = r.$2;
        });
        if (_useLegacyList) {
          _reloadLegacy();
        } else {
          _reloadPaged(reset: true);
        }
      },
    );
  }

  Widget _buildEventList(
    AppLocalizations l10n,
    List<MassiveEventModel> events, {
    required bool showTrailingLoader,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final df = DateFormat.yMMMd(locale);
    final dtf = DateFormat.yMMMd(locale).add_Hm();
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall;

    void openDetail(MassiveEventModel e) {
      showMassiveEventStandaloneReadOnlyDetail(
        context,
        l10n: l10n,
        event: e,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideListBreakpoint;
        final extraWide = constraints.maxWidth >= _extraWideListBreakpoint;
        return ListView.separated(
          controller: _useLegacyList ? null : _listScroll,
          itemCount: events.length + (showTrailingLoader ? 1 : 0),
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            if (i >= events.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final e = events[i];
            return MassiveEventStandaloneListMobileEventRow(
              l10n: l10n,
              event: e,
              theme: theme,
              small: small,
              df: df,
              dtf: dtf,
              wide: wide,
              extraWide: extraWide,
              onTap: () => openDetail(e),
            );
          },
        );
      },
    );
  }

  Widget _buildBodyPaged(AppLocalizations l10n) {
    if (!_canList && _canCreate) {
      return MassiveEventStandaloneListNoListPermissionView(l10n: l10n);
    }
    if (!_canList) {
      return MassiveEventStandaloneListGenericLoadErrorView(l10n: l10n);
    }
    if (_pagedLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pagedError != null) {
      return _buildErrorPanel(l10n, _pagedError!, _pagedOffline);
    }
    if (_pagedItems.isEmpty) {
      return MassiveEventStandaloneListEmptyState(
        l10n: l10n,
        hasActiveFilters: _hasActiveFilters,
        canCreate: _canCreate,
        onClearFilters: _clearFilters,
        onCreateMassiveEvent: () => context.push('/massive-events/create'),
        inboxIconSize: 64,
        scrollable: true,
      );
    }
    return _buildEventList(
      l10n,
      _pagedItems,
      showTrailingLoader: _pagedLoadingMore && _pagedHasMore,
    );
  }

  Widget _buildBodyLegacy(AppLocalizations l10n, _MassiveListState s) {
    if (s.error != null) {
      return _buildErrorPanel(l10n, s.error!, s.offline);
    }
    if (!s.canList && s.canCreate) {
      return MassiveEventStandaloneListNoListPermissionView(l10n: l10n);
    }
    if (s.events.isEmpty) {
      return MassiveEventStandaloneListEmptyState(
        l10n: l10n,
        hasActiveFilters: _hasActiveFilters,
        canCreate: s.canCreate,
        onClearFilters: _clearFilters,
        onCreateMassiveEvent: () => context.push('/massive-events/create'),
        inboxIconSize: 64,
        scrollable: true,
      );
    }
    return _buildEventList(l10n, s.events, showTrailingLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_useLegacyList && !_bootDone) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    void goCreate() => context.push('/massive-events/create');

    if (!_useLegacyList) {
      final showFilters = _canList;
      final body = _buildBodyPaged(l10n);
      final padded = Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showFilters) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildMobileFilterCard(l10n),
              ),
              const SizedBox(height: 4),
            ],
            Expanded(child: body),
          ],
        ),
      );
      return _wrapScaffold(
        l10n: l10n,
        canCreate: _canCreate,
        goCreate: goCreate,
        child: padded,
      );
    }

    return FutureBuilder<_MassiveListState>(
      future: _legacyFuture,
      builder: (context, snap) {
        final loading = snap.connectionState != ConnectionState.done;
        final s = snap.data;
        final canCreate = s?.canCreate == true;
        final showFilters = !loading && s != null && s.canList;

        final body =
            loading
                ? const Center(child: CircularProgressIndicator())
                : s == null
                ? MassiveEventStandaloneListGenericLoadErrorView(l10n: l10n)
                : _buildBodyLegacy(l10n, s);

        final padded = Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showFilters) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildMobileFilterCard(l10n),
                ),
                const SizedBox(height: 4),
              ],
              Expanded(child: body),
            ],
          ),
        );

        return _wrapScaffold(
          l10n: l10n,
          canCreate: canCreate,
          goCreate: goCreate,
          child: padded,
        );
      },
    );
  }

  Widget _wrapScaffold({
    required AppLocalizations l10n,
    required bool canCreate,
    required VoidCallback goCreate,
    required Widget child,
  }) {
    if (widget.embedded) {
      return KeyedSubtree(
        key: const ValueKey<String>('massive-event-list-embedded'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (canCreate)
              Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.icon(
                        onPressed: goCreate,
                        icon: const Icon(Icons.add),
                        label: Text(
                          l10n.createSomething(l10n.massiveEvent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: child,
              ),
            ),
          ],
        ),
      );
    }

    return FincaScaffold(
      key: const ValueKey<String>('massive-event-list-page'),
      title: l10n.massiveEventsListTitle,
      body: child,
      floatingActionButton:
          canCreate
              ? FloatingActionButton(
                onPressed: goCreate,
                tooltip: l10n.createSomething(l10n.massiveEvent),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}

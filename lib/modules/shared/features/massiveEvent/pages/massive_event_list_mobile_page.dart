import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_mobile_event_row.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_mobile_filters_card.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:intl/intl.dart';

import 'massive_event_list_client_filter.dart';

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
  });

  final bool embedded;
  final Future<List<MassiveEventModel>> Function()? fetchStandaloneOverride;

  @override
  State<MassiveEventListMobile> createState() => _MassiveEventListMobileState();
}

class _MassiveEventListMobileState extends State<MassiveEventListMobile> {
  /// Ancho mínimo del listado para repartir la fila en columnas (panel ancho / tablet).
  static const double _wideListBreakpoint = 560;

  /// Tercera columna (última modificación aparte) en paneles muy anchos.
  static const double _extraWideListBreakpoint = 800;

  late Future<_MassiveListState> _future;

  final _nameCtrl = TextEditingController();
  DateTime? _from;
  DateTime? _to;
  String _status = 'all';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _nameCtrl.clear();
      _status = 'all';
    });
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _load();
    });
  }

  Future<_MassiveListState> _load() async {
    final permissions = await SessionService.getPermissions();
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
      if (widget.fetchStandaloneOverride != null) {
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
      }
      final events = await MassiveEventApiService.listStandaloneMassiveEvents(
        from: q.fromForApi,
        to: q.toForApi,
        name: q.nameForApi,
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
      onNameSubmitted: _reload,
      onStatusChanged: (v) {
        setState(() => _status = v);
        _reload();
      },
      onSearch: _reload,
      onClearFilters: _clearFilters,
    );
  }

  Widget _buildMobileEmptyState(AppLocalizations l10n, _MassiveListState s) {
    final hasFilters = _hasActiveFilters;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? l10n.noDataFiltered(l10n.massiveEvents)
                  : l10n.noDataSomething(l10n.massiveEvents),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? l10n.tryAdjustFilters
                  : l10n.massiveEvents_createFirstEvent,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  hasFilters
                      ? _clearFilters
                      : (s.canCreate
                          ? () => context.push('/massive-events/create')
                          : null),
              icon: Icon(hasFilters ? Icons.clear : Icons.add),
              label: Text(
                hasFilters
                    ? l10n.clearFilters
                    : l10n.addSomething(l10n.massiveEvent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, _MassiveListState s) {
    if (s.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.massiveEventsListLoadError,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (s.offline) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.massiveEventsListOffline,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              TextButton(onPressed: _reload, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }
    if (!s.canList && s.canCreate) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.massiveEventsNoListPermission,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (s.events.isEmpty) {
      return _buildMobileEmptyState(l10n, s);
    }
    final locale = Localizations.localeOf(context).toString();
    final df = DateFormat.yMMMd(locale);
    final dtf = DateFormat.yMMMd(locale).add_Hm();
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideListBreakpoint;
        final extraWide = constraints.maxWidth >= _extraWideListBreakpoint;
        return ListView.separated(
          itemCount: s.events.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final e = s.events[i];
            return MassiveEventStandaloneListMobileEventRow(
              l10n: l10n,
              event: e,
              theme: theme,
              small: small,
              df: df,
              dtf: dtf,
              wide: wide,
              extraWide: extraWide,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<_MassiveListState>(
      future: _future,
      builder: (context, snap) {
        final loading = snap.connectionState != ConnectionState.done;
        final s = snap.data;
        final canCreate = s?.canCreate == true;
        final showFilters = !loading && s != null && s.canList;

        void goCreate() => context.push('/massive-events/create');

        final body =
            loading
                ? const Center(child: CircularProgressIndicator())
                : s == null
                ? Center(child: Text(l10n.massiveEventsListLoadError))
                : _buildBody(l10n, s);

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
                    child: padded,
                  ),
                ),
              ],
            ),
          );
        }

        return FincaScaffold(
          key: const ValueKey<String>('massive-event-list-page'),
          title: l10n.massiveEventsListTitle,
          body: padded,
          floatingActionButton:
              canCreate
                  ? FloatingActionButton(
                    onPressed: goCreate,
                    tooltip: l10n.createSomething(l10n.massiveEvent),
                    child: const Icon(Icons.add),
                  )
                  : null,
        );
      },
    );
  }
}

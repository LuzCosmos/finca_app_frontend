import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:intl/intl.dart';

/// Sustituye la carga paginada en **web** (tests); misma forma que
/// [MassiveEventApiService.listStandaloneMassiveEventsPaged].
typedef MassiveEventsStandalonePagedFetch =
    Future<MassiveEventsPageResult> Function({
      required int page,
      required int limit,
      String? from,
      String? to,
      String? name,
      required String status,
    });

/// Chip de estado (abierto/cerrado) alineado con la tabla web.
Widget _massiveEventListStatusChip(AppLocalizations l10n, MassiveEventModel e) {
  final open = e.status.toLowerCase() == 'open';
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color:
          open
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: open ? Colors.green : Colors.grey),
    ),
    child: Text(
      open ? l10n.open : l10n.massiveEventsStatusClosedLabel,
      style: TextStyle(
        color: open ? Colors.green[800] : Colors.grey[800],
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

String _massiveEventListDisplayCreatedByUsername(MassiveEventModel e) {
  final u = e.createdByUsername?.trim();
  if (u != null && u.isNotEmpty) return u;
  return '—';
}

/// Misma lógica de filtro que el API (tests con [fetchStandaloneOverride]).
List<MassiveEventModel> _filterMassiveEventsClient(
  List<MassiveEventModel> events, {
  DateTime? from,
  DateTime? to,
  required String nameTrim,
  required String status,
}) {
  final n = nameTrim.toLowerCase();
  return events.where((e) {
    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      if (e.eventDate.isBefore(start)) return false;
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);
      if (e.eventDate.isAfter(end)) return false;
    }
    if (n.isNotEmpty) {
      final id = e.id.toLowerCase();
      final nm = (e.name ?? '').toLowerCase();
      if (!id.contains(n) && !nm.contains(n)) return false;
    }
    if (status != 'all') {
      if (e.status.toLowerCase() != status.toLowerCase()) return false;
    }
    return true;
  }).toList();
}

Widget _massiveEventListDateFilterField(
  BuildContext context,
  String label,
  DateTime? value,
  ValueChanged<DateTime?> onChanged, {
  double? width,
}) {
  final inner = InkWell(
    onTap: () async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: value ?? now,
        firstDate: DateTime(now.year - 5),
        lastDate: DateTime(now.year + 1),
      );
      onChanged(picked);
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      child: Text(
        value == null ? '—' : DateFormat('yyyy/MM/dd').format(value),
      ),
    ),
  );
  if (width != null) {
    return SizedBox(width: width, child: inner);
  }
  return inner;
}

/// Lista de eventos masivos (excluye recepciones en servidor). Punto de entrada del módulo.
///
/// En **web** (`kIsWeb`) el layout sigue el patrón de
/// [PurchasesListPage]: `FincaScaffold`, botón **Crear** con
/// `FilledButton.icon` alineado a la derecha (también en panel embebido),
/// filtros en `Card`, tabla `DataTable`
/// con scroll horizontal y paginación **en servidor** (`page`, `limit`, filtros
/// en query). En **móvil** se usa `ListTile` con la **misma información** que
/// la tabla web y **filtros** (fechas, nombre/id, estado) equivalentes a web.
class MassiveEventListPage extends StatelessWidget {
  const MassiveEventListPage({
    super.key,
    this.embedded = false,
    this.fetchStandaloneOverride,
    this.fetchStandalonePagedOverride,
  });

  final bool embedded;

  /// Solo para tests **móvil**: sustituye la lista autónoma (todas las páginas agregadas).
  final Future<List<MassiveEventModel>> Function()? fetchStandaloneOverride;

  /// Solo para tests **web**: sustituye el GET paginado.
  final MassiveEventsStandalonePagedFetch? fetchStandalonePagedOverride;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MassiveEventListWeb(
        embedded: embedded,
        fetchStandalonePagedOverride: fetchStandalonePagedOverride,
      );
    }
    return MassiveEventListMobile(
      embedded: embedded,
      fetchStandaloneOverride: fetchStandaloneOverride,
    );
  }
}

// --- Móvil / no web (layout original) ----------------------------------------

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
  static const _allowedStatuses = ['all', 'open', 'closed'];

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

  String _coerceStatus(String? s) =>
      _allowedStatuses.contains(s) ? s! : 'all';

  bool get _hasActiveFilters =>
      _from != null ||
      _to != null ||
      _nameCtrl.text.trim().isNotEmpty ||
      _status != 'all';

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
    final fmt = DateFormat('yyyy-MM-dd');
    final fromStr = _from != null ? fmt.format(_from!) : null;
    final toStr = _to != null ? fmt.format(_to!) : null;
    final nameStr =
        _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim();
    final status = _coerceStatus(_status);
    try {
      if (widget.fetchStandaloneOverride != null) {
        var events = await widget.fetchStandaloneOverride!();
        events = _filterMassiveEventsClient(
          events,
          from: _from,
          to: _to,
          nameTrim: _nameCtrl.text.trim(),
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
        from: fromStr,
        to: toStr,
        name: nameStr,
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
    final labels = <String, String>{
      'all': l10n.all,
      'open': l10n.open,
      'closed': l10n.massiveEventsStatusClosedLabel,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _massiveEventListDateFilterField(
                    context,
                    l10n.from,
                    _from,
                    (d) => setState(() => _from = d),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _massiveEventListDateFilterField(
                    context,
                    l10n.to,
                    _to,
                    (d) => setState(() => _to = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.massiveEventsSearchNameOrId,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _reload(),
            ),
            const SizedBox(height: 8),
            Text(l10n.status, style: Theme.of(context).textTheme.labelLarge),
            DropdownButton<String>(
              isExpanded: true,
              value: _coerceStatus(_status),
              items:
                  _allowedStatuses.map((code) {
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(labels[code] ?? code),
                    );
                  }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _status = v);
                _reload();
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_hasActiveFilters)
                  IconButton(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear),
                    tooltip: l10n.clearFilters,
                  ),
                FilledButton.icon(
                  onPressed: _reload,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
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
    return ListView.separated(
      itemCount: s.events.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = s.events[i];
        final title = e.name?.isNotEmpty == true ? e.name! : e.id;
        return ListTile(
          isThreeLine: true,
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${l10n.massiveEventsColumnEventDate}: ${df.format(e.eventDate)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  _massiveEventListStatusChip(l10n, e),
                ],
              ),
              Text(
                '${l10n.massiveEventsColumnCreatedBy}: ${_massiveEventListDisplayCreatedByUsername(e)}',
                style: small,
              ),
              Text(
                '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(e.createdAt)}',
                style: small,
              ),
              Text(
                '${l10n.massiveEventsColumnUpdatedAt}: ${dtf.format(e.updatedAt)}',
                style: small,
              ),
            ],
          ),
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
                Material(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.massiveEventsListTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (canCreate)
                          IconButton(
                            tooltip: l10n.createSomething(l10n.massiveEvent),
                            icon: const Icon(Icons.add),
                            onPressed: goCreate,
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

        return Scaffold(
          key: const ValueKey<String>('massive-event-list-page'),
          appBar: AppBar(title: Text(l10n.massiveEventsListTitle)),
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

// --- Web (mismo patrón que PurchasesListPage) --------------------------------

class MassiveEventListWeb extends StatefulWidget {
  const MassiveEventListWeb({
    super.key,
    this.embedded = false,
    this.fetchStandalonePagedOverride,
  });

  final bool embedded;
  final MassiveEventsStandalonePagedFetch? fetchStandalonePagedOverride;

  @override
  State<MassiveEventListWeb> createState() => _MassiveEventListWebState();
}

class _MassiveEventListWebState extends State<MassiveEventListWeb> {
  static const _allowedStatuses = ['all', 'open', 'closed'];
  static const _allowedPageSizes = [10, 20, 50, 100];

  final _nameCtrl = TextEditingController();
  final _tableHScroll = ScrollController();
  final _tableVScroll = ScrollController();

  DateTime? _from;
  DateTime? _to;
  String _status = 'all';

  int _page = 1;
  int _limit = 10;

  List<MassiveEventModel> _items = const [];
  int _total = 0;
  bool _loading = true;
  String? _error;
  bool _offline = false;

  bool _canCreate = false;
  bool _canList = false;
  bool _bootDone = false;

  String _coerceStatus(String? s) => _allowedStatuses.contains(s) ? s! : 'all';

  int _coerceLimit(int? l) => _allowedPageSizes.contains(l) ? l! : 10;

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tableHScroll.dispose();
    _tableVScroll.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final permissions = await SessionService.getPermissions();
    if (!mounted) return;
    final canCreate = massiveEventsBitmaskAllowsCreate(permissions);
    final canList = massiveEventsBitmaskAllowsList(permissions);
    setState(() {
      _canCreate = canCreate;
      _canList = canList;
      _bootDone = true;
    });
    if (canList) {
      await _load();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _offline = false;
    });
    final l10n = AppLocalizations.of(context)!;
    try {
      final fmt = DateFormat('yyyy-MM-dd');
      final fromStr = _from != null ? fmt.format(_from!) : null;
      final toStr = _to != null ? fmt.format(_to!) : null;
      final nameStr =
          _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim();

      final MassiveEventsPageResult res;
      final pagedFetch = widget.fetchStandalonePagedOverride;
      if (pagedFetch != null) {
        res = await pagedFetch(
          page: _page,
          limit: _limit,
          from: fromStr,
          to: toStr,
          name: nameStr,
          status: _status,
        );
      } else {
        res = await MassiveEventApiService.listStandaloneMassiveEventsPaged(
          page: _page,
          limit: _limit,
          from: fromStr,
          to: toStr,
          name: nameStr,
          status: _status,
        );
      }
      if (!mounted) return;
      setState(() {
        _items = res.items;
        _total = res.total;
      });
    } on ApiException catch (e) {
      final code = ApiExceptionCode.fromString(e.code);
      if (!mounted) return;
      final errorText = code.asText(context, objectName: l10n.massiveEvent);
      setState(() {
        _error = errorText;
        if (code == ApiExceptionCode.serverConnectionError) {
          _offline = true;
        }
      });
    } catch (e) {
      final offline =
          e is SocketException ||
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _offline = offline;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _hasActiveFilters =>
      _from != null ||
      _to != null ||
      _nameCtrl.text.trim().isNotEmpty ||
      _status != 'all';

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _nameCtrl.clear();
      _status = 'all';
      _page = 1;
    });
    _load();
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final hasFilters = _hasActiveFilters;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
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
                    : (_canCreate
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
    );
  }

  Widget _datePicker(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
  ) {
    return _massiveEventListDateFilterField(
      context,
      label,
      value,
      onChanged,
      width: 180,
    );
  }

  /// Anchos de celdas (sin `horizontalMargin` ni `columnSpacing` del [DataTable]).
  static List<double> _webMassiveEventColumnInnerWidths(double usable) {
    const mins = <double>[72, 88, 64, 80, 88, 88];
    const ideals = <double>[104, 220, 92, 124, 136, 136];
    double sum(List<double> x) => x.fold(0.0, (a, b) => a + b);
    final mSum = sum(mins);
    final iSum = sum(ideals);
    if (usable <= 0 || usable <= mSum) {
      return List<double>.from(mins);
    }
    if (usable >= iSum) {
      final scale = usable / iSum;
      return ideals.map((e) => e * scale).toList();
    }
    final t = (usable - mSum) / (iSum - mSum);
    return List.generate(6, (j) => mins[j] + (ideals[j] - mins[j]) * t);
  }

  static double _webMassiveEventDataTableInnerPad(ThemeData theme) {
    final dt = theme.dataTableTheme;
    const nCols = 6;
    final spacing = dt.columnSpacing ?? 16;
    final hMargin = dt.horizontalMargin ?? 24;
    return hMargin * 2 + spacing * (nCols - 1);
  }

  Widget _webMassiveHeaderLabel(String text, double w) {
    return SizedBox(
      width: w,
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _webMassiveCellText(String text, double w) {
    return SizedBox(
      width: w,
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _webMassiveCellStatus(
    AppLocalizations l10n,
    MassiveEventModel e,
    double w,
  ) {
    return SizedBox(
      width: w,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: _massiveEventListStatusChip(l10n, e),
        ),
      ),
    );
  }

  Widget _buildMainBody(AppLocalizations l10n) {
    if (!_canList && _canCreate) {
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

    if (!_canList) {
      return Center(child: Text(l10n.massiveEventsListLoadError));
    }

    final locale = Localizations.localeOf(context).toString();
    final fmt = DateFormat.yMMMd(locale).add_Hm();
    final fmtDate = DateFormat.yMMMd(locale);

    final labels = <String, String>{
      'all': l10n.all,
      'open': l10n.open,
      'closed': l10n.massiveEventsStatusClosedLabel,
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) MessageBanner.error(_error!),
          if (_offline && _error != null) ...[
            const SizedBox(height: 8),
            MessageBanner.info(l10n.massiveEventsListOffline),
          ],
          const SizedBox(height: 8),
          if (_canCreate)
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => context.push('/massive-events/create'),
                icon: const Icon(Icons.add),
                label: Text(l10n.createSomething(l10n.massiveEvent)),
              ),
            ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                runSpacing: 8,
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _datePicker(
                    l10n.from,
                    _from,
                    (d) => setState(() => _from = d),
                  ),
                  _datePicker(l10n.to, _to, (d) => setState(() => _to = d)),
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.massiveEventsSearchNameOrId,
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) {
                        setState(() => _page = 1);
                        _load();
                      },
                    ),
                  ),
                  DropdownButton<String>(
                    value: _coerceStatus(_status),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _status = v;
                        _page = 1;
                      });
                      _load();
                    },
                    items:
                        _allowedStatuses.map((code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(labels[code] ?? code),
                          );
                        }).toList(),
                  ),
                  if (_hasActiveFilters)
                    IconButton(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      tooltip: l10n.clearFilters,
                    ),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() => _page = 1);
                      _load();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.refresh),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _items.isEmpty
                    ? _buildEmptyState(context, l10n)
                    : Card(
                      clipBehavior: Clip.antiAlias,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final theme = Theme.of(context);
                          final innerPad =
                              _webMassiveEventDataTableInnerPad(theme);
                          final availOuter =
                              constraints.hasBoundedWidth
                                  ? constraints.maxWidth
                                  : 800.0;
                          final usableCols =
                              (availOuter - innerPad).clamp(0.0, double.infinity);
                          final cw =
                              _webMassiveEventColumnInnerWidths(usableCols);
                          final contentColsW = cw.fold<double>(
                            0,
                            (a, b) => a + b,
                          );
                          final contentTotalW = contentColsW + innerPad;
                          final needHScroll = contentTotalW > availOuter + 0.5;

                          final spacing =
                              theme.dataTableTheme.columnSpacing ?? 16;
                          final hMargin =
                              theme.dataTableTheme.horizontalMargin ?? 24;

                          final dataTable = DataTable(
                            columnSpacing: spacing,
                            horizontalMargin: hMargin,
                            headingRowColor: WidgetStateProperty.all(
                              theme.colorScheme.surfaceContainerHigh,
                            ),
                            columns: [
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnEventDate,
                                  cw[0],
                                ),
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnName,
                                  cw[1],
                                ),
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.status,
                                  cw[2],
                                ),
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnCreatedBy,
                                  cw[3],
                                ),
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnCreatedAt,
                                  cw[4],
                                ),
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnUpdatedAt,
                                  cw[5],
                                ),
                              ),
                            ],
                            rows:
                                _items
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(
                                            _webMassiveCellText(
                                              fmtDate.format(e.eventDate),
                                              cw[0],
                                            ),
                                          ),
                                          DataCell(
                                            _webMassiveCellText(
                                              e.name?.isNotEmpty == true
                                                  ? e.name!
                                                  : e.id,
                                              cw[1],
                                            ),
                                          ),
                                          DataCell(
                                            _webMassiveCellStatus(
                                              l10n,
                                              e,
                                              cw[2],
                                            ),
                                          ),
                                          DataCell(
                                            _webMassiveCellText(
                                              _massiveEventListDisplayCreatedByUsername(e),
                                              cw[3],
                                            ),
                                          ),
                                          DataCell(
                                            _webMassiveCellText(
                                              fmt.format(e.createdAt),
                                              cw[4],
                                            ),
                                          ),
                                          DataCell(
                                            _webMassiveCellText(
                                              fmt.format(e.updatedAt),
                                              cw[5],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          );

                          final horizontalBlock =
                              needHScroll
                                  ? Scrollbar(
                                    controller: _tableHScroll,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _tableHScroll,
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: contentTotalW,
                                        child: dataTable,
                                      ),
                                    ),
                                  )
                                  : SizedBox(
                                    width: availOuter,
                                    child: dataTable,
                                  );

                          return Scrollbar(
                            controller: _tableVScroll,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _tableVScroll,
                              scrollDirection: Axis.vertical,
                              child: horizontalBlock,
                            ),
                          );
                        },
                      ),
                    ),
          ),
          const SizedBox(height: 8),
          if (_items.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(l10n.rowsPerPage),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _coerceLimit(_limit),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _limit = v;
                          _page = 1;
                        });
                        _load();
                      },
                      items:
                          _allowedPageSizes.map((n) {
                            return DropdownMenuItem<int>(
                              value: n,
                              child: Text('$n'),
                            );
                          }).toList(),
                    ),
                  ],
                ),
                Text(
                  '${l10n.page} $_page / $_pageCount   ($_total ${l10n.results})',
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          _page > 1
                              ? () {
                                setState(() => _page--);
                                _load();
                              }
                              : null,
                      icon: const Icon(Icons.chevron_left),
                      tooltip: l10n.previous,
                    ),
                    IconButton(
                      onPressed:
                          _page < _pageCount
                              ? () {
                                setState(() => _page++);
                                _load();
                              }
                              : null,
                      icon: const Icon(Icons.chevron_right),
                      tooltip: l10n.next,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_bootDone) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final inner = _buildMainBody(l10n);

    if (widget.embedded) {
      return KeyedSubtree(
        key: const ValueKey<String>('massive-event-list-embedded'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.massiveEventsListTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: inner),
          ],
        ),
      );
    }

    return KeyedSubtree(
      key: const ValueKey<String>('massive-event-list-page'),
      child: FincaScaffold(
        title: l10n.massiveEventsListTitle,
        embedded: false,
        body: inner,
      ),
    );
  }
}

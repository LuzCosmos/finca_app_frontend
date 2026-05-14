import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_row_widgets.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_web_filters_bar.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:intl/intl.dart';

import 'massive_event_list_types.dart';

/// Anchos de celdas (sin `horizontalMargin` ni `columnSpacing` del [DataTable]).
List<double> _webMassiveEventColumnInnerWidths(double usable) {
  const mins = <double>[72, 88, 60, 75, 88, 88];
  const ideals = <double>[80, 220, 92, 100, 136, 136];
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

double _webMassiveEventDataTableInnerPad(ThemeData theme) {
  final dt = theme.dataTableTheme;
  const nCols = 6;
  final spacing = dt.columnSpacing ?? 16;
  final hMargin = dt.horizontalMargin ?? 24;
  return hMargin * 2 + spacing * (nCols - 1);
}

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

  MassiveEventStandaloneListQuery get _listQuery =>
      MassiveEventStandaloneListQuery(
        eventFrom: _from,
        eventTo: _to,
        nameTrim: _nameCtrl.text.trim(),
        statusRaw: _status,
      );

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
      final q = _listQuery;

      final MassiveEventsPageResult res;
      final pagedFetch = widget.fetchStandalonePagedOverride;
      if (pagedFetch != null) {
        res = await pagedFetch(
          page: _page,
          limit: _limit,
          from: q.fromForApi,
          to: q.toForApi,
          name: q.nameForApi,
          status: q.statusForApi,
        );
      } else {
        res = await MassiveEventApiService.listStandaloneMassiveEventsPaged(
          page: _page,
          limit: _limit,
          from: q.fromForApi,
          to: q.toForApi,
          name: q.nameForApi,
          status: q.statusForApi,
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

  bool get _hasActiveFilters => _listQuery.hasActiveFilters;

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
          child: MassiveEventListStatusChip(l10n: l10n, event: e),
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
          MassiveEventStandaloneListWebFiltersBar(
            l10n: l10n,
            from: _from,
            to: _to,
            nameController: _nameCtrl,
            statusRaw: _status,
            hasActiveFilters: _hasActiveFilters,
            onFromChanged: (d) => setState(() => _from = d),
            onToChanged: (d) => setState(() => _to = d),
            onNameChanged: () => setState(() {}),
            onNameSubmitted: () {
              setState(() => _page = 1);
              _load();
            },
            onStatusChanged: (v) {
              setState(() {
                _status = v;
                _page = 1;
              });
              _load();
            },
            onSearchPressed: () {
              setState(() => _page = 1);
              _load();
            },
            onClearFilters: _clearFilters,
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
                          final innerPad = _webMassiveEventDataTableInnerPad(
                            theme,
                          );
                          final availOuter =
                              constraints.hasBoundedWidth
                                  ? constraints.maxWidth
                                  : 800.0;
                          final usableCols = (availOuter - innerPad).clamp(
                            0.0,
                            double.infinity,
                          );
                          final cw = _webMassiveEventColumnInnerWidths(
                            usableCols,
                          );
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
                                              massiveEventListDisplayCreatedByUsername(
                                                e,
                                              ),
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
        child: inner,
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

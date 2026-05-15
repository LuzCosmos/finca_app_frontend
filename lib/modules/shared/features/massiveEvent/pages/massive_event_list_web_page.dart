import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_date_shortcuts.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_column_limits.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_events_page_result.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_row_widgets.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_web_filters_bar.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_standalone_list_shared_views.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/router/route_access.dart';
import 'package:intl/intl.dart';

import 'massive_event_list_permissions.dart';
import 'massive_event_list_types.dart';

/// Anchos de celdas (sin `horizontalMargin` ni `columnSpacing` del [DataTable]).
/// [columnCount] 6 sin columna de acciones, 7 con Editar (la columna 6 es ancho fijo).
List<double> _webMassiveEventColumnInnerWidths(double usable, int columnCount) {
  final actionW =
      MassiveEventStandaloneListColumnLimits.webActionsColumnFixedWidth;
  double sum(List<double> x) => x.fold(0.0, (a, b) => a + b);

  if (columnCount < 7) {
    final mins = <double>[72, 88, 60, 75, 88, 88];
    final ideals = <double>[80, 220, 92, 100, 136, 136];
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
    return List.generate(columnCount, (j) => mins[j] + (ideals[j] - mins[j]) * t);
  }

  final sixMins = <double>[72, 88, 60, 75, 88, 88];
  final sixIdeals = <double>[80, 220, 92, 100, 136, 136];
  final m6 = sum(sixMins);
  final i6 = sum(sixIdeals);
  final minTotal = m6 + actionW;
  final idealTotal = i6 + actionW;
  if (usable <= 0 || usable <= minTotal) {
    return List<double>.from([...sixMins, actionW]);
  }
  final usableFlex = usable - actionW;
  if (usable >= idealTotal) {
    final scale = usableFlex / i6;
    return [...sixIdeals.map((e) => e * scale), actionW];
  }
  final t = (usableFlex - m6) / (i6 - m6);
  final first6 = List.generate(
    6,
    (j) => sixMins[j] + (sixIdeals[j] - sixMins[j]) * t,
  );
  return [...first6, actionW];
}

double _webMassiveEventDataTableInnerPad(ThemeData theme, int columnCount) {
  final dt = theme.dataTableTheme;
  final spacing = dt.columnSpacing ?? 16;
  final hMargin = dt.horizontalMargin ?? 24;
  return hMargin * 2 + spacing * (columnCount - 1);
}

class MassiveEventListWeb extends StatefulWidget {
  const MassiveEventListWeb({
    super.key,
    this.embedded = false,
    this.fetchStandalonePagedOverride,
    this.getPermissionsOverride,
  });

  final bool embedded;
  final MassiveEventsStandalonePagedFetch? fetchStandalonePagedOverride;
  final MassiveEventsGetPermissions? getPermissionsOverride;

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

  /// Índice de columna ordenable en [DataTable] (3 = «Creado por» no ordenable).
  int _sortColumnIndex = 0;
  bool _sortAscending = false;

  List<MassiveEventModel> _items = const [];
  int _total = 0;
  bool _loading = true;
  String? _error;
  bool _offline = false;

  bool _canCreate = false;
  bool _canList = false;
  bool _canUpdate = false;
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

  String _sortByForDataColumn(int columnIndex) {
    switch (columnIndex) {
      case 0:
        return 'eventDate';
      case 1:
        return 'name';
      case 2:
        return 'status';
      case 4:
        return 'createdAt';
      case 5:
        return 'updatedAt';
      default:
        return 'eventDate';
    }
  }

  void _onSortDataColumn(int columnIndex, bool ascending) {
    if (columnIndex == 3) {
      return;
    }
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _page = 1;
    });
    _load();
  }

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
    final permissions = await massiveEventListResolvePermissions(
      widget.getPermissionsOverride,
    );
    if (!mounted) return;
    final canCreate = massiveEventsBitmaskAllowsCreate(permissions);
    final canList = massiveEventsBitmaskAllowsList(permissions);
    final canUpdate = massiveEventsBitmaskAllowsUpdate(permissions);
    setState(() {
      _canCreate = canCreate;
      _canList = canList;
      _canUpdate = canUpdate;
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
          sortBy: _sortByForDataColumn(_sortColumnIndex),
          sortDir: _sortAscending ? 'asc' : 'desc',
        );
      } else {
        res = await MassiveEventApiService.listStandaloneMassiveEventsPaged(
          page: _page,
          limit: _limit,
          from: q.fromForApi,
          to: q.toForApi,
          name: q.nameForApi,
          status: q.statusForApi,
          sortBy: _sortByForDataColumn(_sortColumnIndex),
          sortDir: _sortAscending ? 'asc' : 'desc',
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
      var errorText = code.asText(context, objectName: l10n.massiveEvent);
      if (code == ApiExceptionCode.unprocessableEntity) {
        errorText =
            '$errorText\n${l10n.massiveEventsListUnprocessableEntityHint}';
      }
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
          child: MassiveEventListStatusChip(l10n: l10n, event: e, maxWidth: w),
        ),
      ),
    );
  }

  Widget _buildMainBody(AppLocalizations l10n) {
    if (!_canList && _canCreate) {
      return MassiveEventStandaloneListNoListPermissionView(l10n: l10n);
    }

    if (!_canList) {
      return MassiveEventStandaloneListGenericLoadErrorView(l10n: l10n);
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
            onShortcutToday: () {
              final r = MassiveEventStandaloneListDateShortcuts.todayLocal();
              setState(() {
                _from = r.$1;
                _to = r.$2;
                _page = 1;
              });
              _load();
            },
            onShortcutThisWeek: () {
              final r = MassiveEventStandaloneListDateShortcuts.thisWeekLocal(
                context,
              );
              setState(() {
                _from = r.$1;
                _to = r.$2;
                _page = 1;
              });
              _load();
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _items.isEmpty
                    ? MassiveEventStandaloneListEmptyState(
                      l10n: l10n,
                      hasActiveFilters: _hasActiveFilters,
                      canCreate: _canCreate,
                      onClearFilters: _clearFilters,
                      onCreateMassiveEvent:
                          () => context.push('/massive-events/create'),
                      inboxIconSize: 80,
                    )
                    : Card(
                      clipBehavior: Clip.antiAlias,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final theme = Theme.of(context);
                          final colCount = _canUpdate ? 7 : 6;
                          final innerPad = _webMassiveEventDataTableInnerPad(
                            theme,
                            colCount,
                          );
                          final availOuter =
                              constraints.hasBoundedWidth
                                  ? constraints.maxWidth
                                  : 800.0;
                          final usableCols = (availOuter - innerPad).clamp(
                            0.0,
                            double.infinity,
                          );
                          // Si las columnas se redimensionan solo con [usableCols], la suma
                          // encaja en el viewport y casi nunca aparece scroll horizontal.
                          // Forzamos scroll cuando el ancho mínimo “cómodo” supera el disponible.
                          final idealWidths =
                              MassiveEventStandaloneListColumnLimits.webIdealColumnWidths(
                                colCount,
                              );
                          final sortHeaderOverhead =
                              MassiveEventStandaloneListColumnLimits
                                  .webMassiveEventListWebSortHeaderOverhead(
                                    colCount,
                                  );
                          final minComfortContentW =
                              idealWidths.fold<double>(0, (a, b) => a + b) +
                              sortHeaderOverhead;
                          final needHScroll =
                              (minComfortContentW + innerPad) >
                              availOuter + 0.5;
                          var cw =
                              needHScroll
                                  ? List<double>.from(idealWidths)
                                  : _webMassiveEventColumnInnerWidths(
                                    usableCols,
                                    colCount,
                                  );
                          cw =
                              MassiveEventStandaloneListColumnLimits.capWebColumnWidths(
                                cw,
                              );
                          if (!needHScroll) {
                            cw =
                                MassiveEventStandaloneListColumnLimits.expandWebNameColumnOnly(
                                  cw,
                                  usableCols,
                                  columnCount: colCount,
                                );
                          }
                          if (colCount >= 7) {
                            cw =
                                MassiveEventStandaloneListColumnLimits
                                    .lockWebActionsColumnWidth(
                                      cw,
                                    );
                          }
                          final contentColsW =
                              cw.fold<double>(0, (a, b) => a + b) +
                              sortHeaderOverhead;
                          final contentTotalW = contentColsW + innerPad;
                          // Ancho mínimo del bloque: al menos el panel (tabla estirada) o el ancho
                          // intrínseco si la tabla es más ancha → scroll horizontal activo.
                          final tableWidth =
                              availOuter > contentTotalW + 0.5
                                  ? availOuter
                                  : contentTotalW;

                          final spacing =
                              theme.dataTableTheme.columnSpacing ?? 16;
                          final hMargin =
                              theme.dataTableTheme.horizontalMargin ?? 24;

                          final dataTable = DataTable(
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
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
                                onSort: _onSortDataColumn,
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnName,
                                  cw[1],
                                ),
                                onSort: _onSortDataColumn,
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.status,
                                  cw[2],
                                ),
                                onSort: _onSortDataColumn,
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
                                onSort: _onSortDataColumn,
                              ),
                              DataColumn(
                                label: _webMassiveHeaderLabel(
                                  l10n.massiveEventsColumnUpdatedAt,
                                  cw[5],
                                ),
                                onSort: _onSortDataColumn,
                              ),
                              if (_canUpdate)
                                DataColumn(
                                  label: _webMassiveHeaderLabel(
                                    l10n.massiveEventsEdit,
                                    MassiveEventStandaloneListColumnLimits
                                        .webActionsColumnFixedWidth,
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
                                          if (_canUpdate)
                                            DataCell(
                                              SizedBox(
                                                width:
                                                    MassiveEventStandaloneListColumnLimits
                                                        .webActionsColumnFixedWidth,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      e.isOpenForStandaloneListEdit
                                                      ? IconButton(
                                                        icon: Icon(
                                                          Icons.edit_outlined,
                                                          size: 20,
                                                          color: Colors
                                                              .blue
                                                              .shade700,
                                                        ),
                                                        tooltip: l10n
                                                            .massiveEventsEdit,
                                                        onPressed:
                                                            () => context.push(
                                                              '/massive-events/edit?id=${e.id}',
                                                            ),
                                                      )
                                                      : const SizedBox.shrink(),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          );

                          // Horizontal **fuera**, vertical **dentro**: evita que el scroll
                          // vertical robe los gestos del horizontal en web/trackpad.
                          return Scrollbar(
                            controller: _tableHScroll,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _tableHScroll,
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              child: SizedBox(
                                width: tableWidth,
                                child: Scrollbar(
                                  controller: _tableVScroll,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _tableVScroll,
                                    scrollDirection: Axis.vertical,
                                    primary: false,
                                    child: SizedBox(
                                      width: tableWidth,
                                      child: dataTable,
                                    ),
                                  ),
                                ),
                              ),
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

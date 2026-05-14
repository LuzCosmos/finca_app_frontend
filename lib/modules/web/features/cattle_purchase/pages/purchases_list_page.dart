import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/services/purchases_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/purchase_list_item.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/purchase_status.dart';

import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';

class PurchasesListPage extends StatefulWidget {
  final String? initialStatusFilter; // 'all'|'open'|'received'
  final bool embedded;

  const PurchasesListPage({
    super.key,
    this.initialStatusFilter = 'all',
    this.embedded = false,
  });

  @override
  State<PurchasesListPage> createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends State<PurchasesListPage> {
  final _api = PurchasesApiService();
  static const _allowedStatuses = ['all', 'open', 'received'];
  static const _allowedPageSizes = [10, 20, 50, 100];

  // filtros
  DateTime? _from;
  DateTime? _to;
  final _providerCtrl = TextEditingController();
  String _status = 'all';

  // paginación
  int _page = 1;
  int _limit = 10;
  int _total = 0;
  bool _loading = true;
  String? _error;
  String? _info;

  List<PurchaseListItemModel> _items = const [];

  bool _didInit = false;

  String _coerceStatus(String? s) => _allowedStatuses.contains(s) ? s! : 'all';

  int _coerceLimit(int? l) => _allowedPageSizes.contains(l) ? l! : 10;

  Map<String, String> _statusLabels(BuildContext context) => {
    'all': AppLocalizations.of(context)!.all,
    'open': AppLocalizations.of(context)!.purchaseStatusOpen,
    'received': AppLocalizations.of(context)!.purchaseStatusReceived,
  };

  bool _canCreatePurchase = false;
  bool _canUpdateReception = false;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatusFilter ?? 'all';
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasCreatePerm = await SessionService.hasActionPermission(
      'COMMERCE',
      'purchases',
      'create',
    );
    final hasUpdatePerm = await SessionService.hasActionPermission(
      'RECEPTION',
      'receptions',
      'update',
    );
    if (mounted) {
      setState(() {
        _canCreatePurchase = hasCreatePerm;
        _canUpdateReception = hasUpdatePerm;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _status = _coerceStatus(_status);
    _limit = _coerceLimit(_limit);
    if (!_didInit) {
      _didInit = true;
      _load();
    }
  }

  @override
  void dispose() {
    _providerCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = _info = null;
    });
    final l10n = AppLocalizations.of(context)!;
    try {
      final fmt = DateFormat('yyyy-MM-dd');
      final res = await _api.list(
        page: _page,
        limit: _limit,
        from: _from != null ? fmt.format(_from!) : null,
        to: _to != null ? fmt.format(_to!) : null,
        provider:
            _providerCtrl.text.trim().isEmpty
                ? null
                : _providerCtrl.text.trim(),
        status: _status,
      );
      if (mounted) {
        setState(() {
          _items = res.items;
          _total = res.total;
        });
      }
    } on ApiException catch (e) {
      final code = ApiExceptionCode.fromString(e.code);
      if (mounted) {
        final errorText = code.asText(context, objectName: l10n.cattlePurchase);
        setState(() => _error = errorText);
      }
      // (opcional) Log para cazar códigos desconocidos:
      if (code == ApiExceptionCode.unknownError && e.code != 'unknownError') {
        // ignore: avoid_print
        debugPrint('ApiException code desconocido: ${e.code}');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _hasActiveFilters =>
      _from != null ||
      _to != null ||
      _providerCtrl.text.trim().isNotEmpty ||
      _status != 'all';

  void _clearFilters() {
    setState(() {
      _from = null;
      _to = null;
      _providerCtrl.clear();
      _status = 'all';
      _page = 1;
    });
    _load();
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final hasFilters = _hasActiveFilters;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                  ? l10n.noDataFiltered(l10n.cattlePurchase)
                  : l10n.noDataSomething(l10n.cattlePurchase),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? l10n.tryAdjustFilters
                  : l10n.purchases_createFirstPurchase,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  hasFilters
                      ? _clearFilters
                      : (_canCreatePurchase
                          ? () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => const PurchaseFormPage(),
                                  ),
                                )
                                .then((_) => _load());
                          }
                          : null),
              icon: Icon(hasFilters ? Icons.clear : Icons.add),
              label: Text(
                hasFilters
                    ? l10n.clearFilters
                    : l10n.addSomething(l10n.purchase),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final allowedStatuses = const ['all', 'open', 'received'];
    if (!allowedStatuses.contains(_status)) {
      _status = 'all'; // fallback seguro
    }
    final labels = _statusLabels(context);
    return FincaScaffold(
      title: l10n.cattlePurchase,
      embedded: widget.embedded,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (_error != null) MessageBanner.error(_error!),
            if (_info != null) MessageBanner.info(_info!),
            const SizedBox(height: 8),
            if (_canCreatePurchase)
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const PurchaseFormPage(),
                          ),
                        )
                        .then((_) => _load());
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createSomething(l10n.purchase)),
                ),
              ),
            const SizedBox(height: 8),
            // filtros
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
                        controller: _providerCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.provider,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          _page = 1;
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
                        _page = 1;
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
            // tabla
            Expanded(
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isEmpty
                      ? _buildEmptyState(context, l10n)
                      : Card(
                        child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHigh,
                                    ),
                                    columns: [
                                      DataColumn(label: Text(l10n.dateSomething(l10n.purchase))),
                                      DataColumn(label: Text(l10n.provider)),
                                      DataColumn(
                                        label: Text(l10n.totalWeightKg),
                                      ),
                                      DataColumn(
                                        label: Text(l10n.purchase_totalCattle),
                                      ),
                                      DataColumn(label: Text(l10n.countAdjetive(l10n.received))),
                                      DataColumn(label: Text(l10n.status)),
                                      const DataColumn(label: SizedBox()),
                                    ],
                                    rows:
                                        _items
                                            .map(
                                              (p) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      fmt.format(
                                                        p.purchaseDate,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(p.providerName ?? '-'),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      p.totalWeight
                                                          .toStringAsFixed(1),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text('${p.totalCattle}'),
                                                  ),
                                                  DataCell(
                                                    Text('${p.receivedCattle}'),
                                                  ),
                                                  DataCell(
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            p.status ==
                                                                    PurchaseStatus
                                                                        .open
                                                                ? Colors.green
                                                                    .withValues(
                                                                      alpha:
                                                                          0.1,
                                                                    )
                                                                : Colors.grey
                                                                    .withValues(
                                                                      alpha:
                                                                          0.1,
                                                                    ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              p.status ==
                                                                      PurchaseStatus
                                                                          .open
                                                                  ? Colors.green
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        p.status ==
                                                                PurchaseStatus
                                                                    .open
                                                            ? l10n.purchaseStatusOpen
                                                            : l10n.purchaseStatusReceived,
                                                        style: TextStyle(
                                                          color:
                                                              p.status ==
                                                                      PurchaseStatus
                                                                          .open
                                                                  ? Colors
                                                                      .green[800]
                                                                  : Colors
                                                                      .grey[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  DataCell(
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          _canUpdateReception
                                                              ? IconButton(
                                                                tooltip:
                                                                    l10n.reception,
                                                                icon: const Icon(
                                                                  Icons
                                                                      .exit_to_app,
                                                                ),
                                                                onPressed: () async {
                                                                  final result =
                                                                      await context
                                                                          .push(
                                                                            '/purchase/reception/${p.id}',
                                                                          );
                                                                  if (result !=
                                                                          null &&
                                                                      result
                                                                          is Map<
                                                                            String,
                                                                            dynamic
                                                                          > &&
                                                                      mounted) {
                                                                    final updatedReception =
                                                                        result;
                                                                    final purchaseId =
                                                                        updatedReception['purchaseId']
                                                                            as String?;
                                                                    if (purchaseId ==
                                                                        p.id) {
                                                                      setState(() {
                                                                        final index = _items.indexWhere(
                                                                          (i) =>
                                                                              i.id ==
                                                                              purchaseId,
                                                                        );
                                                                        if (index !=
                                                                            -1) {
                                                                          final oldItem =
                                                                              _items[index];
                                                                          final receivedCattle =
                                                                              (updatedReception['receivedCattleCount'] ??
                                                                                      0)
                                                                                  as int;
                                                                          final receivedWeight =
                                                                              double.tryParse(
                                                                                '${updatedReception['receivedTotalWeight'] ?? 0}',
                                                                              ) ??
                                                                              0.0;
                                                                          // Only update received stats, keep total purchased stats same
                                                                          final newItem = PurchaseListItemModel(
                                                                            id:
                                                                                oldItem.id,
                                                                            purchaseDate:
                                                                                oldItem.purchaseDate,
                                                                            providerName:
                                                                                oldItem.providerName,
                                                                            totalCattle:
                                                                                oldItem.totalCattle,
                                                                            totalWeight:
                                                                                oldItem.totalWeight,
                                                                            receivedCattle:
                                                                                receivedCattle,
                                                                            receivedWeight:
                                                                                receivedWeight,
                                                                            status:
                                                                                oldItem.status, // Keep status until refresh
                                                                          );
                                                                          _items[index] =
                                                                              newItem;
                                                                        }
                                                                      });
                                                                    }
                                                                    _load(); // Reload to get potential status change
                                                                  }
                                                                },
                                                              )
                                                              : null,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                      ),
            ),
            const SizedBox(height: 8),

            // paginación
            if (_items.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // tamaño de página
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
                  Text('${l10n.page} $_page / $_pageCount   ($_total ${l10n.results})'),
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
      ),
    );
  }

  Widget _datePicker(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
  ) {
    return SizedBox(
      width: 180,
      child: InkWell(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/services/purchases_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/purchase_list_item.dart';

import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';

class PurchasesListPage extends StatefulWidget {
  final String? initialStatusFilter; // 'all'|'open'|'received'
  const PurchasesListPage({super.key, this.initialStatusFilter = 'all'});

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
  bool _showEmptyInfo = false;

  String _coerceStatus(String? s) => _allowedStatuses.contains(s) ? s! : 'all';

  int _coerceLimit(int? l) => _allowedPageSizes.contains(l) ? l! : 10;

  Map<String, String> _statusLabels(BuildContext context) => {
    'all': AppLocalizations.of(context)!.all,
    'open': AppLocalizations.of(context)!.pending,
    'received': AppLocalizations.of(context)!.received,
  };

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatusFilter ?? 'all';
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
      _showEmptyInfo = false;
    });
    final t = AppLocalizations.of(context)!;
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
      setState(() {
        _items = res.items;
        _total = res.total;
        if (_items.isEmpty) _info = t.noPurchasesFound;
        _showEmptyInfo = _items.isEmpty;
      });
    } on ApiException catch (e) {
      final code = ApiExceptionCode.values.firstWhere(
        (el) => el.name == (e.code ?? ''),
        orElse: () => ApiExceptionCode.unknownError, // <- Fallback seguro
      );

      final errorText = code.asText(context, objectName: t.cattlePurchase);
      setState(() => _error = errorText);

      // (opcional) Log para cazar códigos desconocidos:
      if (code == ApiExceptionCode.unknownError && e.code != 'unknownError') {
        // ignore: avoid_print
        print('ApiException code desconocido: ${e.code}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
      print(e);
    } finally {
      setState(() => _loading = false);
    }
  }

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final fmt = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final allowedStatuses = const ['all', 'open', 'received'];
    if (!allowedStatuses.contains(_status)) {
      _status = 'all'; // fallback seguro
    }
    final labels = _statusLabels(context);
    return FincaScaffold(
      title: t.cattlePurchase,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (_error != null) MessageBanner.error(_error!),
            if (_info != null) MessageBanner.info(_info!),
            const SizedBox(height: 8),
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
                label: Text(t.purchase_create),
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
                      t.from,
                      _from,
                      (d) => setState(() => _from = d),
                    ),
                    _datePicker(t.to, _to, (d) => setState(() => _to = d)),
                    SizedBox(
                      width: 240,
                      child: TextField(
                        controller: _providerCtrl,
                        decoration: InputDecoration(
                          labelText: t.provider,
                          prefixIcon: const Icon(Icons.search),
                        ),
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
                    FilledButton.icon(
                      onPressed: () {
                        _page = 1;
                        _load();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(t.refresh),
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
                      : Card(
                        child:
                            _items.isEmpty
                                ? Center(child: Text(t.noPurchasesFound))
                                : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text(t.purchase_date)),
                                      DataColumn(label: Text(t.provider)),
                                      DataColumn(
                                        label: Text(t.purchase_totalWeightKg),
                                      ),
                                      DataColumn(
                                        label: Text(t.purchase_totalCattle),
                                      ),
                                      DataColumn(label: Text(t.receivedCattle)),
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
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          p.canReceive
                                                              ? FilledButton(
                                                                onPressed: () async {
                                                                  final result = await context.push(
                                                                    '/purchase/reception/${p.id}',
                                                                  );
                                                                  if (result != null && result is Map<String, dynamic> && mounted) {
                                                                      final updatedReception = result;
                                                                      final purchaseId = updatedReception['purchaseId'] as String?;
                                                                      if (purchaseId == p.id) {
                                                                          setState(() {
                                                                            final index = _items.indexWhere((i) => i.id == purchaseId);
                                                                            if (index != -1) {
                                                                              final oldItem = _items[index];
                                                                              final receivedCattle = (updatedReception['receivedCattleCount'] ?? 0) as int;
                                                                              final receivedWeight = double.tryParse('${updatedReception['receivedTotalWeight'] ?? 0}') ?? 0.0;
                                                                              
                                                                              // Only update received stats, keep total purchased stats same
                                                                              final newItem = PurchaseListItemModel(
                                                                                id: oldItem.id,
                                                                                purchaseDate: oldItem.purchaseDate,
                                                                                providerName: oldItem.providerName,
                                                                                totalCattle: oldItem.totalCattle,
                                                                                totalWeight: oldItem.totalWeight,
                                                                                receivedCattle: receivedCattle,
                                                                                receivedWeight: receivedWeight,
                                                                                // Update canReceive if needed (simple check)
                                                                                canReceive: receivedCattle < oldItem.totalCattle, 
                                                                              );
                                                                              _items[index] = newItem;
                                                                            }
                                                                          });
                                                                      }
                                                                  }
                                                                },
                                                                child: Text(
                                                                  t.receiveAction,
                                                                ),
                                                              )
                                                              : Text(
                                                                t.received,
                                                                style:
                                                                    Theme.of(
                                                                          context,
                                                                        )
                                                                        .textTheme
                                                                        .bodyMedium,
                                                              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // tamaño de página
                Row(
                  children: [
                    Text(t.rowsPerPage),
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
                  '${t.page} $_page / $_pageCount   (${_total} ${t.results})',
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
                      tooltip: t.previous,
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
                      tooltip: t.next,
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

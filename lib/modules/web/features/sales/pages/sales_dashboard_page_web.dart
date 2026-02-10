import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web_interface.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

class SaleDashboardPage extends StatelessWidget {
  const SaleDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SalesWebBloc(dataSource: createSalesDataSource())
                ..add(const LoadSalesWeb()),
      child: const _SaleDashboardView(),
    );
  }
}

class _SaleDashboardView extends StatefulWidget {
  const _SaleDashboardView();

  @override
  State<_SaleDashboardView> createState() => _SaleDashboardViewState();
}

class _SaleDashboardViewState extends State<_SaleDashboardView> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool canCreate = false;
  bool canUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final create = await SessionService.hasActionPermission(
      'COMMERCE',
      'sales',
      'create',
    );
    final update = await SessionService.hasActionPermission(
      'COMMERCE',
      'sales',
      'update',
    );
    if (mounted) {
      setState(() {
        canCreate = create;
        canUpdate = update;
      });
    }
  }

  void _applyDateFilter() {
    if (_startDate == null || _endDate == null) return;

    final bloc = context.read<SalesWebBloc>();
    final currentQuery = bloc.state.query;

    bloc.add(
      LoadSalesWeb(
        query: SalesQuery(
          skip: 0,
          take: currentQuery.take,
          orderBy: currentQuery.orderBy,
          order: currentQuery.order,
          startDate: _startDate!.toIso8601String(),
          endDate: _endDate!.toIso8601String(),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });

    final bloc = context.read<SalesWebBloc>();
    bloc.add(LoadSalesWeb(query: SalesQuery(take: bloc.state.query.take)));
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _applyDateFilter();
    }
  }

  void _showEditDialog(
    BuildContext context,
    SaleModel sale,
    AppLocalizations l10n,
  ) {
    final noteController = TextEditingController(text: sale.notes);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.sales_editSale),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${l10n.sales_transactionDate}: ${DateFormat('yyyy-MM-dd').format(sale.transactionDate)}',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: l10n.sales_notes),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.sales_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<SalesWebBloc>().add(
                    UpdateSaleWeb(
                      id: sale.id,
                      updates: {'notes': noteController.text},
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.sales_save),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(
    BuildContext context,
    SaleModel sale,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '${l10n.sales_saleDetails} - ${DateFormat('yyyy-MM-dd').format(sale.transactionDate)}',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${l10n.sales_buyer}: ${_getBuyerName(sale)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${l10n.sales_totalAmount}: ${NumberFormat.currency(symbol: '\$').format(sale.totalAmount)}',
                  ),
                  Text('${l10n.sales_totalWeight}: ${sale.totalWeight} kg'),
                  Text('${l10n.sales_animals}: ${sale.totalCount}'),
                  if (sale.notes != null && sale.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.sales_notes}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(sale.notes!),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.sales_cattleList,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  if (sale.details.isEmpty) Text(l10n.sales_noDetails),
                  ...sale.details.map(
                    (detail) => ListTile(
                      title: Text('${l10n.cattle}# ${detail.cattleNumber}'),
                      subtitle: Text(
                        '${l10n.sales_weight}: ${detail.measuredWeight} kg | ${l10n.sales_price}: ${NumberFormat.currency(symbol: '\$').format(detail.calculatedPrice)}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.sales_close),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<SalesWebBloc, SalesWebState>(
      listener: (context, state) {
        if (state.status == SalesWebStatus.failure && state.error != null) {
          if (state.error!.contains('No session') ||
              state.error!.contains('401')) {
            context.go('/login');
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        }
      },
      child: FincaScaffold(
        title: l10n.sales_title,
        body: BlocBuilder<SalesWebBloc, SalesWebState>(
          builder: (context, state) {
            if (state.status == SalesWebStatus.initial ||
                (state.status == SalesWebStatus.loading &&
                    state.sales == null)) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.sales == null) {
              print(state.error);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ApiExceptionCode.fromString(state.error!).asText(context),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<SalesWebBloc>().add(
                            const LoadSalesWeb(),
                          ),
                      child: Text(l10n.sales_retry),
                    ),
                  ],
                ),
              );
            }

            final sales = state.sales?.items ?? [];
            final total = state.sales?.total ?? 0;
            final query = state.query;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar: Filters and Add Button
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      // Date Range Filter
                      OutlinedButton.icon(
                        onPressed: () => _selectDateRange(context),
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _startDate != null && _endDate != null
                              ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                              : l10n.sales_dateRange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Clear Filters
                      if (_startDate != null || _endDate != null)
                        IconButton(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.clear),
                          tooltip: l10n.sales_clearFilters,
                        ),
                      const Spacer(),
                      // Add Sale Button
                      if (canCreate)
                        ElevatedButton.icon(
                          onPressed: () => context.push('/sales/create'),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.sales_addSale),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),

                // Pagination Controls
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.sales_rowsPerPage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: query.take,
                        items:
                            const [10, 25, 50, 100]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text('$e'),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            context.read<SalesWebBloc>().add(
                              LoadSalesWeb(
                                query: _updateQuery(query, take: val, skip: 0),
                              ),
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed:
                            () => context.read<SalesWebBloc>().add(
                              const LoadSalesWeb(),
                            ),
                        tooltip: l10n.sales_refresh,
                      ),
                      if (state.status == SalesWebStatus.loading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),

                // Table Content - Centered and Expanded
                Expanded(
                  child:
                      sales.isEmpty
                          ? _buildEmptyState(context, l10n)
                          : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1400),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: _buildSalesTable(
                                  context,
                                  sales,
                                  query,
                                  l10n,
                                ),
                              ),
                            ),
                          ),
                ),

                // Pagination Footer
                if (sales.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        top: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.sales_showing} ${query.skip + 1}-${query.skip + sales.length} ${l10n.sales_of} $total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed:
                                  query.skip > 0
                                      ? () => context.read<SalesWebBloc>().add(
                                        LoadSalesWeb(
                                          query: _updateQuery(
                                            query,
                                            skip: query.skip - query.take,
                                          ),
                                        ),
                                      )
                                      : null,
                              tooltip: l10n.sales_previousPage,
                            ),
                            Text(
                              '${l10n.sales_page} ${(query.skip / query.take).floor() + 1} ${l10n.sales_of} ${(total / query.take).ceil() > 0 ? (total / query.take).ceil() : 1}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed:
                                  (query.skip + query.take) < total
                                      ? () => context.read<SalesWebBloc>().add(
                                        LoadSalesWeb(
                                          query: _updateQuery(
                                            query,
                                            skip: query.skip + query.take,
                                          ),
                                        ),
                                      )
                                      : null,
                              tooltip: l10n.sales_nextPage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final hasFilters = _startDate != null || _endDate != null;

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
            hasFilters ? (l10n.sales_noDataFiltered) : (l10n.sales_noData),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? (l10n.sales_tryAdjustFilters)
                : (l10n.sales_createFirstSale),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed:
                hasFilters
                    ? _clearFilters
                    : () => context.push('/sales/create'),
            icon: Icon(hasFilters ? Icons.clear : Icons.add),
            label: Text(
              hasFilters ? (l10n.sales_clearFilters) : (l10n.sales_addSale),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTable(
    BuildContext context,
    List<SaleModel> sales,
    SalesQuery query,
    AppLocalizations l10n,
  ) {
    return Card(
      child: DataTable(
        sortColumnIndex: _getSortColumnIndex(query.orderBy),
        sortAscending: query.order == 'ASC',
        headingRowColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        columns: [
          DataColumn(
            label: Text(l10n.sales_date),
            onSort: (idx, asc) => _onSort(context, 'transactionDate', asc),
          ),
          DataColumn(label: Text(l10n.sales_buyer)),
          DataColumn(label: Text(l10n.sales_items), numeric: true),
          DataColumn(label: Text(l10n.sales_weight), numeric: true),
          DataColumn(
            label: Text(l10n.sales_amount),
            numeric: true,
            onSort: (idx, asc) => _onSort(context, 'totalAmount', asc),
          ),
          DataColumn(label: Text(l10n.sales_actions)),
        ],
        rows:
            sales.map((sale) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      DateFormat('MMM d, yyyy').format(sale.transactionDate),
                    ),
                  ),
                  DataCell(Text(_getBuyerName(sale))),
                  DataCell(Text(sale.totalCount.toString())),
                  DataCell(Text(sale.totalWeight.toStringAsFixed(2))),
                  DataCell(
                    Text(
                      NumberFormat.currency(
                        symbol: '\$',
                      ).format(sale.totalAmount),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, size: 20),
                          onPressed:
                              () => _showDetailsDialog(context, sale, l10n),
                          tooltip: l10n.sales_viewDetails,
                        ),
                        if (canUpdate)
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed:
                                () => _showEditDialog(context, sale, l10n),
                            tooltip: l10n.sales_edit,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  SalesQuery _updateQuery(
    SalesQuery current, {
    int? skip,
    int? take,
    String? orderBy,
    String? order,
  }) {
    return SalesQuery(
      skip: skip ?? current.skip,
      take: take ?? current.take,
      orderBy: orderBy ?? current.orderBy,
      order: order ?? current.order,
      startDate: current.startDate,
      endDate: current.endDate,
      buyerId: current.buyerId,
      status: current.status,
    );
  }

  int? _getSortColumnIndex(String? orderBy) {
    if (orderBy == 'transactionDate') return 0;
    if (orderBy == 'totalAmount') return 4;
    return null;
  }

  void _onSort(BuildContext context, String field, bool ascending) {
    final bloc = context.read<SalesWebBloc>();
    bloc.add(
      LoadSalesWeb(
        query: _updateQuery(
          bloc.state.query,
          orderBy: field,
          order: ascending ? 'ASC' : 'DESC',
        ),
      ),
    );
  }

  String _getBuyerName(SaleModel sale) {
    return sale.buyerName ?? 'Unknown (${sale.buyerId.substring(0, 4)}...)';
  }
}

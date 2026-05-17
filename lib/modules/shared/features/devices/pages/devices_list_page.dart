import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_list_item_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';

typedef DevicesListFetch = Future<List<DeviceListItemModel>> Function();

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({
    super.key,
    this.embedded = false,
    this.fetchListOverride,
  });

  final bool embedded;

  @visibleForTesting
  final DevicesListFetch? fetchListOverride;

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  final _searchCtrl = TextEditingController();

  List<DeviceListItemModel> _allItems = [];
  bool _loading = true;
  String? _error;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _load();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final fetch = widget.fetchListOverride ?? DeviceApiService.listSummary;
      final items = await fetch();
      if (mounted) {
        setState(() => _allItems = items);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final code = ApiExceptionCode.fromString(e.code);
      setState(() {
        _error =
            code == ApiExceptionCode.forbidden
                ? l10n.devicesList_forbidden
                : l10n.devicesList_errorGeneric;
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context)!.devicesList_errorGeneric,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<DeviceListItemModel> get _filteredItems {
    final q = _searchCtrl.text.trim();
    return _allItems.where((d) => d.matchesQuery(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _filteredItems;

    return FincaScaffold(
      title: l10n.devicesList_pageTitle,
      embedded: widget.embedded,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              MessageBanner.error(_error!),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.devicesList_retry),
                ),
              ),
              const SizedBox(height: 8),
            ],
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: l10n.devicesList_searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.devicesList_countLabel(_allItems.length),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(context, l10n, filtered)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<DeviceListItemModel> filtered,
  ) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _allItems.isEmpty) {
      return const SizedBox.shrink();
    }
    if (_allItems.isEmpty) {
      return _EmptyState(l10n: l10n);
    }
    if (filtered.isEmpty) {
      return Center(child: Text(l10n.devicesList_searchHint));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTable = constraints.maxWidth >= 720;
        if (useTable) {
          return _DevicesDataTable(l10n: l10n, items: filtered);
        }
        return _DevicesListView(l10n: l10n, items: filtered);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.devicesList_emptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.devicesList_emptyMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DevicesDataTable extends StatelessWidget {
  const _DevicesDataTable({required this.l10n, required this.items});

  final AppLocalizations l10n;
  final List<DeviceListItemModel> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headingStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final table = DataTable(
      headingRowColor: WidgetStateProperty.all(
        theme.colorScheme.surfaceContainerHigh,
      ),
      headingTextStyle: headingStyle,
      columnSpacing: 24,
      horizontalMargin: 16,
      columns: [
        DataColumn(label: Text(l10n.devicesList_columnName)),
        DataColumn(label: Text(l10n.devicesList_columnDeveui)),
        DataColumn(label: Text(l10n.devicesList_columnActive)),
        DataColumn(label: Text(l10n.devicesList_columnBattery)),
        DataColumn(label: Text(l10n.devicesList_columnProfile)),
      ],
      rows:
          items
              .map(
                (d) => DataRow(
                  cells: [
                    DataCell(Text(d.name)),
                    DataCell(Text(d.deveui)),
                    DataCell(_ActiveChip(l10n: l10n, isActive: d.isActive)),
                    DataCell(Text(_batteryLabel(l10n, d))),
                    DataCell(Text(d.deviceProfileName ?? '—')),
                  ],
                ),
              )
              .toList(),
    );

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(child: table),
          ),
        ),
      ),
    );
  }
}

class _DevicesListView extends StatelessWidget {
  const _DevicesListView({required this.l10n, required this.items});

  final AppLocalizations l10n;
  final List<DeviceListItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final d = items[index];
        return Semantics(
          label: '${d.name}, ${d.deveui}',
          child: ListTile(
            minVerticalPadding: 12,
            title: Text(d.name),
            subtitle: Text(d.deveui),
            trailing: _ActiveChip(l10n: l10n, isActive: d.isActive),
            isThreeLine: true,
            subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.l10n, required this.isActive});

  final AppLocalizations l10n;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg =
        isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest;
    final fg =
        isActive ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;

    return Chip(
      label: Text(isActive ? l10n.devicesList_active : l10n.devicesList_inactive),
      backgroundColor: bg,
      labelStyle: TextStyle(color: fg, fontSize: 12),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}

String _batteryLabel(AppLocalizations l10n, DeviceListItemModel d) {
  final status = d.batteryStatus?.trim();
  if (status == null || status.isEmpty) {
    return l10n.devicesList_noBatteryData;
  }
  return status;
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_by_status_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/services/reports_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/report_metric_card_shell.dart';

class CattleStatusDistributionReportWidget extends StatefulWidget {
  final CattleByStatusReportModel? data;
  final bool? isLoading;
  final bool? hasError;
  final VoidCallback? onRetry;

  const CattleStatusDistributionReportWidget({
    super.key,
    this.data,
    this.isLoading,
    this.hasError,
    this.onRetry,
  });

  bool get _embedded => isLoading != null;

  @override
  State<CattleStatusDistributionReportWidget> createState() =>
      _CattleStatusDistributionReportWidgetState();
}

class _CattleStatusDistributionReportWidgetState
    extends State<CattleStatusDistributionReportWidget> {
  Future<CattleByStatusReportModel>? _standaloneFuture;

  @override
  void initState() {
    super.initState();
    if (!widget._embedded) {
      _standaloneFuture = ReportsApiService.fetchCattleByStatus();
    }
  }

  void _reloadStandalone() {
    setState(() {
      _standaloneFuture = ReportsApiService.fetchCattleByStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget._embedded) {
      return ReportMetricCardShell(
        title: l10n.reports_byStatus_title,
        isLoading: widget.isLoading!,
        hasError: widget.hasError ?? false,
        onRetry: widget.onRetry,
        child: _buildBody(context, l10n, widget.data),
      );
    }

    return ReportMetricCardShell(
      title: l10n.reports_byStatus_title,
      child: FutureBuilder<CattleByStatusReportModel>(
        future: _standaloneFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return SizedBox(
              height: 160,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.reports_general_loadError),
                    TextButton(
                      onPressed: _reloadStandalone,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }
          return _buildBody(context, l10n, snapshot.data);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    CattleByStatusReportModel? data,
  ) {
    if (data == null) {
      return const SizedBox.shrink();
    }
    if (data.totalCount == 0) {
      return SizedBox(
        height: 120,
        child: Center(child: Text(l10n.reports_byStatus_empty)),
      );
    }
    return _CattleByStatusBody(data: data, l10n: l10n);
  }
}

class _CattleByStatusBody extends StatelessWidget {
  final CattleByStatusReportModel data;
  final AppLocalizations l10n;

  const _CattleByStatusBody({required this.data, required this.l10n});

  static const _statusColors = {
    'ACTIVE': Color(0xFF2E7D32),
    'SOLD': Color(0xFF1565C0),
    'DEAD': Color(0xFF616161),
    'LOST': Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slices = <({String key, int count, String label})>[
      (key: 'ACTIVE', count: data.active, label: l10n.reports_status_active),
      (key: 'SOLD', count: data.sold, label: l10n.reports_status_sold),
      (key: 'DEAD', count: data.dead, label: l10n.reports_status_dead),
      (key: 'LOST', count: data.lost, label: l10n.reports_status_lost),
    ].where((s) => s.count > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.reports_byStatus_total(data.totalCount),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 32,
              sections: slices
                  .map(
                    (s) => PieChartSectionData(
                      value: s.count.toDouble(),
                      color: _statusColors[s.key] ?? theme.colorScheme.primary,
                      title: '${s.count}',
                      radius: 42,
                      titleStyle: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: slices
              .map(
                (s) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _statusColors[s.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('${s.label}: ${s.count}'),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_on_feed_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/services/reports_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/report_metric_card_shell.dart';

/// Reporte: reses en cuido vs ACTIVE+SOLD. Modo standalone o embebido (dashboard/summary).
class CattleOnFeedReportWidget extends StatefulWidget {
  final CattleOnFeedReportModel? data;
  final bool? isLoading;
  final bool? hasError;
  final VoidCallback? onRetry;

  const CattleOnFeedReportWidget({
    super.key,
    this.data,
    this.isLoading,
    this.hasError,
    this.onRetry,
  });

  bool get _embedded => isLoading != null;

  @override
  State<CattleOnFeedReportWidget> createState() => _CattleOnFeedReportWidgetState();
}

class _CattleOnFeedReportWidgetState extends State<CattleOnFeedReportWidget> {
  Future<CattleOnFeedReportModel>? _standaloneFuture;

  @override
  void initState() {
    super.initState();
    if (!widget._embedded) {
      _standaloneFuture = ReportsApiService.fetchCattleOnFeed();
    }
  }

  void _reloadStandalone() {
    setState(() {
      _standaloneFuture = ReportsApiService.fetchCattleOnFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget._embedded) {
      return ReportMetricCardShell(
        title: l10n.reports_onFeed_title,
        isLoading: widget.isLoading!,
        hasError: widget.hasError ?? false,
        onRetry: widget.onRetry,
        child: widget.data != null
            ? _CattleOnFeedBody(data: widget.data!, l10n: l10n)
            : const SizedBox.shrink(),
      );
    }

    return ReportMetricCardShell(
      title: l10n.reports_onFeed_title,
      child: FutureBuilder<CattleOnFeedReportModel>(
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
          final data = snapshot.data;
          if (data == null) {
            return const SizedBox.shrink();
          }
          return _CattleOnFeedBody(data: data, l10n: l10n);
        },
      ),
    );
  }
}

class _CattleOnFeedBody extends StatelessWidget {
  final CattleOnFeedReportModel data;
  final AppLocalizations l10n;

  const _CattleOnFeedBody({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = data.activeAndSoldTotal;
    final notOnFeed = (total - data.onFeedCount).clamp(0, total);
    final hasChart = total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasChart)
          SizedBox(
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 36,
                sections: [
                  PieChartSectionData(
                    value: data.onFeedCount.toDouble(),
                    color: theme.colorScheme.primary,
                    title: '${data.onFeedCount}',
                    radius: 44,
                    titleStyle: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: notOnFeed.toDouble(),
                    color: theme.colorScheme.outlineVariant,
                    title: '$notOnFeed',
                    radius: 40,
                    titleStyle: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 80,
            child: Center(
              child: Text(
                l10n.reports_onFeed_empty,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _MetricChip(
              label: l10n.reports_onFeed_onFeed(data.onFeedCount),
              color: theme.colorScheme.primaryContainer,
            ),
            _MetricChip(label: l10n.reports_onFeed_active(data.activeCount)),
            _MetricChip(label: l10n.reports_onFeed_sold(data.soldCount)),
            _MetricChip(label: l10n.reports_onFeed_total(data.activeAndSoldTotal)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.reports_onFeed_legend,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _MetricChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }
}

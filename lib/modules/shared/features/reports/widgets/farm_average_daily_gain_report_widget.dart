import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/farm_average_daily_gain_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/services/reports_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/report_metric_card_shell.dart';

class FarmAverageDailyGainReportWidget extends StatefulWidget {
  final FarmAverageDailyGainReportModel? data;
  final bool? isLoading;
  final bool? hasError;
  final VoidCallback? onRetry;

  const FarmAverageDailyGainReportWidget({
    super.key,
    this.data,
    this.isLoading,
    this.hasError,
    this.onRetry,
  });

  bool get _embedded => isLoading != null;

  @override
  State<FarmAverageDailyGainReportWidget> createState() =>
      _FarmAverageDailyGainReportWidgetState();
}

class _FarmAverageDailyGainReportWidgetState extends State<FarmAverageDailyGainReportWidget> {
  Future<FarmAverageDailyGainReportModel>? _standaloneFuture;

  @override
  void initState() {
    super.initState();
    if (!widget._embedded) {
      _standaloneFuture = ReportsApiService.fetchFarmAverageDailyGain();
    }
  }

  void _reloadStandalone() {
    setState(() {
      _standaloneFuture = ReportsApiService.fetchFarmAverageDailyGain();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget._embedded) {
      final empty = widget.data != null && !widget.data!.hasData;
      return ReportMetricCardShell(
        title: l10n.reports_adg_title,
        isLoading: widget.isLoading!,
        hasError: widget.hasError ?? false,
        onRetry: widget.onRetry,
        child: empty
            ? _AdgEmptyMessage(message: l10n.reports_adg_empty)
            : (widget.data != null
                ? _AdgValueBody(
                    kg: widget.data!.farmAverageDailyGainKg!,
                    l10n: l10n,
                  )
                : const SizedBox.shrink()),
      );
    }

    return ReportMetricCardShell(
      title: l10n.reports_adg_title,
      child: FutureBuilder<FarmAverageDailyGainReportModel>(
        future: _standaloneFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return SizedBox(
              height: 120,
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
          if (data == null || !data.hasData || data.farmAverageDailyGainKg == null) {
            return _AdgEmptyMessage(message: l10n.reports_adg_empty);
          }
          return _AdgValueBody(kg: data.farmAverageDailyGainKg!, l10n: l10n);
        },
      ),
    );
  }
}

class _AdgValueBody extends StatelessWidget {
  final double kg;
  final AppLocalizations l10n;

  const _AdgValueBody({required this.kg, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = kg.toStringAsFixed(3);

    return Column(
      children: [
        Text(
          l10n.reports_adg_value(formatted),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.reports_adg_subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AdgEmptyMessage extends StatelessWidget {
  final String message;

  const _AdgEmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

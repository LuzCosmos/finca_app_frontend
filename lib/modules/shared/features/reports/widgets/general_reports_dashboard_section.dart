import 'package:flutter/material.dart';

import 'package:finca_app_frontend/modules/shared/features/reports/models/general_reports_summary_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/services/reports_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_on_feed_report_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/cattle_status_distribution_report_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/widgets/farm_average_daily_gain_report_widget.dart';

/// Carga un solo `GET .../summary` y reparte datos a los tres widgets (HU dashboard).
class GeneralReportsDashboardSection extends StatefulWidget {
  const GeneralReportsDashboardSection({super.key});

  @override
  State<GeneralReportsDashboardSection> createState() =>
      _GeneralReportsDashboardSectionState();
}

class _GeneralReportsDashboardSectionState extends State<GeneralReportsDashboardSection> {
  late Future<GeneralReportsSummaryModel> _summaryFuture = _loadSummary();

  Future<GeneralReportsSummaryModel> _loadSummary() {
    return ReportsApiService.fetchGeneralReportsSummary();
  }

  void _retry() {
    setState(() {
      _summaryFuture = _loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeneralReportsSummaryModel>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;
        final summary = snapshot.data;

        final embedded = (loading, hasError, summary);

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 3
                : (constraints.maxWidth >= 600 ? 2 : 1);

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: crossAxisCount == 1 ? 1.15 : 0.72,
              children: [
                CattleOnFeedReportWidget(
                  isLoading: embedded.$1,
                  hasError: embedded.$2,
                  onRetry: _retry,
                  data: summary?.cattleOnFeed,
                ),
                CattleStatusDistributionReportWidget(
                  isLoading: embedded.$1,
                  hasError: embedded.$2,
                  onRetry: _retry,
                  data: summary?.cattleByStatus,
                ),
                FarmAverageDailyGainReportWidget(
                  isLoading: embedded.$1,
                  hasError: embedded.$2,
                  onRetry: _retry,
                  data: summary?.farmAverageDailyGain,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

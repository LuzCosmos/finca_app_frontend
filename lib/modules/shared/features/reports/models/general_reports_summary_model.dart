import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_by_status_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_on_feed_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/farm_average_daily_gain_report_model.dart';

class GeneralReportsSummaryModel {
  final CattleOnFeedReportModel cattleOnFeed;
  final CattleByStatusReportModel cattleByStatus;
  final FarmAverageDailyGainReportModel farmAverageDailyGain;

  const GeneralReportsSummaryModel({
    required this.cattleOnFeed,
    required this.cattleByStatus,
    required this.farmAverageDailyGain,
  });

  factory GeneralReportsSummaryModel.fromJson(Map<String, dynamic> json) {
    final onFeedJson = json['cattleOnFeed'] ?? json['cattle_on_feed'];
    final statusJson = json['cattleByStatus'] ?? json['cattle_by_status'];
    final adgJson = json['farmAverageDailyGain'] ?? json['farm_average_daily_gain'];

    return GeneralReportsSummaryModel(
      cattleOnFeed: CattleOnFeedReportModel.fromJson(
        Map<String, dynamic>.from(onFeedJson as Map),
      ),
      cattleByStatus: CattleByStatusReportModel.fromJson(
        Map<String, dynamic>.from(statusJson as Map),
      ),
      farmAverageDailyGain: FarmAverageDailyGainReportModel.fromJson(
        Map<String, dynamic>.from(adgJson as Map),
      ),
    );
  }
}

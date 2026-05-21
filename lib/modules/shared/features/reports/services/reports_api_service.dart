import 'dart:convert';

import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_by_status_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/cattle_on_feed_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/farm_average_daily_gain_report_model.dart';
import 'package:finca_app_frontend/modules/shared/features/reports/models/general_reports_summary_model.dart';

class ReportsApiService {
  static final String _baseUrl = BasicApiService.getApiBaseUrl();
  static const String _generalPrefix = 'reports/general';

  static Future<CattleOnFeedReportModel> fetchCattleOnFeed() async {
    return _getModel(
      '$_generalPrefix/cattle-on-feed',
      CattleOnFeedReportModel.fromJson,
    );
  }

  static Future<CattleByStatusReportModel> fetchCattleByStatus() async {
    return _getModel(
      '$_generalPrefix/cattle-by-status',
      CattleByStatusReportModel.fromJson,
    );
  }

  static Future<FarmAverageDailyGainReportModel> fetchFarmAverageDailyGain() async {
    return _getModel(
      '$_generalPrefix/farm-average-daily-gain',
      FarmAverageDailyGainReportModel.fromJson,
    );
  }

  static Future<GeneralReportsSummaryModel> fetchGeneralReportsSummary() async {
    return _getModel(
      '$_generalPrefix/summary',
      GeneralReportsSummaryModel.fromJson,
    );
  }

  static Future<T> _getModel<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$_baseUrl/$path');
    final response = await BasicApiService.authorizedGet(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return fromJson(body);
    }

    BasicApiService.manageNotSuccessResponseCode(response);
  }
}

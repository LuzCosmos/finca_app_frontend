class FarmAverageDailyGainReportModel {
  final double? farmAverageDailyGainKg;
  final bool hasData;

  const FarmAverageDailyGainReportModel({
    required this.farmAverageDailyGainKg,
    required this.hasData,
  });

  factory FarmAverageDailyGainReportModel.fromJson(Map<String, dynamic> json) {
    final raw = json['farmAverageDailyGainKg'] ?? json['farm_average_daily_gain_kg'];
    double? kg;
    if (raw != null) {
      kg = raw is num ? raw.toDouble() : double.tryParse(raw.toString());
    }
    final hasData = json['hasData'] ?? json['has_data'] ?? (kg != null);
    return FarmAverageDailyGainReportModel(
      farmAverageDailyGainKg: kg,
      hasData: hasData == true,
    );
  }
}

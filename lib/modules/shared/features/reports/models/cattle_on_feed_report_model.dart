class CattleOnFeedReportModel {
  final int onFeedCount;
  final int activeCount;
  final int soldCount;
  final int activeAndSoldTotal;

  const CattleOnFeedReportModel({
    required this.onFeedCount,
    required this.activeCount,
    required this.soldCount,
    required this.activeAndSoldTotal,
  });

  factory CattleOnFeedReportModel.fromJson(Map<String, dynamic> json) {
    return CattleOnFeedReportModel(
      onFeedCount: _asInt(json['onFeedCount'] ?? json['on_feed_count']),
      activeCount: _asInt(json['activeCount'] ?? json['active_count']),
      soldCount: _asInt(json['soldCount'] ?? json['sold_count']),
      activeAndSoldTotal: _asInt(
        json['activeAndSoldTotal'] ?? json['active_and_sold_total'],
      ),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

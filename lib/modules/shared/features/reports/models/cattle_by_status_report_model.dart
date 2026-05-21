class CattleByStatusReportModel {
  final int totalCount;
  final int active;
  final int sold;
  final int dead;
  final int lost;

  const CattleByStatusReportModel({
    required this.totalCount,
    required this.active,
    required this.sold,
    required this.dead,
    required this.lost,
  });

  factory CattleByStatusReportModel.fromJson(Map<String, dynamic> json) {
    final byStatus = json['byStatus'] ?? json['by_status'];
    final map = byStatus is Map<String, dynamic> ? byStatus : <String, dynamic>{};

    final active = _statusCount(map, 'ACTIVE');
    final sold = _statusCount(map, 'SOLD');
    final dead = _statusCount(map, 'DEAD');
    final lost = _statusCount(map, 'LOST');

    return CattleByStatusReportModel(
      totalCount: _asInt(json['totalCount'] ?? json['total_count']) ??
          (active + sold + dead + lost),
      active: active,
      sold: sold,
      dead: dead,
      lost: lost,
    );
  }

  static int _statusCount(Map<String, dynamic> map, String key) {
    return _asInt(map[key]) ?? 0;
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

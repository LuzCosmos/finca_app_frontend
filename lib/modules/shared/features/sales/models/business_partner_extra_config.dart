/// Parses `extraConfig` from business partner API responses.
class BusinessPartnerExtraConfig {
  final double? salesMinWeightKg;

  const BusinessPartnerExtraConfig({this.salesMinWeightKg});

  static BusinessPartnerExtraConfig? fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return null;
    }
    final sales = json['sales'];
    if (sales is! Map) {
      return const BusinessPartnerExtraConfig();
    }
    final raw = sales['minWeightKg'] ?? sales['min_weight_kg'];
    if (raw == null) {
      return const BusinessPartnerExtraConfig();
    }
    final value = raw is num ? raw.toDouble() : double.tryParse(raw.toString());
    if (value == null || value <= 0) {
      return const BusinessPartnerExtraConfig();
    }
    return BusinessPartnerExtraConfig(salesMinWeightKg: value);
  }

  Map<String, dynamic> toCreatePayload() {
    if (salesMinWeightKg == null) {
      return {};
    }
    return {
      'sales': {'minWeightKg': salesMinWeightKg},
    };
  }
}

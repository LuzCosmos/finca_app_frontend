import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';

/// Classifies sale cattle lines against a minimum weight (kg) for bulk reclassification.
class SaleMinWeightClassification {
  SaleMinWeightClassification._();

  static bool isApprovedByMinWeight(double measuredWeightKg, double minWeightKg) {
    return measuredWeightKg >= minWeightKg;
  }

  static double effectiveWeightForPrice(double measuredWeightKg, double minWeightKg) {
    return measuredWeightKg >= minWeightKg ? measuredWeightKg : minWeightKg;
  }

  static double calculatedPriceForWeight(
    double measuredWeightKg,
    double minWeightKg,
    double pricePerKg,
  ) {
    return effectiveWeightForPrice(measuredWeightKg, minWeightKg) * pricePerKg;
  }

  static SaleDetailModel reclassifyDetail({
    required SaleDetailModel detail,
    required double minWeightKg,
    required double pricePerKg,
    required String rejectionReason,
  }) {
    final approved = isApprovedByMinWeight(detail.measuredWeight, minWeightKg);
    return SaleDetailModel(
      id: detail.id,
      saleId: detail.saleId,
      cattleId: detail.cattleId,
      cattleNumber: detail.cattleNumber,
      measuredWeight: detail.measuredWeight,
      calculatedPrice:
          approved
              ? calculatedPriceForWeight(detail.measuredWeight, minWeightKg, pricePerKg)
              : detail.calculatedPrice,
      isApproved: approved,
      rejectionReason: approved ? null : rejectionReason,
      trackerRemoved: detail.trackerRemoved,
    );
  }

  /// Splits [allDetails] into approved/rejected lists using [minWeightKg].
  static ({List<SaleDetailModel> approved, List<SaleDetailModel> rejected}) partition(
    Iterable<SaleDetailModel> allDetails,
    double minWeightKg,
    double pricePerKg,
    String rejectionReason,
  ) {
    final approved = <SaleDetailModel>[];
    final rejected = <SaleDetailModel>[];
    for (final detail in allDetails) {
      final updated = reclassifyDetail(
        detail: detail,
        minWeightKg: minWeightKg,
        pricePerKg: pricePerKg,
        rejectionReason: rejectionReason,
      );
      if (updated.isApproved) {
        approved.add(updated);
      } else {
        rejected.add(updated);
      }
    }
    return (approved: approved, rejected: rejected);
  }
}

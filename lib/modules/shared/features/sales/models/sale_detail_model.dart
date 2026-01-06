import 'package:equatable/equatable.dart';

class SaleDetailModel extends Equatable {
  final String id;
  final String? saleId;
  final String cattleId;
  final String cattleNumber;
  final double measuredWeight;
  final double calculatedPrice;
  final bool isApproved;
  final String? rejectionReason;
  final bool trackerRemoved;

  const SaleDetailModel({
    required this.id,
    this.saleId,
    required this.cattleId,
    required this.cattleNumber,
    required this.measuredWeight,
    required this.calculatedPrice,
    required this.isApproved,
    this.rejectionReason,
    this.trackerRemoved = false,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      id: json['id'],
      saleId: json['sale_id'] ?? json['saleId'],
      cattleId: json['cattle_id'] ?? json['cattleId'],
      cattleNumber: json['cattle_number'] ?? json['cattleNumber'],
      measuredWeight: (json['measured_weight'] ?? json['measuredWeight'] ?? 0).toDouble(),
      calculatedPrice: (json['calculated_price'] ?? json['calculatedPrice'] ?? 0).toDouble(),
      isApproved: json['is_approved'] ?? json['isApproved'] ?? false,
      rejectionReason: json['rejection_reason'] ?? json['rejectionReason'],
      trackerRemoved: json['tracker_removed'] ?? json['trackerRemoved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saleId': saleId,
      'cattleId': cattleId,
      'cattleNumber': cattleNumber,
      'measuredWeight': measuredWeight,
      'calculatedPrice': calculatedPrice,
      'isApproved': isApproved,
      'rejectionReason': rejectionReason,
      'trackerRemoved': trackerRemoved,
    };
  }

  @override
  List<Object?> get props => [
        id,
        saleId,
        cattleId,
        cattleNumber,
        measuredWeight,
        calculatedPrice,
        isApproved,
        rejectionReason,
        trackerRemoved,
      ];
}

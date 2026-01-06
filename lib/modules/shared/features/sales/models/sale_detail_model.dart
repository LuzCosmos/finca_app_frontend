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
      id: json['id'] ?? '',
      saleId: json['sale_id'] ?? json['saleId'],
      cattleId: json['cattle_id'] ?? json['cattleId'] ?? '',
      cattleNumber: json['cattle']['number'] ?? json['cattleNumber'] ?? '',
      measuredWeight: _parseDouble(json['measured_weight'] ?? json['measuredWeight']),
      calculatedPrice: _parseDouble(json['calculated_price'] ?? json['calculatedPrice']),
      isApproved: json['is_approved'] ?? json['isApproved'] ?? false,
      rejectionReason: json['rejection_reason'] ?? json['rejectionReason'],
      trackerRemoved: json['tracker_removed'] ?? json['trackerRemoved'] ?? false,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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

    Map<String, dynamic> toJsonCreate() {
    return {
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

import 'package:equatable/equatable.dart';
import 'sale_detail_model.dart';

class SaleModel extends Equatable {
  final String id;
  final String idTenant;
  final DateTime transactionDate;
  final String buyerId;
  final String? transporterId;
  final double minWeightConfig;
  final double valuePerKgConfig;
  final double totalAmount;
  final double totalWeight;
  final int totalCount;
  final String? notes;
  final List<SaleDetailModel> details;
  final String? buyerName; // Flattened for display
  final String? transporterName;

  const SaleModel({
    required this.id,
    required this.idTenant,
    required this.transactionDate,
    required this.buyerId,
    this.transporterId,
    required this.minWeightConfig,
    required this.valuePerKgConfig,
    required this.totalAmount,
    required this.totalWeight,
    required this.totalCount,
    this.notes,
    this.details = const [],
    this.buyerName,
    this.transporterName,
  });
  
  SaleModel copyWith({
    String? id,
    String? idTenant,
    DateTime? transactionDate,
    String? buyerId,
    String? transporterId,
    double? minWeightConfig,
    double? valuePerKgConfig,
    double? totalAmount,
    double? totalWeight,
    int? totalCount,
    String? notes,
    List<SaleDetailModel>? details,
    String? buyerName,
    String? transporterName,
  }) {
    return SaleModel(
      id: id ?? this.id,
      idTenant: idTenant ?? this.idTenant,
      transactionDate: transactionDate ?? this.transactionDate,
      buyerId: buyerId ?? this.buyerId,
      transporterId: transporterId ?? this.transporterId,
      minWeightConfig: minWeightConfig ?? this.minWeightConfig,
      valuePerKgConfig: valuePerKgConfig ?? this.valuePerKgConfig,
      totalAmount: totalAmount ?? this.totalAmount,
      totalWeight: totalWeight ?? this.totalWeight,
      totalCount: totalCount ?? this.totalCount,
      notes: notes ?? this.notes,
      details: details ?? this.details,
      buyerName: buyerName ?? this.buyerName,
      transporterName: transporterName ?? this.transporterName,
    );
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      idTenant: json['id_tenant'] ?? json['idTenant'] ?? '', // Support snake and camel if needed
      transactionDate: DateTime.tryParse(json['transaction_date'] ?? json['transactionDate'] ?? '') ?? DateTime.now(),
      buyerId: json['buyer_id'] ?? json['buyerId'] ?? '',
      transporterId: json['transporter_id'] ?? json['transporterId'],
      minWeightConfig: _parseDouble(json['min_weight_config'] ?? json['minWeightConfig']),
      valuePerKgConfig: _parseDouble(json['value_per_kg_config'] ?? json['valuePerKgConfig']),
      totalAmount: _parseDouble(json['total_amount'] ?? json['totalAmount']),
      totalWeight: _parseDouble(json['total_weight_kg'] ?? json['totalWeightKg']), // Note: Backend DTO calls it totalWeightKg. Entity totalAmount.
      totalCount: json['total_animal_count'] ?? json['totalAnimalCount'] ?? 0,
      notes: json['notes'],
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => SaleDetailModel.fromJson(e))
          .toList() ?? [],
      buyerName: json['buyer'] != null ? json['buyer']['name'] : null,
      transporterName:
          json['transporter'] != null ? json['transporter']['name'] : null,
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
      'transactionDate': transactionDate.toIso8601String(), // DTO expects camelCase usually? check DTO
      'buyerId': buyerId,
      'transporterId': transporterId,
      'minWeightConfig': minWeightConfig,
      'valuePerKgConfig': valuePerKgConfig,
      'totalAnimalCount': totalCount,
      'totalWeightKg': totalWeight,
      'totalAmount': totalAmount,
      'notes': notes,
      'details': details.map((e) => e.toJson()).toList(),
      // 'idTenant' and 'createdBy' usually injected by backend from token
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'transactionDate': transactionDate.toIso8601String(), // DTO expects camelCase usually? check DTO
      'buyerId': buyerId,
      'transporterId': transporterId,
      'minWeightConfig': minWeightConfig,
      'valuePerKgConfig': valuePerKgConfig,
      'totalAnimalCount': totalCount,
      'totalWeightKg': totalWeight,
      'totalAmount': totalAmount,
      'notes': notes,
      'details': details.map((e) => e.toJsonCreate()).toList(),
      // 'idTenant' and 'createdBy' usually injected by backend from token
    };
  }

  @override
  List<Object?> get props => [
        id,
        idTenant,
        transactionDate,
        buyerId,
        transporterId,
        minWeightConfig,
        valuePerKgConfig,
        totalAmount,
        totalWeight,
        totalCount,
        notes,
        details,
        buyerName,
        transporterName,
      ];
}

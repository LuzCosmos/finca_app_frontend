import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/purchase_status.dart';

class PurchaseListItemModel {
  final String id;
  final DateTime purchaseDate;
  final String? providerName;
  final int totalCattle;
  final double totalWeight;
  final int receivedCattle;
  final double receivedWeight;
  final PurchaseStatus status;

  PurchaseListItemModel({
    required this.id,
    required this.purchaseDate,
    required this.providerName,
    required this.totalCattle,
    required this.totalWeight,
    required this.receivedCattle,
    required this.receivedWeight,
    required this.status,
  });

  factory PurchaseListItemModel.fromJson(Map<String, dynamic> j) =>
      PurchaseListItemModel(
        id: j['id'],
        purchaseDate: DateTime.parse(j['purchaseDate']),
        providerName: j['providerName'],
        totalCattle: (j['totalCattle'] ?? 0) as int,
        totalWeight: double.tryParse('${j['totalWeight'] ?? 0}') ?? 0,
        receivedCattle: (j['receivedCattle'] ?? 0) as int,
        receivedWeight: double.tryParse('${j['receivedWeight'] ?? 0}') ?? 0,
        status: PurchaseStatus.fromString((j['status'] ?? 'OPEN') as String),
      );
}

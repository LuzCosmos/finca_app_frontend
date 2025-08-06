import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/lot.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/provider.dart';

class PurchaseModel {
  final DateTime purchaseDate;
  final ProviderModel provider;
  final List<LotModel> lots;
  final int totalCattle;
  final double totalWeight;
  final double totalValue;

  PurchaseModel({
    required this.purchaseDate,
    required this.provider,
    required this.lots,
    required this.totalCattle,
    required this.totalWeight,
    required this.totalValue,
  });
}

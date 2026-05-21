import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/lot.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';

class PurchaseModel {
  final DateTime purchaseDate;
  final BusinessPartnerModel businessPartner;
  final List<LotModel> lots;
  final int totalCattle;
  final double totalWeight;
  final double totalValue;

  PurchaseModel({
    required this.purchaseDate,
    required this.businessPartner,
    required this.lots,
    required this.totalCattle,
    required this.totalWeight,
    required this.totalValue,
  });
}

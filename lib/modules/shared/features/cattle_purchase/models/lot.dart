import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';

class LotModel {
  final String? id;
  final String lotNumber;
  final String origin;
  final CattleGender gender;
  final double avgWeight;
  final double pricePerKg;
  final int purchasedCattleCount;
  final double totalWeight;
  final double totalValue;
  bool isValid;

  LotModel({
    this.id,
    required this.lotNumber,
    required this.origin,
    required this.purchasedCattleCount,
    required this.gender,
    required this.avgWeight,
    required this.totalWeight,
    required this.pricePerKg,
    required this.totalValue,
    this.isValid = true,
  });

  bool isValidFields2({bool isValid = true}) {
    bool isValidFields =
        lotNumber.isNotEmpty &&
        origin.isNotEmpty &&
        purchasedCattleCount > 0 &&
        avgWeight > 0 &&
        totalWeight > 0 &&
        pricePerKg > 0 &&
        totalValue > 0;
    return isValidFields && isValid;
  }

  void setIsValid(bool isValid) {
    this.isValid = isValid;
  }
}

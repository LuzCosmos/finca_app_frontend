class LotModel {
  final String? id;
  final String lotNumber;
  final String origin;
  final String age;
  final String gender;
  final double avgWeight;
  final double pricePerKg;
  final int cattleCount;
  final double totalWeight;
  final double totalValue;
  bool? isValid;

  LotModel({
    this.id,
    required this.lotNumber,
    required this.origin,
    required this.cattleCount,
    required this.age,
    required this.gender,
    required this.avgWeight,
    required this.totalWeight,
    required this.pricePerKg,
    required this.totalValue,
    this.isValid,
  });

  setIsValid(bool isValid) {
    bool isValidFields =
        lotNumber.isNotEmpty &&
        origin.isNotEmpty &&
        cattleCount > 0 &&
        age.isNotEmpty &&
        gender.isNotEmpty &&
        avgWeight > 0 &&
        totalWeight > 0 &&
        pricePerKg > 0 &&
        totalValue > 0;
    this.isValid = isValidFields && isValid;
  }

  static bool validateList(List<LotModel> lots) {
    List<String> existingLotNumbers = [];
    bool isValidList = true;
    for (var lot in lots) {
      if (existingLotNumbers.contains(lot.lotNumber)) {
        lot.setIsValid(false);
        isValidList = false;
      } else {
        existingLotNumbers.add(lot.lotNumber);
        lot.setIsValid(true);
      }
    }
    return isValidList;
  }
}

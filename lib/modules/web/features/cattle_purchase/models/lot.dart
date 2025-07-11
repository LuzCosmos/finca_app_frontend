class LotModel {
  final String? id;
  final String lotNumber;
  final String origin;
  final String age;
  final String gender; // 'cria', 'levante', etc.
  final double avgWeight;
  final double pricePerKg;
  final int cattleCount;
  final double totalWeight;
  final double totalValue;

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
  });
}

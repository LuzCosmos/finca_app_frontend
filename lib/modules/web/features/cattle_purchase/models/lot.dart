class LotDetail {
  final String lotNumber;
  final String origin;
  final int quantity;
  final String age;
  final String gender; // 'cria', 'levante', etc.
  final double avgWeight;
  final double totalWeight;
  final double pricePerKg;
  final double totalValue;

  LotDetail({
    required this.lotNumber,
    required this.origin,
    required this.quantity,
    required this.age,
    required this.gender,
    required this.avgWeight,
    required this.totalWeight,
    required this.pricePerKg,
    required this.totalValue,
  });
}

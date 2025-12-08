class PurchaseListItemModel {
  final String id;
  final DateTime purchaseDate;
  final String? providerName;
  final int totalCattle;
  final double totalWeight;
  final int receivedCattle;
  final double receivedWeight;
  final bool canReceive;

  PurchaseListItemModel({
    required this.id,
    required this.purchaseDate,
    required this.providerName,
    required this.totalCattle,
    required this.totalWeight,
    required this.receivedCattle,
    required this.receivedWeight,
    required this.canReceive,
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
        canReceive: (j['canReceive'] ?? false) as bool,
      );
}

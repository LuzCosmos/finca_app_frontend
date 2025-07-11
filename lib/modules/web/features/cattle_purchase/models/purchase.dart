import './lot.dart';
import './provider.dart';

class Purchase {
  final DateTime date;
  final ProviderModel provider;
  final List<LotModel> lots;
  final int totalCattle;
  final double totalWeight;
  final double totalValue;

  Purchase({
    required this.date,
    required this.provider,
    required this.lots,
    required this.totalCattle,
    required this.totalWeight,
    required this.totalValue,
  });
}

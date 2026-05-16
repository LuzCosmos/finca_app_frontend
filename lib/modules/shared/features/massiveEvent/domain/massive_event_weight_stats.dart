import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';

/// Estadísticos de peso **actual** en sesión (solo filas con peso numérico).
class MassiveEventWeightSessionStats {
  final int count;
  final double? mean;
  final double? min;
  final double? max;

  const MassiveEventWeightSessionStats({
    required this.count,
    this.mean,
    this.min,
    this.max,
  });

  static const empty = MassiveEventWeightSessionStats(count: 0, mean: null, min: null, max: null);
}

MassiveEventWeightSessionStats computeWeightSessionStats(
  Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap,
) {
  final weights = <double>[];
  for (final row in animalEventsAppliedMap.values) {
    final w = row.weight;
    if (w != null && w > 0) {
      weights.add(w);
    }
  }
  if (weights.isEmpty) {
    return MassiveEventWeightSessionStats.empty;
  }
  weights.sort();
  final sum = weights.fold<double>(0, (a, b) => a + b);
  return MassiveEventWeightSessionStats(
    count: weights.length,
    mean: sum / weights.length,
    min: weights.first,
    max: weights.last,
  );
}

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

/// Resultado de rehidratar un masivo existente (lista → Editar o continuar sesión).
class MassiveSessionLoadResult {
  final MassiveEventModel massive;
  final Map<String, AnimalSimpleEventTableRowModel> animalRows;
  final Map<String, double?> previousWeightByAnimal;

  const MassiveSessionLoadResult({
    required this.massive,
    required this.animalRows,
    this.previousWeightByAnimal = const {},
  });
}

/// Construye filas de tabla a partir de grupos `{ animalNumber, previousWeight, events[] }` (API).
MassiveSessionLoadResult massiveSessionFromAppliedAnimalsJson(
  MassiveEventModel massive,
  Map<String, dynamic> json,
) {
  final prev = <String, double?>{};
  final animals = <String, AnimalSimpleEventTableRowModel>{};
  final groups = json['groups'] as List? ?? const [];
  for (final raw in groups) {
    final m = raw as Map<String, dynamic>;
    final animalNumber = (m['animalNumber'] as String?)?.trim() ?? '';
    if (animalNumber.isEmpty) continue;
    final pw = m['previousWeight'];
    prev[animalNumber] = pw is num ? pw.toDouble() : null;
    final events = (m['events'] as List?) ?? const [];
    final models = <AnimalSimpleEventModel>[];
    for (final e in events) {
      models.add(AnimalSimpleEventModel.fromJson(e as Map<String, dynamic>));
    }
    if (models.isEmpty) continue;
    animals[animalNumber] =
        AnimalSimpleEventTableRowModel.createFromAnimalSimpleEventList(models);
  }
  return MassiveSessionLoadResult(
    massive: massive,
    animalRows: animals,
    previousWeightByAnimal: prev,
  );
}

/// Agrupa modelos de animal por `animalNumber` y construye el mismo resultado que el API.
MassiveSessionLoadResult massiveSessionFromAnimalModels(
  MassiveEventModel massive,
  List<AnimalSimpleEventModel> flat,
  Map<String, double?> previousWeightByAnimal,
) {
  final byAnimal = <String, List<AnimalSimpleEventModel>>{};
  for (final e in flat) {
    byAnimal.putIfAbsent(e.animalNumber, () => []).add(e);
  }
  final animals = <String, AnimalSimpleEventTableRowModel>{};
  for (final entry in byAnimal.entries) {
    animals[entry.key] =
        AnimalSimpleEventTableRowModel.createFromAnimalSimpleEventList(entry.value);
  }
  return MassiveSessionLoadResult(
    massive: massive,
    animalRows: animals,
    previousWeightByAnimal: previousWeightByAnimal,
  );
}

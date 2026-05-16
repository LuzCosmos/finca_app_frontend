import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

/// Incidencia de validación antes de cerrar el masivo (mostrar lista al usuario).
class MassiveEventCloseValidationIssue {
  final String animalNumber;
  /// Clave i18n (sin prefijo @); la UI resuelve con AppLocalizations.
  final String messageKey;

  const MassiveEventCloseValidationIssue({
    required this.animalNumber,
    required this.messageKey,
  });
}

const double _maxWeightKg = 2500;

/// Reglas mínimas alineadas con lo que el backend suele rechazar en cierre/aplicación.
List<MassiveEventCloseValidationIssue> validateMassiveEventBeforeClose({
  required Map<String, AnimalSimpleEventTableRowModel> animalEventsAppliedMap,
  required Set<SimpleEventType> activeSimpleTypes,
}) {
  final issues = <MassiveEventCloseValidationIssue>[];
  final needsWeight = activeSimpleTypes.contains(SimpleEventType.weight);

  for (final entry in animalEventsAppliedMap.entries) {
    final number = entry.key;
    final row = entry.value;
    if (needsWeight) {
      final w = row.weight;
      if (w == null) {
        issues.add(
          MassiveEventCloseValidationIssue(
            animalNumber: number,
            messageKey: 'massiveEventValidationMissingWeight',
          ),
        );
      } else if (w <= 0 || w > _maxWeightKg) {
        issues.add(
          MassiveEventCloseValidationIssue(
            animalNumber: number,
            messageKey: 'massiveEventValidationInvalidWeight',
          ),
        );
      }
    }
  }
  return issues;
}

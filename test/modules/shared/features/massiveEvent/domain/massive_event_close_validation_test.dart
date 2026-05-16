import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_close_validation.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_table_row_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/domain/massive_event_close_validation.dart

void main() {
  group('validateMassiveEventBeforeClose', () {
    test('sin tipo peso activo → sin incidencias aunque falte peso en fila', () {
      final map = {
        '1': AnimalSimpleEventTableRowModel(animalNumber: '1', weight: null),
      };
      final issues = validateMassiveEventBeforeClose(
        animalEventsAppliedMap: map,
        activeSimpleTypes: {SimpleEventType.eartag},
      );
      expect(issues, isEmpty);
    });

    test('tipo peso activo y peso null → missing weight', () {
      final map = {
        '42': AnimalSimpleEventTableRowModel(animalNumber: '42', weight: null),
      };
      final issues = validateMassiveEventBeforeClose(
        animalEventsAppliedMap: map,
        activeSimpleTypes: {SimpleEventType.weight},
      );
      expect(issues, hasLength(1));
      expect(issues.single.animalNumber, '42');
      expect(issues.single.messageKey, 'massiveEventValidationMissingWeight');
    });

    test('peso fuera de rango → invalid weight', () {
      final map = {
        '7': AnimalSimpleEventTableRowModel(animalNumber: '7', weight: 3000),
      };
      final issues = validateMassiveEventBeforeClose(
        animalEventsAppliedMap: map,
        activeSimpleTypes: {SimpleEventType.weight},
      );
      expect(issues.single.messageKey, 'massiveEventValidationInvalidWeight');
    });

    test('peso cero → invalid weight', () {
      final map = {
        '8': AnimalSimpleEventTableRowModel(animalNumber: '8', weight: 0),
      };
      final issues = validateMassiveEventBeforeClose(
        animalEventsAppliedMap: map,
        activeSimpleTypes: {SimpleEventType.weight},
      );
      expect(issues.single.messageKey, 'massiveEventValidationInvalidWeight');
    });

    test('peso válido → sin incidencias', () {
      final map = {
        '7': AnimalSimpleEventTableRowModel(animalNumber: '7', weight: 450.5),
      };
      final issues = validateMassiveEventBeforeClose(
        animalEventsAppliedMap: map,
        activeSimpleTypes: {SimpleEventType.weight},
      );
      expect(issues, isEmpty);
    });
  });
}

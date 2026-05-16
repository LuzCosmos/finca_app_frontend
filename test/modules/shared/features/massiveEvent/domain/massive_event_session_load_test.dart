import 'dart:convert';
import 'dart:io';

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/domain/massive_event_session_load.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('massiveSessionFromAppliedAnimalsJson', () {
    final massive = MassiveEventModel(
      id: 'massive-1',
      idTenant: 'tenant-1',
      eventDate: DateTime(2025, 6, 1),
      status: 'open',
      simpleEvents: const [],
      createdAt: DateTime(2025, 6, 1),
      updatedAt: DateTime(2025, 6, 1),
    );

    test('fixture: previousWeight numérico y null por grupo', () async {
      final path =
          'test/fixtures/massive_event_applied_animals_with_previous_weight.json';
      final json =
          jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;

      final session = massiveSessionFromAppliedAnimalsJson(massive, json);

      expect(session.animalRows.keys, containsAll(['N-100', 'PROV-1']));
      expect(session.previousWeightByAnimal['N-100'], 380);
      expect(session.previousWeightByAnimal['PROV-1'], isNull);
      expect(session.animalRows['N-100']!.weight, 420);
    });

    test('previousWeight ausente en JSON → null en mapa', () {
      final session = massiveSessionFromAppliedAnimalsJson(massive, {
        'groups': [
          {
            'animalNumber': 'X-1',
            'events': [
              {
                'id': 'e1',
                'idTenant': 'tenant-1',
                'animalNumber': 'X-1',
                'type': 'weight',
                'data': {'weight': 400},
                'appliedAt': '2025-06-01T10:00:00.000Z',
                'idMassiveEvent': 'massive-1',
                'idSimpleEvent': 'se-1',
              },
            ],
          },
        ],
      });

      expect(session.previousWeightByAnimal['X-1'], isNull);
    });
  });
}

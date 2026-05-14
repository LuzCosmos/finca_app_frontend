import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_query.dart';

void main() {
  group('MassiveEventStandaloneListQuery', () {
    test('coerceStatus: null o inválido → all', () {
      expect(MassiveEventStandaloneListQuery.coerceStatus(null), 'all');
      expect(MassiveEventStandaloneListQuery.coerceStatus('bogus'), 'all');
    });

    test('coerceStatus: valores API válidos se conservan', () {
      expect(MassiveEventStandaloneListQuery.coerceStatus('open'), 'open');
      expect(MassiveEventStandaloneListQuery.coerceStatus('closed'), 'closed');
      expect(MassiveEventStandaloneListQuery.coerceStatus('all'), 'all');
    });

    test('serialización yyyy-MM-dd y nombre vacío', () {
      final q = MassiveEventStandaloneListQuery(
        eventFrom: DateTime(2024, 3, 5),
        eventTo: DateTime(2024, 12, 1),
        nameTrim: '',
        statusRaw: 'open',
      );
      expect(q.fromForApi, '2024-03-05');
      expect(q.toForApi, '2024-12-01');
      expect(q.nameForApi, isNull);
      expect(q.statusForApi, 'open');
    });

    test('nameForApi solo si hay texto', () {
      final q = MassiveEventStandaloneListQuery(
        eventFrom: null,
        eventTo: null,
        nameTrim: 'abc',
        statusRaw: 'all',
      );
      expect(q.nameForApi, 'abc');
    });

    test('hasActiveFilters', () {
      expect(
        const MassiveEventStandaloneListQuery(
          eventFrom: null,
          eventTo: null,
          nameTrim: '',
          statusRaw: 'all',
        ).hasActiveFilters,
        isFalse,
      );
      expect(
        MassiveEventStandaloneListQuery(
          eventFrom: DateTime(2024),
          eventTo: null,
          nameTrim: '',
          statusRaw: 'all',
        ).hasActiveFilters,
        isTrue,
      );
      expect(
        const MassiveEventStandaloneListQuery(
          eventFrom: null,
          eventTo: null,
          nameTrim: 'x',
          statusRaw: 'all',
        ).hasActiveFilters,
        isTrue,
      );
      expect(
        const MassiveEventStandaloneListQuery(
          eventFrom: null,
          eventTo: null,
          nameTrim: '',
          statusRaw: 'open',
        ).hasActiveFilters,
        isTrue,
      );
    });
  });
}

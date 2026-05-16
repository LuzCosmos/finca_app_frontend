import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_standalone_remote_pages.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_events_page_result.dart';

void main() {
  test('fetchAllStandalonePages delega en pagedFetch hasta hasMore false', () async {
    var calls = 0;
    Future<MassiveEventsPageResult> fake({
      required int page,
      required int limit,
      String? from,
      String? to,
      String? name,
      required String status,
      String? sortBy,
      String? sortDir,
    }) async {
      calls++;
      if (page == 1) {
        return MassiveEventsPageResult(
          1,
          limit,
          3,
          true,
          [
            MassiveEventModel(
              id: '1',
              name: 'Uno',
              eventDate: DateTime(2024),
              simpleEvents: const [],
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ],
        );
      }
      expect(page, 2);
      return MassiveEventsPageResult(
        2,
        limit,
        3,
        false,
        [
          MassiveEventModel(
            id: '2',
            name: 'Dos',
            eventDate: DateTime(2024),
            simpleEvents: const [],
            createdAt: DateTime(2024),
            updatedAt: DateTime(2024),
          ),
        ],
      );
    }

    final all = await MassiveEventStandaloneRemotePages.fetchAllStandalonePages(
      status: 'all',
      pagedFetch: fake,
    );
    expect(calls, 2);
    expect(all.map((e) => e.id).toList(), ['1', '2']);
  });
}

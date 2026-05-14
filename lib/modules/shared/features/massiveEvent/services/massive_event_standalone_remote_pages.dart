import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_events_page_result.dart';

/// Agrega páginas del listado autónomo vía [pagedFetch] (D3: bucle HTTP fuera del cliente delgado).
class MassiveEventStandaloneRemotePages {
  MassiveEventStandaloneRemotePages._();

  static Future<List<MassiveEventModel>> fetchAllStandalonePages({
    String? from,
    String? to,
    String? name,
    String status = 'all',
    String? sortBy,
    String? sortDir,
    required Future<MassiveEventsPageResult> Function({
      required int page,
      required int limit,
      String? from,
      String? to,
      String? name,
      required String status,
      String? sortBy,
      String? sortDir,
    }) pagedFetch,
  }) async {
    final merged = <MassiveEventModel>[];
    var page = 1;
    const batch = 500;
    const maxPages = 200;
    while (page <= maxPages) {
      final chunk = await pagedFetch(
        page: page,
        limit: batch,
        from: from,
        to: to,
        name: name,
        status: status,
        sortBy: sortBy,
        sortDir: sortDir,
      );
      merged.addAll(chunk.items);
      if (!chunk.hasMore) {
        break;
      }
      page++;
    }
    return merged;
  }
}

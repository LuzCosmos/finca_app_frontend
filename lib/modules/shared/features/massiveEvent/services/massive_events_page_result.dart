import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

/// Una página del listado autónomo (`GET /massive-events` paginado).
class MassiveEventsPageResult {
  MassiveEventsPageResult(
    this.page,
    this.limit,
    this.total,
    this.hasMore,
    this.items,
  );

  final int page;
  final int limit;
  final int total;
  final bool hasMore;
  final List<MassiveEventModel> items;
}

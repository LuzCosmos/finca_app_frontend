import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

/// Sustituye la carga paginada en **web** (tests); misma forma que
/// [MassiveEventApiService.listStandaloneMassiveEventsPaged].
typedef MassiveEventsStandalonePagedFetch =
    Future<MassiveEventsPageResult> Function({
      required int page,
      required int limit,
      String? from,
      String? to,
      String? name,
      required String status,
    });

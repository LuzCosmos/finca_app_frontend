import 'package:finca_app_frontend/modules/shared/features/massiveEvent/services/massive_event_api_service.dart';

/// Misma forma que [SessionService.getPermissions]; sustituible en tests (D3 / fase 7).
typedef MassiveEventsGetPermissions = Future<Map<String, dynamic>> Function();

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

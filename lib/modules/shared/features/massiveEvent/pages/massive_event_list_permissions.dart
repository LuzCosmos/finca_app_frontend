import 'package:finca_app_frontend/core/services/session_service.dart';

import 'massive_event_list_types.dart';

/// Resuelve el mapa de permisos: [override] en tests o inyección; si no, sesión real.
Future<Map<String, dynamic>> massiveEventListResolvePermissions(
  MassiveEventsGetPermissions? override,
) =>
    override != null ? override() : SessionService.getPermissions();

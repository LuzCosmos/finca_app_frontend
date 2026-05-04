import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

/// Sesión sin token ni permisos persistidos (útil tras errores de login).
Future<void> expectEmptySession() async {
  expect(await SessionService.getToken(), isNull);
  expect(await SessionService.getRefreshToken(), isNull);
  expect(await SessionService.getIdTenant(), isNull);
  expect(await SessionService.getIdUser(), isNull);
  final perms = await SessionService.getPermissions();
  expect(perms, isEmpty);
}

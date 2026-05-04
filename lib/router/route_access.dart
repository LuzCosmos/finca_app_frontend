/// Reglas de acceso a rutas alineadas con [HomePage] (mismo criterio “truthy”
/// sobre el mapa de permisos). Cubierto por tests unitarios en
/// `test/router/route_access_test.dart` (§5.3).
bool homeStyleResourceAllowed(
  Map<String, dynamic> permissions,
  String module,
  String resource,
) {
  final moduleData = permissions[module];
  if (moduleData is! Map) return false;
  final value = moduleData[resource];
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == 'true' || lower == '1';
  }
  return false;
}

/// Si la ruta [path] requiere permiso y el usuario no lo tiene, devuelve
/// `/home`. Si no aplica restricción o hay permiso, devuelve `null`.
String? routeAccessDeniedRedirect({
  required String path,
  required Map<String, dynamic> permissions,
}) {
  String? module;
  String? resource;

  if (path.startsWith('/massive-events')) {
    module = 'MASSIVE_EVENTS';
    resource = 'massive_events';
  } else if (path.startsWith('/sales')) {
    module = 'COMMERCE';
    resource = 'sales';
  } else if (path.startsWith('/cattle')) {
    module = 'FARM';
    resource = 'cattle';
  } else if (path.startsWith('/users')) {
    module = 'EMP_MGMT';
    resource = 'users';
  } else if (path.startsWith('/purchase/reception') ||
      path.startsWith('/purchases')) {
    module = 'COMMERCE';
    resource = 'purchases';
  }

  if (module == null || resource == null) return null;
  if (homeStyleResourceAllowed(permissions, module, resource)) {
    return null;
  }
  return '/home';
}

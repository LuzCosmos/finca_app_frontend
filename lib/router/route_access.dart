/// Reglas de acceso a rutas alineadas con [HomePage]. El backend usa máscaras
/// CRUDL de 5 bits por recurso (p. ej. `"11111"`), no solo `"true"`/`"1"`.
/// Cubierto por `test/router/route_access_test.dart` (§5.3).
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
    if (lower == 'true' || lower == '1') return true;
    // Máscara binaria (CRUDL u homóloga): al menos un `1` ⇒ hay acceso al módulo.
    if (value.isNotEmpty &&
        RegExp(r'^[01]+$').hasMatch(value) &&
        value.contains('1')) {
      return true;
    }
    return false;
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

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

/// Bitmask CRUDL del recurso `massive_events` (posición 0 = create, 4 = list).
/// Ver `docs/features/01-auth-module.md` §6.1.
bool massiveEventsBitmaskAllowsCreate(Map<String, dynamic> permissions) {
  return _massiveEventsBitmaskBit(permissions, 0);
}

bool massiveEventsBitmaskAllowsList(Map<String, dynamic> permissions) {
  return _massiveEventsBitmaskBit(permissions, 4);
}

bool massiveEventsBitmaskAllowsUpdate(Map<String, dynamic> permissions) {
  return _massiveEventsBitmaskBit(permissions, 2);
}

/// Bit 2 (update) del CRUDL de `COMMERCE` / `purchases`.
bool commercePurchasesAllowsUpdate(Map<String, dynamic> permissions) {
  return _commercePurchasesCrudlBit(permissions, 2);
}

/// Bit 2 (update) del CRUDL de `COMMERCE` / `sales`.
bool commerceSalesAllowsUpdate(Map<String, dynamic> permissions) {
  return _commerceSalesCrudlBit(permissions, 2);
}

bool _commerceSalesCrudlBit(Map<String, dynamic> permissions, int index) {
  final moduleData = permissions['COMMERCE'];
  if (moduleData is! Map) return false;
  final value = moduleData['sales'];
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    final normalized = _normalizeMassiveEventsCrudlMask(value);
    if (normalized == null || normalized.length <= index) return false;
    return normalized[index] == '1';
  }
  return false;
}

bool _commercePurchasesCrudlBit(Map<String, dynamic> permissions, int index) {
  final moduleData = permissions['COMMERCE'];
  if (moduleData is! Map) return false;
  final value = moduleData['purchases'];
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    final normalized = _normalizeMassiveEventsCrudlMask(value);
    if (normalized == null || normalized.length <= index) return false;
    return normalized[index] == '1';
  }
  return false;
}

/// Bit 0 del CRUDL de `PROD_CENTER` / `devices` (create).
bool devicesCrudlAllowsCreate(Map<String, dynamic> permissions) {
  return _devicesCrudlBit(permissions, 0);
}

bool _devicesCrudlBit(Map<String, dynamic> permissions, int index) {
  final moduleData = permissions['PROD_CENTER'];
  if (moduleData is! Map) return false;
  final value = moduleData['devices'];
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    final normalized = _normalizeMassiveEventsCrudlMask(value);
    if (normalized == null || normalized.length <= index) return false;
    return normalized[index] == '1';
  }
  return false;
}

/// Alineado con `ApplicationPermissionsService.normalizeCrudlMask` (Nest):
/// solo dígitos 0/1, recorte a 5 bits, máscaras cortas legacy de 2 bits.
String? _normalizeMassiveEventsCrudlMask(String raw) {
  final only01 = raw.trim().replaceAll(RegExp(r'[^01]'), '');
  if (only01.isEmpty) return null;
  if (only01.length >= 5) return only01.substring(0, 5);
  if (only01.length == 2) {
    return '0${only01[0]}${only01[1]}00';
  }
  return only01.padRight(5, '0');
}

bool _massiveEventsBitmaskBit(Map<String, dynamic> permissions, int index) {
  final moduleData = permissions['MASSIVE_EVENTS'];
  if (moduleData is! Map) return false;
  final value = moduleData['massive_events'];
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    final normalized = _normalizeMassiveEventsCrudlMask(value);
    if (normalized == null || normalized.length <= index) return false;
    return normalized[index] == '1';
  }
  return false;
}

/// Si la ruta [path] requiere permiso y el usuario no lo tiene, devuelve
/// `/home`. Si no aplica restricción o hay permiso, devuelve `null`.
String? routeAccessDeniedRedirect({
  required String path,
  required Map<String, dynamic> permissions,
  Map<String, String> queryParameters = const {},
}) {
  String? module;
  String? resource;

  if (path.startsWith('/massive-events')) {
    final canCreate = massiveEventsBitmaskAllowsCreate(permissions);
    final canList = massiveEventsBitmaskAllowsList(permissions);
    final isCreatePath =
        path == '/massive-events/create' ||
        path.startsWith('/massive-events/create/');
    final isEditPath =
        path == '/massive-events/edit' ||
        path.startsWith('/massive-events/edit/');
    if (isCreatePath) {
      if (!massiveEventsBitmaskAllowsCreate(permissions)) {
        return '/home';
      }
    } else if (isEditPath) {
      if (!massiveEventsBitmaskAllowsUpdate(permissions)) {
        return '/home';
      }
    } else {
      if (!canList && !canCreate) {
        return '/home';
      }
    }
    return null;
  } else if (path.startsWith('/sales/edit/')) {
    if (!commerceSalesAllowsUpdate(permissions)) {
      return '/home';
    }
    return null;
  } else if (path.startsWith('/sales')) {
    module = 'COMMERCE';
    resource = 'sales';
  } else if (path.startsWith('/cattle')) {
    module = 'FARM';
    resource = 'cattle';
  } else if (path.startsWith('/users')) {
    module = 'EMP_MGMT';
    resource = 'users';
  } else if (path.startsWith('/purchases/edit/')) {
    if (!commercePurchasesAllowsUpdate(permissions)) {
      return '/home';
    }
    return null;
  } else if (path.startsWith('/purchase/reception') ||
      path.startsWith('/purchases')) {
    module = 'COMMERCE';
    resource = 'purchases';
  } else if (path.startsWith('/equipment-resources/import')) {
    if (!devicesCrudlAllowsCreate(permissions)) {
      return '/home';
    }
    return null;
  } else if (path.startsWith('/equipment-resources')) {
    module = 'PROD_CENTER';
    resource = 'devices';
  } else if (path.startsWith('/devices/') &&
      path.contains('/remote-config')) {
    // Configuración remota de dispositivos MOKO LW001-BG PRO.
    // Requiere acceso al módulo PROD_CENTER, recurso remote_config.
    module = 'PROD_CENTER';
    resource = 'remote_config';
  }

  if (module == null || resource == null) return null;
  if (homeStyleResourceAllowed(permissions, module, resource)) {
    return null;
  }
  return '/home';
}

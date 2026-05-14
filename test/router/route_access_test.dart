import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/router/route_access.dart';

// Bajo prueba: lib/router/route_access.dart

void main() {
  group('homeStyleResourceAllowed', () {
    test('bool true → permitido', () {
      expect(
        homeStyleResourceAllowed(
          {
            'COMMERCE': <String, dynamic>{'sales': true},
          },
          'COMMERCE',
          'sales',
        ),
        isTrue,
      );
    });

    test('string "1" / "true" → permitido', () {
      expect(
        homeStyleResourceAllowed(
          {
            'FARM': <String, dynamic>{'cattle': '1'},
          },
          'FARM',
          'cattle',
        ),
        isTrue,
      );
      expect(
        homeStyleResourceAllowed(
          {
            'FARM': <String, dynamic>{'cattle': 'TRUE'},
          },
          'FARM',
          'cattle',
        ),
        isTrue,
      );
    });

    test('máscara CRUDL del backend (solo 0/1) → permitido si hay algún 1', () {
      expect(
        homeStyleResourceAllowed(
          {
            'FARM': <String, dynamic>{'cattle': '11111'},
          },
          'FARM',
          'cattle',
        ),
        isTrue,
      );
      expect(
        homeStyleResourceAllowed(
          {
            'MASSIVE_EVENTS': <String, dynamic>{'cattle': '01101'},
          },
          'MASSIVE_EVENTS',
          'cattle',
        ),
        isTrue,
      );
      expect(
        homeStyleResourceAllowed(
          {
            'COMMERCE': <String, dynamic>{'sales': '00000'},
          },
          'COMMERCE',
          'sales',
        ),
        isFalse,
      );
    });

    test('false o módulo ausente → denegado', () {
      expect(
        homeStyleResourceAllowed(
          {
            'COMMERCE': <String, dynamic>{'sales': false},
          },
          'COMMERCE',
          'sales',
        ),
        isFalse,
      );
      expect(
        homeStyleResourceAllowed(<String, dynamic>{}, 'COMMERCE', 'sales'),
        isFalse,
      );
    });
  });

  group('routeAccessDeniedRedirect', () {
    final fullPerms = <String, dynamic>{
      'COMMERCE': <String, dynamic>{'purchases': true, 'sales': true},
      'FARM': <String, dynamic>{'cattle': true},
      'EMP_MGMT': <String, dynamic>{'users': true},
      'MASSIVE_EVENTS': <String, dynamic>{'massive_events': true},
    };

    test('sin restricción conocida → null', () {
      expect(routeAccessDeniedRedirect(path: '/home', permissions: {}), isNull);
      expect(
        routeAccessDeniedRedirect(path: '/login', permissions: {}),
        isNull,
      );
      expect(
        routeAccessDeniedRedirect(path: '/dashboard', permissions: {}),
        isNull,
      );
    });

    test('massive-events sin permiso → /home', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/massive-events/create',
          permissions: {
            'EMP_MGMT': <String, dynamic>{'users': true},
          },
        ),
        '/home',
      );
    });

    test('massive-events con permiso → null', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/massive-events/create',
          permissions: fullPerms,
        ),
        isNull,
      );
    });

    test('/massive-events (lista) con create o list en máscara → null', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/massive-events',
          permissions: {
            'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '10000'},
          },
        ),
        isNull,
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/massive-events',
          permissions: {
            'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '00001'},
          },
        ),
        isNull,
      );
    });

    test('/massive-events/create solo con list (sin create) → /home', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/massive-events/create',
          permissions: {
            'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '00001'},
          },
        ),
        '/home',
      );
    });

    test('subrutas purchases y recepción usan COMMERCE.purchases', () {
      final onlySales = <String, dynamic>{
        'COMMERCE': <String, dynamic>{'sales': true},
      };
      expect(
        routeAccessDeniedRedirect(path: '/purchases', permissions: onlySales),
        '/home',
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/purchase/reception/abc',
          permissions: onlySales,
        ),
        '/home',
      );

      final purchases = <String, dynamic>{
        'COMMERCE': <String, dynamic>{'purchases': true},
      };
      expect(
        routeAccessDeniedRedirect(path: '/purchases', permissions: purchases),
        isNull,
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/purchase/reception/abc',
          permissions: purchases,
        ),
        isNull,
      );
    });

    test('/sales/create requiere COMMERCE.sales', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/sales/create',
          permissions: {
            'COMMERCE': <String, dynamic>{'purchases': true},
          },
        ),
        '/home',
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/sales/create',
          permissions: fullPerms,
        ),
        isNull,
      );
    });
  });
}

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

  group('massiveEventsBitmaskAllowsUpdate', () {
    test('máscara "11111" y variantes con espacios / basura → update permitido', () {
      final base = <String, dynamic>{
        'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '11111'},
      };
      expect(massiveEventsBitmaskAllowsUpdate(base), isTrue);
      expect(
        massiveEventsBitmaskAllowsUpdate({
          'MASSIVE_EVENTS': <String, dynamic>{'massive_events': ' 11111 '},
        }),
        isTrue,
      );
      expect(
        massiveEventsBitmaskAllowsUpdate({
          'MASSIVE_EVENTS': <String, dynamic>{
            'massive_events': '11\u200B111',
          },
        }),
        isTrue,
      );
    });

    test('solo bit update (00100) → true; sin update → false', () {
      expect(
        massiveEventsBitmaskAllowsUpdate({
          'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '00100'},
        }),
        isTrue,
      );
      expect(
        massiveEventsBitmaskAllowsUpdate({
          'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '10001'},
        }),
        isFalse,
      );
    });

    test('máscara legacy 2 bits "11" → update permitido (01100)', () {
      expect(
        massiveEventsBitmaskAllowsUpdate({
          'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '11'},
        }),
        isTrue,
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

    test(
      '/massive-events/edit?id= con solo create (sin update bitmask) → /home',
      () {
        expect(
          routeAccessDeniedRedirect(
            path: '/massive-events/edit',
            permissions: {
              'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '10000'},
            },
            queryParameters: {'id': 'abc-uuid'},
          ),
          '/home',
        );
      },
    );

    test(
      '/massive-events/edit?id= con solo list (sin create ni update) → /home',
      () {
        expect(
          routeAccessDeniedRedirect(
            path: '/massive-events/edit',
            permissions: {
              'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '00001'},
            },
            queryParameters: {'id': 'abc-uuid'},
          ),
          '/home',
        );
      },
    );

    test(
      '/massive-events/edit?id= con bit update en máscara → null',
      () {
        expect(
          routeAccessDeniedRedirect(
            path: '/massive-events/edit',
            permissions: {
              'MASSIVE_EVENTS': <String, dynamic>{'massive_events': '00100'},
            },
            queryParameters: {'id': 'abc-uuid'},
          ),
          isNull,
        );
      },
    );

    test('/purchases/edit/:id requiere bit update en purchases', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/purchases/edit/abc',
          permissions: {
            'COMMERCE': <String, dynamic>{'purchases': '10001'},
          },
        ),
        '/home',
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/purchases/edit/abc',
          permissions: {
            'COMMERCE': <String, dynamic>{'purchases': '00100'},
          },
        ),
        isNull,
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

    test('devicesCrudlAllowsCreate usa bit create del CRUDL devices', () {
      expect(
        devicesCrudlAllowsCreate({
          'PROD_CENTER': <String, dynamic>{'devices': '10000'},
        }),
        isTrue,
      );
      expect(
        devicesCrudlAllowsCreate({
          'PROD_CENTER': <String, dynamic>{'devices': '01000'},
        }),
        isFalse,
      );
    });

    test('/equipment-resources/import requiere create en devices', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/equipment-resources/import',
          permissions: {
            'PROD_CENTER': <String, dynamic>{'devices': '00001'},
          },
        ),
        '/home',
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/equipment-resources/import',
          permissions: {
            'PROD_CENTER': <String, dynamic>{'devices': '10000'},
          },
        ),
        isNull,
      );
    });

    test('/equipment-resources requiere PROD_CENTER.devices', () {
      expect(
        routeAccessDeniedRedirect(
          path: '/equipment-resources',
          permissions: {
            'FARM': <String, dynamic>{'cattle': true},
          },
        ),
        '/home',
      );
      expect(
        routeAccessDeniedRedirect(
          path: '/equipment-resources',
          permissions: {
            'PROD_CENTER': <String, dynamic>{'devices': '00001'},
          },
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

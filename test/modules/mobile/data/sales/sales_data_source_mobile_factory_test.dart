import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/mobile/data/sales/sales_data_source_mobile_interface.dart';
import 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web.dart';

// Bajo prueba: createSalesDataSource (móvil online-only → web/API)

void main() {
  test('factory móvil devuelve implementación web (solo API)', () {
    final ds = createSalesDataSource();
    expect(ds, isA<SalesDataSourceWeb>());
  });
}

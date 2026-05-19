import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_page_data_source_mobile_interface.dart';
import 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web.dart';

// Bajo prueba: createMassiveEventPageDataSource (móvil online-only → web/API)

void main() {
  test('factory móvil devuelve implementación web (solo API)', () {
    final ds = createMassiveEventPageDataSource();
    expect(ds, isA<MassiveEventPageDataSourceWeb>());
  });
}

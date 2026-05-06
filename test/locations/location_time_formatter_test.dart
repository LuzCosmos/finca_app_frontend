import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/utils/location_time_formatter.dart';

void main() {
  test('formatLocationTime: usa yyyy-MM-dd-HH:mm', () {
    final dt = DateTime.parse('2026-05-06T15:07:59.000Z');
    final out = formatLocationTime(dt);

    // No fijamos zona horaria en el test (depende del runner),
    // pero sí verificamos la forma y separadores.
    expect(out, matches(RegExp(r'^\d{4}-\d{2}-\d{2}-\d{2}:\d{2}$')));
  });
}


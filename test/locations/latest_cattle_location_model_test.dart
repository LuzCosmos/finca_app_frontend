import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/models/latest_cattle_location_model.dart';

void main() {
  test('LatestCattleLocationModel.fromJson: parsea snake_case y números string', () {
    final m = LatestCattleLocationModel.fromJson({
      'id_tenant': 't1',
      'id_device': 'd1',
      'id_cattle': 'c1',
      'latitude': '4.700200',
      'longitude': '-74.100200',
      'altitude': null,
      'time': '2026-05-01T12:00:00.000Z',
      'cattle_number': 'E2E-001',
    });

    expect(m.idTenant, 't1');
    expect(m.latitude, closeTo(4.7002, 0.000001));
    expect(m.longitude, closeTo(-74.1002, 0.000001));
    expect(m.altitude, isNull);
    expect(m.cattleNumber, 'E2E-001');
    expect(m.time.toUtc().toIso8601String(), '2026-05-01T12:00:00.000Z');
  });
}


import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/modules/shared/features/devices/models/device_list_item_model.dart';

void main() {
  group('DeviceListItemModel', () {
    test('fromJson parses summary fields', () {
      final model = DeviceListItemModel.fromJson({
        'id': 'id-1',
        'name': 'Collar',
        'deveui': '0102030405060708',
        'isActive': false,
        'batteryStatus': '75%',
        'deviceProfileName': 'LW001',
      });

      expect(model.isActive, isFalse);
      expect(model.batteryStatus, '75%');
      expect(model.deviceProfileName, 'LW001');
    });

    test('matchesQuery is case-insensitive on name and deveui', () {
      const model = DeviceListItemModel(
        id: '1',
        name: 'Alpha',
        deveui: 'AABBCCDDEEFF0011',
        isActive: true,
      );

      expect(model.matchesQuery('alpha'), isTrue);
      expect(model.matchesQuery('eeff'), isTrue);
      expect(model.matchesQuery('zzz'), isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';

void main() {
  group('BusinessPartnerModel', () {
    test('fromJson parsea type del API', () {
      final model = BusinessPartnerModel.fromJson({
        'id': 'uuid-1',
        'name': 'Comprador SA',
        'nit': '900123',
        'type': 'BUYER',
      });

      expect(model.id, 'uuid-1');
      expect(model.name, 'Comprador SA');
      expect(model.nit, '900123');
      expect(model.role, BusinessPartnerRole.BUYER);
    });

    test('toJson serializa role como type', () {
      final model = BusinessPartnerModel(
        id: 'uuid-2',
        name: 'Proveedor',
        nit: '800',
        role: BusinessPartnerRole.PROVIDER,
      );

      expect(model.toJson(), {
        'id': 'uuid-2',
        'name': 'Proveedor',
        'nit': '800',
        'type': 'PROVIDER',
      });
    });
  });
}

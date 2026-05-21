import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/utils/sale_min_weight_classification.dart';

SaleDetailModel _detail({
  required String id,
  required double measured,
  bool approved = true,
}) {
  return SaleDetailModel(
    id: id,
    cattleId: 'cattle-$id',
    cattleNumber: 'N$id',
    measuredWeight: measured,
    calculatedPrice: 100,
    isApproved: approved,
    rejectionReason: approved ? null : 'Peso insuficiente',
  );
}

void main() {
  group('SaleMinWeightClassification', () {
    test('partition mueve reses al subir el mínimo efectivo', () {
      final borderline = _detail(id: '1', measured: 320);
      final heavy = _detail(id: '2', measured: 400);

      final result = SaleMinWeightClassification.partition(
        [borderline, heavy],
        350,
        10,
        'Peso insuficiente',
      );

      expect(result.approved, hasLength(1));
      expect(result.approved.first.cattleId, 'cattle-2');
      expect(result.approved.first.calculatedPrice, 4000);
      expect(result.rejected, hasLength(1));
      expect(result.rejected.first.cattleId, 'cattle-1');
      expect(result.rejected.first.isApproved, isFalse);
    });

    test('partition aprueba reses al bajar el mínimo efectivo', () {
      final rejected = _detail(id: '1', measured: 320, approved: false);

      final result = SaleMinWeightClassification.partition(
        [rejected],
        300,
        10,
        'Peso insuficiente',
      );

      expect(result.approved, hasLength(1));
      expect(result.approved.first.cattleId, 'cattle-1');
      expect(result.approved.first.calculatedPrice, 3200);
      expect(result.rejected, isEmpty);
    });

    test('partition keeps approved when measured meets new minimum', () {
      final detail = _detail(id: '1', measured: 400);

      final result = SaleMinWeightClassification.partition(
        [detail],
        350,
        5,
        'Peso insuficiente',
      );

      expect(result.approved, hasLength(1));
      expect(result.rejected, isEmpty);
      expect(result.approved.first.calculatedPrice, 2000);
    });
  });
}

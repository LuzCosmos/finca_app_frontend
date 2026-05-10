import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/utils/dentition_receive_fields.dart';

void main() {
  group('dentitionFilledCount', () {
    test('cinco vacíos → 0', () {
      expect(dentitionFilledCount(['', '', '', '', '']), 0);
    });

    test('cinco con datos → 5', () {
      expect(
        dentitionFilledCount(['8', '0', '3', '0', '2024-01-01']),
        5,
      );
    });

    test('lista distinta de 5 lanza ArgumentError', () {
      expect(() => dentitionFilledCount(['a', 'b']), throwsArgumentError);
    });
  });

  group('dentitionHasPartialError', () {
    test('ninguno lleno → false', () {
      expect(dentitionHasPartialError(['', '', '', '', '']), isFalse);
    });

    test('solo fecha (núcleo vacío) → false — fecha puede ir por defecto', () {
      expect(
        dentitionHasPartialError(['', '', '', '', '2026-05-09']),
        isFalse,
      );
    });

    test('uno solo → true', () {
      expect(dentitionHasPartialError(['8', '', '', '', '']), isTrue);
    });

    test('cuatro de cinco → true', () {
      expect(
        dentitionHasPartialError(['8', '0', '3', '0', '']),
        isTrue,
      );
    });

    test('cinco completos → false', () {
      expect(
        dentitionHasPartialError(['8', '0', '3', '0', '2024-01-01']),
        isFalse,
      );
    });
  });

  group('dentitionIsCompleteFive', () {
    test('solo completo con 5 no vacíos', () {
      expect(dentitionIsCompleteFive(['', '', '', '', '']), isFalse);
      expect(
        dentitionIsCompleteFive(['8', '0', '3', '0', '2024-01-01']),
        isTrue,
      );
    });
  });

  group('dentitionWearVsCountIssue', () {
    test('null si coherente', () {
      expect(
        dentitionWearVsCountIssue(
          milkTeethCount: 8,
          permanentTeethCount: 0,
          milkTeethWear: 3,
          permanentTeethWear: 0,
        ),
        isNull,
      );
      expect(
        dentitionWearVsCountIssue(
          milkTeethCount: 0,
          permanentTeethCount: 8,
          milkTeethWear: 0,
          permanentTeethWear: 2,
        ),
        isNull,
      );
    });

    test('leche>0 y desgaste leche 0 → milkWearNaWithTeeth', () {
      expect(
        dentitionWearVsCountIssue(
          milkTeethCount: 8,
          permanentTeethCount: 0,
          milkTeethWear: 0,
          permanentTeethWear: 2,
        ),
        DentitionWearVsCountIssue.milkWearNaWithTeeth,
      );
    });

    test('permanentes>0 y desgaste perm 0 → permanentWearNaWithTeeth', () {
      expect(
        dentitionWearVsCountIssue(
          milkTeethCount: 0,
          permanentTeethCount: 8,
          milkTeethWear: 0,
          permanentTeethWear: 0,
        ),
        DentitionWearVsCountIssue.permanentWearNaWithTeeth,
      );
    });
  });

  group('dentitionWearGradesAllowedForSapCounts', () {
    test('8 leche + 0 permanentes: solo desgaste perm 0 con desgaste leche válido', () {
      expect(
        dentitionWearGradesAllowedForSapCounts(
          milkTeethCount: 8,
          permanentTeethCount: 0,
          milkTeethWear: 3,
          permanentTeethWear: 0,
        ),
        isTrue,
      );
      expect(
        dentitionWearGradesAllowedForSapCounts(
          milkTeethCount: 8,
          permanentTeethCount: 0,
          milkTeethWear: 3,
          permanentTeethWear: 2,
        ),
        isFalse,
      );
    });

    test('6 leche + 2 permanentes: intervalos SAPA', () {
      expect(
        dentitionWearGradesAllowedForSapCounts(
          milkTeethCount: 6,
          permanentTeethCount: 2,
          milkTeethWear: 3,
          permanentTeethWear: 1,
        ),
        isTrue,
      );
      expect(
        dentitionWearGradesAllowedForSapCounts(
          milkTeethCount: 6,
          permanentTeethCount: 2,
          milkTeethWear: 5,
          permanentTeethWear: 1,
        ),
        isFalse,
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/utils/dentition_receive_fields.dart';

void main() {
  group('dentitionFilledCount', () {
    test('cinco vacíos → 0', () {
      expect(dentitionFilledCount(['', '', '', '', '']), 0);
    });

    test('cinco con datos → 5', () {
      expect(
        dentitionFilledCount(['8', '0', '3', '2', '2024-01-01']),
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
        dentitionHasPartialError(['8', '0', '3', '2', '']),
        isTrue,
      );
    });

    test('cinco completos → false', () {
      expect(
        dentitionHasPartialError(['8', '0', '3', '2', '2024-01-01']),
        isFalse,
      );
    });
  });

  group('dentitionIsCompleteFive', () {
    test('solo completo con 5 no vacíos', () {
      expect(dentitionIsCompleteFive(['', '', '', '', '']), isFalse);
      expect(
        dentitionIsCompleteFive(['8', '0', '3', '2', '2024-01-01']),
        isTrue,
      );
    });
  });
}

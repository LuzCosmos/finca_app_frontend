import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/utils/reception_birth_date_usage_metrics.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReceptionBirthDateUsageMetrics', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('sin muestras suficientes → no quick fields', () async {
      await ReceptionBirthDateUsageMetrics.recordSubmission(
        usedDentition: true,
        usedManualOnly: false,
      );
      await ReceptionBirthDateUsageMetrics.recordSubmission(
        usedDentition: false,
        usedManualOnly: true,
      );
      expect(await ReceptionBirthDateUsageMetrics.shouldShowQuickDentitionFields(), isFalse);
    });

    test('≥5 muestras y más dentición que manual → quick fields', () async {
      for (var i = 0; i < 4; i++) {
        await ReceptionBirthDateUsageMetrics.recordSubmission(
          usedDentition: true,
          usedManualOnly: false,
        );
      }
      await ReceptionBirthDateUsageMetrics.recordSubmission(
        usedDentition: false,
        usedManualOnly: true,
      );
      expect(await ReceptionBirthDateUsageMetrics.shouldShowQuickDentitionFields(), isTrue);
    });
  });
}

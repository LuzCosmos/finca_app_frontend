import 'package:shared_preferences/shared_preferences.dart';

/// Métricas locales (por navegador/dispositivo) para decidir si mostrar el bloque
/// rápido de dentición en recepción: solo si hay muestra mínima y la mayoría de
/// envíos usaron dentición completa frente a fecha manual sola.
class ReceptionBirthDateUsageMetrics {
  ReceptionBirthDateUsageMetrics._();

  static const _keyDentition = 'reception_submit_birth_dentition_count';
  static const _keyManual = 'reception_submit_birth_manual_count';

  /// Mínimo de recepciones con algún dato de fecha (manual o dentición) antes
  /// de considerar mostrar campos rápidos.
  static const int minSamples = 5;

  static Future<void> recordSubmission({
    required bool usedDentition,
    required bool usedManualOnly,
  }) async {
    if (!usedDentition && !usedManualOnly) return;
    final p = await SharedPreferences.getInstance();
    if (usedDentition) {
      await p.setInt(_keyDentition, (p.getInt(_keyDentition) ?? 0) + 1);
    }
    if (usedManualOnly) {
      await p.setInt(_keyManual, (p.getInt(_keyManual) ?? 0) + 1);
    }
  }

  /// `true` si [minSamples] o más envíos con dato de fecha y más dentición que manual.
  static Future<bool> shouldShowQuickDentitionFields() async {
    final p = await SharedPreferences.getInstance();
    final d = p.getInt(_keyDentition) ?? 0;
    final m = p.getInt(_keyManual) ?? 0;
    final total = d + m;
    if (total < minSamples) return false;
    return d > m;
  }
}

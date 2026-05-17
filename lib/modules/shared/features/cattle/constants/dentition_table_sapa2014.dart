/// Tabla de estimación de edad por dentición (**SAPA2014**), mismas filas que el backend
/// (`dentition-table-sapa2014.ts`).
///
/// **SAPA2014** es la etiqueta interna de FincaApp para la tabla tomada de la obra
/// «Edad y dientes de los bovinos», SAPA (*Sitio Argentino de Producción Animal*) /
/// BM Editores, 2014 — no es un estándar ISO. Documentación: `finca_app_docs/edad_bovinos/tabla_edad_bovinos_dientes.md`.
///
/// Sirve para limitar los grados de desgaste visibles según el par (leche, permanente).
class DentitionRuleRow {
  const DentitionRuleRow({
    required this.milkTeeth,
    required this.permanentTeeth,
    required this.milkWearMin,
    required this.milkWearMax,
    required this.permWearMin,
    required this.permWearMax,
    required this.ageDays,
  });

  final int milkTeeth;
  final int permanentTeeth;
  final int milkWearMin;
  final int milkWearMax;
  final int permWearMin;
  final int permWearMax;
  final int ageDays;
}

/// Filas SAPA2014 (véase comentario de librería arriba).
/// Sin solapamiento por fila en la práctica de matching del backend.
const List<DentitionRuleRow> kSapa2014DentitionRules = [
  DentitionRuleRow(milkTeeth: 2, permanentTeeth: 0, milkWearMin: 1, milkWearMax: 1, permWearMin: 0, permWearMax: 5, ageDays: 0),
  DentitionRuleRow(milkTeeth: 4, permanentTeeth: 0, milkWearMin: 1, milkWearMax: 1, permWearMin: 0, permWearMax: 5, ageDays: 7),
  DentitionRuleRow(milkTeeth: 6, permanentTeeth: 0, milkWearMin: 1, milkWearMax: 1, permWearMin: 0, permWearMax: 5, ageDays: 21),
  DentitionRuleRow(milkTeeth: 8, permanentTeeth: 0, milkWearMin: 1, milkWearMax: 1, permWearMin: 0, permWearMax: 5, ageDays: 30),
  DentitionRuleRow(milkTeeth: 8, permanentTeeth: 0, milkWearMin: 2, milkWearMax: 2, permWearMin: 0, permWearMax: 5, ageDays: 183),
  DentitionRuleRow(milkTeeth: 8, permanentTeeth: 0, milkWearMin: 3, milkWearMax: 3, permWearMin: 0, permWearMax: 5, ageDays: 365),
  DentitionRuleRow(milkTeeth: 8, permanentTeeth: 0, milkWearMin: 4, milkWearMax: 4, permWearMin: 0, permWearMax: 5, ageDays: 548),
  DentitionRuleRow(milkTeeth: 8, permanentTeeth: 0, milkWearMin: 5, milkWearMax: 5, permWearMin: 0, permWearMax: 5, ageDays: 640),
  DentitionRuleRow(milkTeeth: 6, permanentTeeth: 2, milkWearMin: 3, milkWearMax: 4, permWearMin: 1, permWearMax: 2, ageDays: 730),
  DentitionRuleRow(milkTeeth: 4, permanentTeeth: 4, milkWearMin: 3, milkWearMax: 4, permWearMin: 1, permWearMax: 2, ageDays: 1095),
  DentitionRuleRow(milkTeeth: 2, permanentTeeth: 6, milkWearMin: 4, milkWearMax: 4, permWearMin: 1, permWearMax: 2, ageDays: 1460),
  DentitionRuleRow(milkTeeth: 0, permanentTeeth: 8, milkWearMin: 0, milkWearMax: 5, permWearMin: 1, permWearMax: 2, ageDays: 1825),
  DentitionRuleRow(milkTeeth: 0, permanentTeeth: 8, milkWearMin: 0, milkWearMax: 5, permWearMin: 3, permWearMax: 3, ageDays: 2190),
  DentitionRuleRow(milkTeeth: 0, permanentTeeth: 8, milkWearMin: 0, milkWearMax: 5, permWearMin: 4, permWearMax: 4, ageDays: 2920),
  DentitionRuleRow(milkTeeth: 0, permanentTeeth: 8, milkWearMin: 0, milkWearMax: 5, permWearMin: 5, permWearMax: 5, ageDays: 4745),
];

Set<int> _fullWearGrades() => {0, 1, 2, 3, 4, 5};

/// Grados de desgaste de leche permitidos para el par de conteos (unión de intervalos SAPA).
/// Si los conteos no tienen fila en la tabla, se muestran todos los grados (formulario aún editable).
Set<int> allowedMilkWearGradesForSapCounts(int milkTeeth, int permanentTeeth) {
  final rules =
      kSapa2014DentitionRules.where((r) => r.milkTeeth == milkTeeth && r.permanentTeeth == permanentTeeth);
  if (rules.isEmpty) return _fullWearGrades();
  final out = <int>{};
  for (final r in rules) {
    for (var g = r.milkWearMin; g <= r.milkWearMax; g++) {
      out.add(g);
    }
  }
  return out;
}

/// Grados de desgaste de permanentes permitidos para el par de conteos.
/// Sin dientes permanentes visibles: solo «no aplica» (0), alineado con la columna «No aplica» en la tabla clínica.
Set<int> allowedPermanentWearGradesForSapCounts(int milkTeeth, int permanentTeeth) {
  if (permanentTeeth == 0) return {0};
  final rules =
      kSapa2014DentitionRules.where((r) => r.milkTeeth == milkTeeth && r.permanentTeeth == permanentTeeth);
  if (rules.isEmpty) return _fullWearGrades();
  final out = <int>{};
  for (final r in rules) {
    for (var g = r.permWearMin; g <= r.permWearMax; g++) {
      out.add(g);
    }
  }
  return out;
}

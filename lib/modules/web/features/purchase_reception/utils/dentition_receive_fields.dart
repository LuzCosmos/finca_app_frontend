// Reglas SAPA2014: ver comentario en dentition_table_sapa2014.dart (fuente bibliográfica).
import 'package:finca_app_frontend/modules/web/features/cattle/constants/dentition_table_sapa2014.dart';

/// Reglas de los 5 campos de dentición en recepción / diálogos (todos o ninguno; 5 = completo).
int dentitionFilledCount(List<String> fiveTrimmedFields) {
  if (fiveTrimmedFields.length != 5) {
    throw ArgumentError.value(
      fiveTrimmedFields.length,
      'fiveTrimmedFields',
      'se esperan exactamente 5 strings',
    );
  }
  return fiveTrimmedFields.where((s) => s.isNotEmpty).length;
}

/// Error de dominio: el usuario empezó a llenar dentición pero faltan campos.
///
/// Solo cuentan como “inicio” los cuatro primeros valores (dos conteos y dos
/// desgastes). La fecha puede venir precargada sin obligar a completar dentición.
bool dentitionHasPartialError(List<String> fiveTrimmedFields) {
  final coreFilled =
      fiveTrimmedFields.take(4).where((s) => s.isNotEmpty).length;
  if (coreFilled == 0) return false;
  return dentitionFilledCount(fiveTrimmedFields) != 5;
}

bool dentitionIsCompleteFive(List<String> fiveTrimmedFields) =>
    dentitionFilledCount(fiveTrimmedFields) == 5;

/// Conflicto: grado de desgaste 0 («no aplica») con cantidad > 0 en ese tipo de diente.
enum DentitionWearVsCountIssue {
  milkWearNaWithTeeth,
  permanentWearNaWithTeeth,
}

/// Si hay dientes de leche o permanentes (>0), el desgaste correspondiente no puede ser 0.
DentitionWearVsCountIssue? dentitionWearVsCountIssue({
  required int milkTeethCount,
  required int permanentTeethCount,
  required int milkTeethWear,
  required int permanentTeethWear,
}) {
  if (milkTeethCount > 0 && milkTeethWear == 0) {
    return DentitionWearVsCountIssue.milkWearNaWithTeeth;
  }
  if (permanentTeethCount > 0 && permanentTeethWear == 0) {
    return DentitionWearVsCountIssue.permanentWearNaWithTeeth;
  }
  return null;
}

/// True si los grados de desgaste son coherentes con la tabla SAPA 2014 para ese par de conteos.
bool dentitionWearGradesAllowedForSapCounts({
  required int milkTeethCount,
  required int permanentTeethCount,
  required int milkTeethWear,
  required int permanentTeethWear,
}) {
  final milkOk = allowedMilkWearGradesForSapCounts(
    milkTeethCount,
    permanentTeethCount,
  ).contains(milkTeethWear);
  final permOk = allowedPermanentWearGradesForSapCounts(
    milkTeethCount,
    permanentTeethCount,
  ).contains(permanentTeethWear);
  return milkOk && permOk;
}

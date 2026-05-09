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

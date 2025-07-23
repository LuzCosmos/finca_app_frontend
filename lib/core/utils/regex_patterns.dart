class RegexPatterns {
  // ✅ Validaciones finales
  static final RegExp positiveInteger = RegExp(r'^[0-9]+$');
  static final RegExp positiveIntegerNoZero = RegExp(r'^[1-9][0-9]*$');
  static final RegExp email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp onlyLettersSpanish = RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$');
  static final RegExp alphanumeric = RegExp(r'^[A-Za-z0-9 ]+$');
  static final RegExp onlyLettersEnglish = RegExp(r'^[A-Za-z ]+$');
  static final RegExp positiveDecimalTwoDigits = RegExp(r'^\d+(\.\d{1,2})?$');
  static final RegExp positiveDecimalTwoDigitsNoZero = RegExp(
    r'^[1-9][0-9]*(\.\d{1,2})?$',
  );
  //static final RegExp cattleAge = RegExp(r'^\d [0-9]{1,2}/[0-9]{1,2}$');
  static final RegExp cattleAge = RegExp(r'^(\d|(\d [0-9]{1,2}/[0-9]{1,2}))$');

  // ✅ Versiones permisivas para usar en FilteringTextInputFormatter
  static final RegExp permissivePositiveInteger = RegExp(r'^\d*');
  // Permite números enteros mientras se escribe (puede estar vacío)

  static final RegExp permissivePositiveDecimalTwoDigits = RegExp(
    r'^\d*\.?\d{0,2}',
  );
  // Permite ir escribiendo decimales, incluso solo punto o nada

  static final RegExp permissiveCattleAge = RegExp(r'^[0-9 /]*$');
  // Permite ir escribiendo dígito, espacio, números y la barra poco a poco
}

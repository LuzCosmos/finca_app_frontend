import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(
        255,
        152,
        175,
        152,
      ), // verde más suave y menos saturado
      //brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF7CA77C), // Verde principal más suave
      onPrimary: Colors.white, // Texto en contraste cuando sea necesario
      primaryContainer: const Color(0xFFBFD9BF), // Verde muy claro para fondos
      //secondary: const Color(0xFF9BC89B), // Verde complementario suave
      //onSecondary: Colors.black, // Texto oscuro sobre fondos secundarios
      surface: const Color(0xFFF9FBF9), // Fondo claro
      onSurface: const Color(0xFF333533), // Texto principal oscuro
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7CA77C), // Verde más suave para AppBar
      foregroundColor: Colors.white, // Texto e íconos en AppBar
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE8F2E8), // Fondo claro para botones
        foregroundColor: const Color(
          0xFF7CA77C,
        ), // Texto por defecto oscuro para no saturar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(
          0xFF7CA77C,
        ), // Verde suave para texto de botón
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F5F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB5D6B4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7CA77C), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF374137)),
    ),
  );
}

class AppThemeDark {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6CA36C), // un verde suave como base
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF6CA36C), // Verde principal suave
      onPrimary: Colors.white, // Texto en botones primarios
      primaryContainer: const Color(0xFFAED9A7), // Verde más claro para fondos
      secondary: const Color(0xFF8BC48A), // Otro verde complementario
      onSecondary: Colors.white,
      surface: const Color(0xFFF8FBF6), // Fondo general muy claro
      onSurface: const Color(0xFF374137), // Texto en fondo claro
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6CA36C),
      foregroundColor: Colors.white, // Texto e íconos en AppBar
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6CA36C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6CA36C),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F5F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB5D6B4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6CA36C), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF374137)),
    ),
  );
}

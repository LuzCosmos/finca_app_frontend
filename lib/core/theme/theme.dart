import 'package:flutter/material.dart';


class AppTheme {
  
  // 0xFF7CA77C first green
  // 0xFF6CA36C
  // 014325
  static const Color kPrimary = Color(0xFF2C5545);

  // Un "inversePrimary" claro y coherente con 2C5545 (verde suave, no menta neón)
  static const Color kInversePrimary = Color(0xFF9FD4C0);

  // Container más claro derivado (puedes cambiarlo si lo quieres más oscuro/claro)
  static const Color kPrimaryContainer = Color(0xFF4F7A69);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: kPrimary,
      onPrimary: Colors.white,

      inversePrimary: kInversePrimary,

      primaryContainer: kPrimaryContainer,
      onPrimaryContainer: Colors.white,

      // Puedes dejar tus secundarios tal cual o afinarlos luego
      secondary: const Color(0xFF6FA88B),
      onSecondary: const Color(0xFF0F241B),

      surface: const Color(0xFFF6FAF8),
      onSurface: const Color(0xFF1E2D26),

      background: const Color(0xFFF6FAF8),
      onBackground: const Color(0xFF1E2D26),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      // Útil en Material 3 para evitar “tint” raro
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(kPrimary),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(
        color: kPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF1E2D26),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF1E2D26),
      ),
    ),
  );
}
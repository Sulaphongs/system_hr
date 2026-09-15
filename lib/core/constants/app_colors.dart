import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFEC3237);
  static const Color primaryLight = Color(0xFFFF6B6E);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color accent = Color(0xFFEC3237);
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color sidebarBg = Color(0xFF2D0A0B);
  static const Color sidebarText = Color(0xFFFFCDD2);
  static const Color sidebarActive = Color(0xFFEC3237);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEC3237);
  static const Color info = Color(0xFF29B6F6);

  static const Color textPrimary = Color(0xFF1A0506);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color divider = Color(0xFFFFE0E1);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: textPrimary,
        ).copyWith(
          surfaceContainerHighest: Colors.white,
          surfaceContainerHigh: Colors.white,
          surfaceContainer: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainerLowest: Colors.white,
          surfaceTint: Colors.transparent,
        ),
        useMaterial3: true,
        fontFamily: 'PhetsarathOT',
        scaffoldBackgroundColor: background,
        cardTheme: const CardThemeData(
          elevation: 1,
          color: surface,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xFFFFCDD2),
          indicatorColor: Colors.white,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: appColorsDark.background,
      colorScheme: ColorScheme.dark(
        surface: appColorsDark.surface,
        primary: appColorsDark.gold,
        onPrimary: const Color(0xFF080808),
        secondary: appColorsDark.phase2,
        onSecondary: const Color(0xFF080808),
        error: appColorsDark.error,
        onSurface: appColorsDark.textPrimary,
        surfaceContainerHighest: appColorsDark.surfaceVariant,
      ),
      extensions: const [appColorsDark],
      cardTheme: CardThemeData(
        color: appColorsDark.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: appColorsDark.surface,
        indicatorColor: appColorsDark.phase1Muted,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: appColorsDark.textSecondary, fontSize: 12),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: appColorsDark.textSecondary),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: appColorsDark.divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColorsDark.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: appColorsDark.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appColorsDark.textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: TextStyle(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        headlineSmall: TextStyle(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: appColorsDark.textPrimary),
        titleSmall: TextStyle(color: appColorsDark.textSecondary),
        bodyLarge: TextStyle(color: appColorsDark.textPrimary),
        bodyMedium: TextStyle(color: appColorsDark.textPrimary),
        bodySmall:
            TextStyle(color: appColorsDark.textSecondary, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: appColorsDark.textSecondary),
        labelSmall: TextStyle(
            color: appColorsDark.textSecondary, fontSize: 11, letterSpacing: 0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColorsDark.gold,
          foregroundColor: const Color(0xFF080808),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColorsDark.textSecondary,
          side: BorderSide(color: appColorsDark.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColorsDark.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColorsDark.gold, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle:
            TextStyle(color: appColorsDark.textSecondary, fontSize: 14),
        labelStyle: TextStyle(color: appColorsDark.textSecondary),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: appColorsLight.background,
      colorScheme: ColorScheme.light(
        surface: appColorsLight.surface,
        primary: appColorsLight.gold,
        onPrimary: const Color(0xFFFFFFFF),
        secondary: appColorsLight.phase2,
        onSecondary: const Color(0xFFFFFFFF),
        error: appColorsLight.error,
        onSurface: appColorsLight.textPrimary,
        surfaceContainerHighest: appColorsLight.surfaceVariant,
      ),
      extensions: const [appColorsLight],
      cardTheme: CardThemeData(
        color: appColorsLight.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: appColorsLight.surface,
        indicatorColor: appColorsLight.phase1Muted,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: appColorsLight.textSecondary, fontSize: 12),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: appColorsLight.textSecondary),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: appColorsLight.divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColorsLight.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: appColorsLight.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appColorsLight.textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: TextStyle(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        headlineSmall: TextStyle(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: appColorsLight.textPrimary),
        titleSmall: TextStyle(color: appColorsLight.textSecondary),
        bodyLarge: TextStyle(color: appColorsLight.textPrimary),
        bodyMedium: TextStyle(color: appColorsLight.textPrimary),
        bodySmall:
            TextStyle(color: appColorsLight.textSecondary, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: appColorsLight.textSecondary),
        labelSmall: TextStyle(
            color: appColorsLight.textSecondary, fontSize: 11, letterSpacing: 0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColorsLight.gold,
          foregroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColorsLight.textSecondary,
          side: BorderSide(color: appColorsLight.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColorsLight.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColorsLight.gold, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle:
            TextStyle(color: appColorsLight.textSecondary, fontSize: 14),
        labelStyle: TextStyle(color: appColorsLight.textSecondary),
      ),
    );
  }
}

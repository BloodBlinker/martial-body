import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark {
    final baseTextTheme = Typography.material2021().black;
    final outFit = GoogleFonts.outfitTextTheme(baseTextTheme);
    final inter = GoogleFonts.interTextTheme(baseTextTheme);
    
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
          inter.labelSmall?.copyWith(color: appColorsDark.textSecondary, fontSize: 12),
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
        titleTextStyle: outFit.titleLarge?.copyWith(
          color: appColorsDark.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appColorsDark.textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: outFit.headlineLarge?.copyWith(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: outFit.headlineMedium?.copyWith(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        headlineSmall: outFit.headlineSmall?.copyWith(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: outFit.titleLarge?.copyWith(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: outFit.titleMedium?.copyWith(color: appColorsDark.textPrimary),
        titleSmall: outFit.titleSmall?.copyWith(color: appColorsDark.textSecondary),
        bodyLarge: inter.bodyLarge?.copyWith(color: appColorsDark.textPrimary),
        bodyMedium: inter.bodyMedium?.copyWith(color: appColorsDark.textPrimary),
        bodySmall: inter.bodySmall?.copyWith(
            color: appColorsDark.textSecondary, fontSize: 12, height: 1.4),
        labelLarge: inter.labelLarge?.copyWith(
            color: appColorsDark.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: inter.labelMedium?.copyWith(color: appColorsDark.textSecondary),
        labelSmall: inter.labelSmall?.copyWith(
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
          textStyle: outFit.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: appColorsDark.gold,
          foregroundColor: const Color(0xFF080808),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: outFit.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColorsDark.textSecondary,
          side: BorderSide(color: appColorsDark.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: inter.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
            inter.bodyMedium?.copyWith(color: appColorsDark.textSecondary, fontSize: 14),
        labelStyle: inter.bodyMedium?.copyWith(color: appColorsDark.textSecondary),
      ),
    );
  }

  static ThemeData get light {
    final baseTextTheme = Typography.material2021().black;
    final outFit = GoogleFonts.outfitTextTheme(baseTextTheme);
    final inter = GoogleFonts.interTextTheme(baseTextTheme);

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
          inter.labelSmall?.copyWith(color: appColorsLight.textSecondary, fontSize: 12),
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
        titleTextStyle: outFit.titleLarge?.copyWith(
          color: appColorsLight.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: appColorsLight.textPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: outFit.headlineLarge?.copyWith(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: outFit.headlineMedium?.copyWith(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        headlineSmall: outFit.headlineSmall?.copyWith(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: outFit.titleLarge?.copyWith(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: outFit.titleMedium?.copyWith(color: appColorsLight.textPrimary),
        titleSmall: outFit.titleSmall?.copyWith(color: appColorsLight.textSecondary),
        bodyLarge: inter.bodyLarge?.copyWith(color: appColorsLight.textPrimary),
        bodyMedium: inter.bodyMedium?.copyWith(color: appColorsLight.textPrimary),
        bodySmall: inter.bodySmall?.copyWith(
            color: appColorsLight.textSecondary, fontSize: 12, height: 1.4),
        labelLarge: inter.labelLarge?.copyWith(
            color: appColorsLight.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: inter.labelMedium?.copyWith(color: appColorsLight.textSecondary),
        labelSmall: inter.labelSmall?.copyWith(
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
          textStyle: outFit.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: appColorsLight.gold,
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: outFit.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColorsLight.textSecondary,
          side: BorderSide(color: appColorsLight.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: inter.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
            inter.bodyMedium?.copyWith(color: appColorsLight.textSecondary, fontSize: 14),
        labelStyle: inter.bodyMedium?.copyWith(color: appColorsLight.textSecondary),
      ),
    );
  }
}

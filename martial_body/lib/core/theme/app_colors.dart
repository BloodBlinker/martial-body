import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color divider;
  final Color gold;
  
  final Color phase1;
  final Color phase2;
  final Color phase3;
  final Color phase4;
  final Color deload;

  final Color phase1Muted;
  final Color phase2Muted;
  final Color phase3Muted;
  final Color phase4Muted;
  final Color deloadMuted;

  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.divider,
    required this.gold,
    required this.phase1,
    required this.phase2,
    required this.phase3,
    required this.phase4,
    required this.deload,
    required this.phase1Muted,
    required this.phase2Muted,
    required this.phase3Muted,
    required this.phase4Muted,
    required this.deloadMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
  });

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? divider,
    Color? gold,
    Color? phase1,
    Color? phase2,
    Color? phase3,
    Color? phase4,
    Color? deload,
    Color? phase1Muted,
    Color? phase2Muted,
    Color? phase3Muted,
    Color? phase4Muted,
    Color? deloadMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? error,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      divider: divider ?? this.divider,
      gold: gold ?? this.gold,
      phase1: phase1 ?? this.phase1,
      phase2: phase2 ?? this.phase2,
      phase3: phase3 ?? this.phase3,
      phase4: phase4 ?? this.phase4,
      deload: deload ?? this.deload,
      phase1Muted: phase1Muted ?? this.phase1Muted,
      phase2Muted: phase2Muted ?? this.phase2Muted,
      phase3Muted: phase3Muted ?? this.phase3Muted,
      phase4Muted: phase4Muted ?? this.phase4Muted,
      deloadMuted: deloadMuted ?? this.deloadMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      phase1: Color.lerp(phase1, other.phase1, t)!,
      phase2: Color.lerp(phase2, other.phase2, t)!,
      phase3: Color.lerp(phase3, other.phase3, t)!,
      phase4: Color.lerp(phase4, other.phase4, t)!,
      deload: Color.lerp(deload, other.deload, t)!,
      phase1Muted: Color.lerp(phase1Muted, other.phase1Muted, t)!,
      phase2Muted: Color.lerp(phase2Muted, other.phase2Muted, t)!,
      phase3Muted: Color.lerp(phase3Muted, other.phase3Muted, t)!,
      phase4Muted: Color.lerp(phase4Muted, other.phase4Muted, t)!,
      deloadMuted: Color.lerp(deloadMuted, other.deloadMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }

  Color phaseColor(int phase) {
    switch (phase) {
      case 1: return phase1;
      case 2: return phase2;
      case 3: return phase3;
      case 4: return phase4;
      default: return phase1;
    }
  }

  Color phaseMutedColor(int phase) {
    switch (phase) {
      case 1: return phase1Muted;
      case 2: return phase2Muted;
      case 3: return phase3Muted;
      case 4: return phase4Muted;
      default: return phase1Muted;
    }
  }
}

extension AppColorsBuildContextExt on BuildContext {
  AppColorsExtension get appColors => Theme.of(this).extension<AppColorsExtension>()!;
}

const appColorsDark = AppColorsExtension(
  background: Color(0xFF080808),
  surface: Color(0xFF111111),
  surfaceVariant: Color(0xFF1A1A1A),
  divider: Color(0xFF252525),
  gold: Color(0xFFD4A843),
  phase1: Color(0xFFD4A843),
  phase2: Color(0xFFE07A3C),
  phase3: Color(0xFFD44C4C),
  phase4: Color(0xFF4A8FCC),
  deload: Color(0xFFD49A38),
  phase1Muted: Color(0x26D4A843),
  phase2Muted: Color(0x26E07A3C),
  phase3Muted: Color(0x26D44C4C),
  phase4Muted: Color(0x264A8FCC),
  deloadMuted: Color(0x26D49A38),
  textPrimary: Color(0xFFF2ECD8),
  textSecondary: Color(0xFF7A6E5E),
  error: Color(0xFFD44C4C),
);

const appColorsLight = AppColorsExtension(
  background: Color(0xFFF0F2F5),
  surface: Color(0xFFFFFFFF),
  surfaceVariant: Color(0xFFE4E7EB),
  divider: Color(0xFFD1D5DB),
  gold: Color(0xFFC49A38),
  phase1: Color(0xFFC49A38),
  phase2: Color(0xFFD26D30),
  phase3: Color(0xFFC04343),
  phase4: Color(0xFF4280B8),
  deload: Color(0xFFC48D30),
  phase1Muted: Color(0x1AC49A38),
  phase2Muted: Color(0x1AD26D30),
  phase3Muted: Color(0x1AC04343),
  phase4Muted: Color(0x1A4280B8),
  deloadMuted: Color(0x1AC48D30),
  textPrimary: Color(0xFF1F2937),
  textSecondary: Color(0xFF4B5563),
  error: Color(0xFFC04343),
);

// We define AppColors internally to not break other files in case we missed them,
// but they shouldn't be used going forward.
class AppColors {
  static const Color background = Color(0xFF080808);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color divider = Color(0xFF252525);
  static const Color gold = Color(0xFFD4A843);
  static const Color phase1 = Color(0xFFD4A843);
  static const Color phase2 = Color(0xFFE07A3C);
  static const Color phase3 = Color(0xFFD44C4C);
  static const Color phase4 = Color(0xFF4A8FCC);
  static const Color deload = Color(0xFFD49A38);
  static const Color phase1Muted = Color(0x26D4A843);
  static const Color phase2Muted = Color(0x26E07A3C);
  static const Color phase3Muted = Color(0x26D44C4C);
  static const Color phase4Muted = Color(0x264A8FCC);
  static const Color deloadMuted = Color(0x26D49A38);
  static const Color textPrimary = Color(0xFFF2ECD8);
  static const Color textSecondary = Color(0xFF7A6E5E);
  static const Color error = Color(0xFFD44C4C);

  static Color phaseColor(int phase) {
    switch (phase) {
      case 1: return phase1;
      case 2: return phase2;
      case 3: return phase3;
      case 4: return phase4;
      default: return phase1;
    }
  }

  static Color phaseMutedColor(int phase) {
    switch (phase) {
      case 1: return phase1Muted;
      case 2: return phase2Muted;
      case 3: return phase3Muted;
      case 4: return phase4Muted;
      default: return phase1Muted;
    }
  }
}
